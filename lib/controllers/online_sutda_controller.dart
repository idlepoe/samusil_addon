import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/online_sutda_game.dart';
import '../models/sutda_card.dart';
import '../controllers/profile_controller.dart';
import '../components/appSnackbar.dart';
import 'dart:developer' as developer;

class OnlineSutdaController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ProfileController _profileController = ProfileController.to;

  // 게임 상태
  final currentGame = Rxn<OnlineSutdaGame>();
  final isSearchingGame = false.obs;
  final isMyTurn = false.obs;
  final myPlayerIndex = (-1).obs;

  // UI 상태
  final showOpponentCards = false.obs;
  final gameResult = ''.obs;
  final isWinner = false.obs;

  // 베팅 타이머
  final bettingTimeLeft = 30.obs;
  final isBettingTimerActive = false.obs;
  Timer? _bettingTimer;

  StreamSubscription<DocumentSnapshot>? _gameSubscription;
  Timer? _searchTimer;

  @override
  void onClose() {
    _gameSubscription?.cancel();
    _searchTimer?.cancel();
    _stopBettingTimer(); // 타이머 정리
    super.onClose();
  }

  // 게임 찾기 시작
  Future<void> startSearchingGame() async {
    try {
      isSearchingGame.value = true;
      AppSnackbar.info('게임을 찾는 중입니다...');

      // 기존 대기 중인 게임이 있는지 확인
      final existingGame = await _findWaitingGame();

      if (existingGame != null) {
        developer.log('기존 게임 발견, 참여 중: ${existingGame.gameId}');
        // 기존 게임에 참여
        await _joinGame(existingGame);
      } else {
        developer.log('대기 중인 게임이 없음, 새 게임 생성');
        // 새 게임 생성
        await _createNewGame();
      }
    } catch (e) {
      developer.log('게임 검색 오류: $e');
      AppSnackbar.error('게임 검색 중 오류가 발생했습니다: $e');
      isSearchingGame.value = false;
    }
  }

  // 대기 중인 게임 찾기
  Future<OnlineSutdaGame?> _findWaitingGame() async {
    try {
      final snapshot =
          await _firestore
              .collection('online_sutda_games')
              .where('gameState', isEqualTo: OnlineGameState.waiting.name)
              .where('isGameStarted', isEqualTo: false)
              .limit(1)
              .get();

      developer.log('대기 중인 게임 검색 결과: ${snapshot.docs.length}개');

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final gameData = doc.data();
        gameData['gameId'] = doc.id; // gameId 추가

        final game = OnlineSutdaGame.fromJson(gameData);

        // 이미 참여한 게임인지 확인
        final isAlreadyJoined = game.players.any(
          (player) => player.playerId == _profileController.uid,
        );

        if (isAlreadyJoined) {
          developer.log('이미 참여한 게임입니다: ${game.gameId}');
          return null;
        }

        developer.log('참여 가능한 게임 발견: ${game.gameId}');
        return game;
      }

      developer.log('대기 중인 게임이 없습니다');
      return null;
    } catch (e) {
      developer.log('게임 검색 중 오류: $e');
      return null;
    }
  }

  // 새 게임 생성
  Future<void> _createNewGame() async {
    try {
      final gameId = _firestore.collection('online_sutda_games').doc().id;
      developer.log('새 게임 생성 시작: $gameId');

      final newGame = OnlineSutdaGame(
        gameId: gameId,
        gameState: OnlineGameState.waiting,
        players: [
          OnlineSutdaPlayer(
            playerId: _profileController.uid,
            playerName: _profileController.userName,
            photoUrl: _profileController.profileImageUrl,
            cards: [],
            totalBet: 0,
            hasFolded: false,
            isConnected: true,
            points: _profileController.point,
          ),
        ],
        currentPlayerIndex: 0,
        pot: 0,
        baseBet: 100, // 기본 베팅 금액
        currentBet: 0,
        round: 1,
        bettingHistory: ['게임이 생성되었습니다.'],
        createdAt: DateTime.now(),
        startedAt: null,
        isGameStarted: false,
        maxPlayers: 2,
      );

      // JSON으로 변환하여 저장
      final gameData = newGame.toJson();
      gameData.remove('gameId'); // gameId는 문서 ID로 사용하므로 제거

      developer.log('게임 데이터 저장 중...');
      await _firestore
          .collection('online_sutda_games')
          .doc(gameId)
          .set(gameData);

      developer.log('게임 생성 완료, 리스닝 시작');
      _listenToGame(gameId);
      myPlayerIndex.value = 0;

      AppSnackbar.success('게임룸이 생성되었습니다. 상대방을 기다리는 중...');
    } catch (e) {
      developer.log('새 게임 생성 오류: $e');
      AppSnackbar.error('게임 생성 중 오류가 발생했습니다: $e');
      isSearchingGame.value = false;
    }
  }

  // 기존 게임에 참여
  Future<void> _joinGame(OnlineSutdaGame game) async {
    final updatedPlayers = List<OnlineSutdaPlayer>.from(game.players);
    updatedPlayers.add(
      OnlineSutdaPlayer(
        playerId: _profileController.uid,
        playerName: _profileController.userName,
        photoUrl: _profileController.profileImageUrl,
        cards: [],
        totalBet: 0,
        hasFolded: false,
        isConnected: true,
        points: _profileController.point,
      ),
    );

    final updatedGame = game.copyWith(
      players: updatedPlayers,
      isGameStarted: updatedPlayers.length >= 2,
      gameState:
          updatedPlayers.length >= 2
              ? OnlineGameState.dealing
              : OnlineGameState.waiting,
      startedAt: updatedPlayers.length >= 2 ? DateTime.now() : null,
    );

    // JSON으로 변환하여 업데이트
    final gameData = updatedGame.toJson();
    gameData.remove('gameId'); // gameId는 문서 ID로 사용하므로 제거

    await _firestore
        .collection('online_sutda_games')
        .doc(game.gameId)
        .update(gameData);

    _listenToGame(game.gameId);
    myPlayerIndex.value = updatedPlayers.length - 1;

    if (updatedPlayers.length >= 2) {
      AppSnackbar.success('게임이 시작됩니다!');
      // 게임 시작 - 첫 번째 카드 배분
      await _dealFirstCards(game.gameId);
    }
  }

  // 게임 상태 리스닝
  void _listenToGame(String gameId) {
    developer.log('게임 상태 리스닝 시작: $gameId');
    _gameSubscription = _firestore
        .collection('online_sutda_games')
        .doc(gameId)
        .snapshots()
        .listen(
          (snapshot) {
            try {
              if (snapshot.exists && snapshot.data() != null) {
                final gameData = snapshot.data()!;
                gameData['gameId'] = snapshot.id; // gameId 추가

                final game = OnlineSutdaGame.fromJson(gameData);

                developer.log('게임 상태 업데이트: ${game.gameState.name}');
                currentGame.value = game;
                _updateUIState(game);
                isSearchingGame.value = false;
              } else {
                developer.log('게임 문서가 존재하지 않습니다: $gameId');
              }
            } catch (e) {
              developer.log('게임 상태 업데이트 오류: $e');
              AppSnackbar.error('게임 상태 업데이트 중 오류가 발생했습니다: $e');
            }
          },
          onError: (error) {
            developer.log('게임 리스닝 오류: $error');
            AppSnackbar.error('게임 연결 중 오류가 발생했습니다: $error');
          },
        );
  }

  // UI 상태 업데이트
  void _updateUIState(OnlineSutdaGame game) {
    // 내 턴인지 확인
    final wasMyTurn = isMyTurn.value;
    isMyTurn.value =
        game.currentPlayerIndex < game.players.length &&
        game.players[game.currentPlayerIndex].playerId ==
            _profileController.uid;

    // 턴이 바뀌었을 때 타이머 처리
    if (wasMyTurn != isMyTurn.value) {
      if (isMyTurn.value &&
          (game.gameState == OnlineGameState.firstBetting ||
              game.gameState == OnlineGameState.secondBetting)) {
        _startBettingTimer();
      } else {
        _stopBettingTimer();
      }
    }

    // 게임 상태별 자동 처리
    if (game.gameState == OnlineGameState.dealing &&
        game.players.length >= 2 &&
        game.players.every((p) => p.cards.isEmpty)) {
      // dealing 상태이고 플레이어가 2명 이상이며 아직 카드가 배분되지 않았다면
      developer.log('카드 배분 자동 시작');
      Future.delayed(const Duration(milliseconds: 500), () {
        _dealFirstCards(game.gameId);
      });
    }

    // secondBetting 상태에서 베팅이 완료되었는지 확인
    if (game.gameState == OnlineGameState.secondBetting) {
      final activePlayers = game.players.where((p) => !p.hasFolded).toList();

      // 모든 활성 플레이어가 같은 금액을 베팅했는지 확인
      if (activePlayers.length > 1) {
        final firstPlayerBet = activePlayers.first.totalBet;
        final allBetsEqual = activePlayers.every(
          (player) => player.totalBet == firstPlayerBet,
        );

        if (allBetsEqual &&
            activePlayers.every((player) => player.totalBet > 0)) {
          // 모든 플레이어가 베팅을 완료했다면 showdown으로 진행
          developer.log('2라운드 베팅 완료, showdown 시작');
          _stopBettingTimer();
          Future.delayed(const Duration(milliseconds: 500), () {
            _showdown();
          });
        }
      } else if (activePlayers.length == 1) {
        // 한 명만 남았다면 바로 게임 종료
        developer.log('한 명만 남음, 게임 종료');
        _stopBettingTimer();
        Future.delayed(const Duration(milliseconds: 500), () {
          _showdown();
        });
      }
    }

    // 게임 종료 시 상대방 카드 공개
    if (game.gameState == OnlineGameState.showdown ||
        game.gameState == OnlineGameState.finished) {
      showOpponentCards.value = true;
      _checkGameResult(game);
      _stopBettingTimer();
    }
  }

  // 첫 번째 카드 배분
  Future<void> _dealFirstCards(String gameId) async {
    final deck = _createDeck();
    deck.shuffle();

    final game = currentGame.value!;
    final updatedPlayers =
        game.players.map((player) {
          final card = deck.removeAt(0);
          return player.copyWith(
            cards: [card],
            totalBet: game.baseBet, // 기본 베팅
          );
        }).toList();

    // 먼저 dealing 상태로 변경
    var updatedGame = game.copyWith(
      players: updatedPlayers,
      gameState: OnlineGameState.dealing,
      pot: game.baseBet * game.players.length,
      bettingHistory: [
        ...game.bettingHistory,
        '--- 1라운드 시작 ---',
        '첫 번째 카드가 배분되었습니다.',
        '각 플레이어가 기본 베팅 ${game.baseBet}P를 지불했습니다.',
        '팟: ${game.baseBet * game.players.length}P',
      ],
    );

    // JSON으로 변환하여 업데이트
    var gameData = updatedGame.toJson();
    gameData.remove('gameId');

    await _firestore
        .collection('online_sutda_games')
        .doc(gameId)
        .update(gameData);

    // 잠시 대기 후 firstBetting 상태로 변경
    await Future.delayed(const Duration(seconds: 1));

    updatedGame = updatedGame.copyWith(
      gameState: OnlineGameState.firstBetting,
      bettingHistory: [...updatedGame.bettingHistory, '1라운드 베팅을 시작합니다.'],
    );

    gameData = updatedGame.toJson();
    gameData.remove('gameId');

    await _firestore
        .collection('online_sutda_games')
        .doc(gameId)
        .update(gameData);
  }

  // 두 번째 카드 배분
  Future<void> _dealSecondCards() async {
    final game = currentGame.value!;
    final deck = _createDeck();

    // 이미 사용된 카드 제거
    for (final player in game.players) {
      for (final card in player.cards) {
        deck.removeWhere(
          (deckCard) =>
              deckCard.month == card.month && deckCard.type == card.type,
        );
      }
    }

    deck.shuffle();

    final updatedPlayers =
        game.players.map((player) {
          if (player.hasFolded) return player;

          final secondCard = deck.removeAt(0);
          return player.copyWith(cards: [...player.cards, secondCard]);
        }).toList();

    final updatedGame = game.copyWith(
      players: updatedPlayers,
      gameState: OnlineGameState.secondBetting,
      round: 2,
      currentBet: 0,
      bettingHistory: [
        ...game.bettingHistory,
        '--- 2라운드 시작 ---',
        '두 번째 카드가 배분되었습니다.',
        '2라운드 베팅을 시작합니다.',
        '현재 팟: ${game.pot}P',
      ],
    );

    // JSON으로 변환하여 업데이트
    final gameData = updatedGame.toJson();
    gameData.remove('gameId');

    await _firestore
        .collection('online_sutda_games')
        .doc(game.gameId)
        .update(gameData);
  }

  // 베팅 액션
  Future<void> makeBettingAction(
    BettingAction action, {
    int? customAmount,
  }) async {
    if (!isMyTurn.value) return;

    // 베팅 액션 시 타이머 중지
    _stopBettingTimer();

    final game = currentGame.value!;
    final myPlayer = game.players[myPlayerIndex.value];
    int betAmount = 0;
    String actionText = '';

    switch (action) {
      case BettingAction.check:
        actionText = '체크';
        break;
      case BettingAction.ping:
        betAmount = game.baseBet;
        actionText = '삥 (${betAmount}P)';
        break;
      case BettingAction.call:
        betAmount = game.currentBet;
        actionText = '콜 (${betAmount}P)';
        break;
      case BettingAction.half:
        betAmount = (game.pot / 2).floor();
        actionText = '하프 (${betAmount}P)';
        break;
      case BettingAction.quarter:
        betAmount = (game.pot / 4).floor();
        actionText = '쿼터 (${betAmount}P)';
        break;
      case BettingAction.ddadang:
        betAmount = game.currentBet;
        actionText = '따당 (${betAmount}P)';
        break;
      case BettingAction.die:
        actionText = '다이';
        break;
      case BettingAction.raise:
        betAmount = customAmount ?? game.baseBet;
        actionText = '레이즈 (${betAmount}P)';
        break;
    }

    await _processBettingAction(action, betAmount, actionText);
  }

  // 베팅 액션 처리
  Future<void> _processBettingAction(
    BettingAction action,
    int betAmount,
    String actionText,
  ) async {
    final game = currentGame.value!;
    final updatedPlayers = List<OnlineSutdaPlayer>.from(game.players);
    final myPlayer = updatedPlayers[myPlayerIndex.value];

    if (action == BettingAction.die) {
      // 다이 처리
      updatedPlayers[myPlayerIndex.value] = myPlayer.copyWith(hasFolded: true);
    } else {
      // 베팅 처리
      updatedPlayers[myPlayerIndex.value] = myPlayer.copyWith(
        totalBet: myPlayer.totalBet + betAmount,
      );
    }

    // 다음 플레이어 결정
    int nextPlayerIndex = _getNextPlayerIndex(
      game.currentPlayerIndex,
      updatedPlayers,
    );

    // 베팅 라운드 완료 체크
    bool isBettingComplete = _isBettingRoundComplete(
      updatedPlayers,
      game.currentBet + betAmount,
    );

    OnlineGameState nextState = game.gameState;
    if (isBettingComplete) {
      if (game.gameState == OnlineGameState.firstBetting) {
        nextState = OnlineGameState.secondDealing;
      } else if (game.gameState == OnlineGameState.secondBetting) {
        nextState = OnlineGameState.showdown;
      }
    }

    final updatedGame = game.copyWith(
      players: updatedPlayers,
      currentPlayerIndex: nextPlayerIndex,
      currentBet:
          action == BettingAction.die
              ? game.currentBet
              : game.currentBet + betAmount,
      pot: game.pot + betAmount,
      gameState: nextState,
      bettingHistory: [
        ...game.bettingHistory,
        _formatBettingHistory(
          myPlayer,
          action,
          betAmount,
          actionText,
          game.pot + betAmount,
        ),
      ],
    );

    // JSON으로 변환하여 업데이트
    final gameData = updatedGame.toJson();
    gameData.remove('gameId');

    await _firestore
        .collection('online_sutda_games')
        .doc(game.gameId)
        .update(gameData);

    // 상태에 따른 추가 처리
    if (nextState == OnlineGameState.secondDealing) {
      await Future.delayed(const Duration(seconds: 1));
      await _dealSecondCards();
    } else if (nextState == OnlineGameState.showdown) {
      await Future.delayed(const Duration(seconds: 1));
      await _showdown();
    }
  }

  // 승부 결정
  Future<void> _showdown() async {
    final game = currentGame.value!;
    final activePlayers = game.players.where((p) => !p.hasFolded).toList();

    String winner = '';
    String resultMessage = '';
    List<String> resultDetails = [];

    if (activePlayers.length == 1) {
      // 한 명만 남은 경우
      winner = activePlayers.first.playerId;
      resultMessage = '${activePlayers.first.playerName}이(가) 승리했습니다!';
      resultDetails.add('다른 플레이어가 모두 포기했습니다.');
    } else {
      // 족보 비교
      OnlineSutdaPlayer? winnerPlayer;
      TwoCardSutdaHand? bestHand;

      // 모든 플레이어의 족보 표시
      for (final player in activePlayers) {
        final hand = TwoCardSutdaHand.calculateHand(player.cards);
        resultDetails.add('${player.playerName}: ${hand.name}');

        if (bestHand == null || hand.rank < bestHand.rank) {
          bestHand = hand;
          winnerPlayer = player;
        }
      }

      if (winnerPlayer != null && bestHand != null) {
        winner = winnerPlayer.playerId;
        resultMessage =
            '${winnerPlayer.playerName}이(가) ${bestHand.name}로 승리했습니다!';
      }
    }

    final updatedGame = game.copyWith(
      gameState: OnlineGameState.finished,
      bettingHistory: [
        ...game.bettingHistory,
        '--- 게임 종료 ---',
        '카드 공개:',
        ...resultDetails,
        resultMessage,
        '최종 팟: ${game.pot}P',
      ],
    );

    // JSON으로 변환하여 업데이트
    final gameData = updatedGame.toJson();
    gameData.remove('gameId');

    await _firestore
        .collection('online_sutda_games')
        .doc(game.gameId)
        .update(gameData);

    developer.log('게임 종료: $resultMessage');
  }

  // 승자 선언
  Future<void> _declareWinner(OnlineSutdaPlayer winner, String reason) async {
    final game = currentGame.value!;

    final updatedGame = game.copyWith(
      gameState: OnlineGameState.finished,
      bettingHistory: [
        ...game.bettingHistory,
        '--- 게임 종료 ---',
        '${winner.playerName}이(가) 승리했습니다!',
        reason,
        '획득 포인트: ${game.pot}P',
      ],
    );

    // JSON으로 변환하여 업데이트
    final gameData = updatedGame.toJson();
    gameData.remove('gameId');

    await _firestore
        .collection('online_sutda_games')
        .doc(game.gameId)
        .update(gameData);

    // 승자에게 포인트 지급 (Firebase Functions에서 처리)
    // TODO: 포인트 지급 함수 호출
  }

  // 다음 플레이어 인덱스 계산
  int _getNextPlayerIndex(int currentIndex, List<OnlineSutdaPlayer> players) {
    int nextIndex = (currentIndex + 1) % players.length;

    // 포기한 플레이어는 건너뛰기
    while (nextIndex != currentIndex && players[nextIndex].hasFolded) {
      nextIndex = (nextIndex + 1) % players.length;
    }

    return nextIndex;
  }

  // 베팅 라운드 완료 체크
  bool _isBettingRoundComplete(
    List<OnlineSutdaPlayer> players,
    int currentBet,
  ) {
    final activePlayers = players.where((p) => !p.hasFolded).toList();

    if (activePlayers.length <= 1) return true;

    // 모든 활성 플레이어가 같은 금액을 베팅했는지 확인
    final firstPlayerBet = activePlayers.first.totalBet;
    return activePlayers.every((player) => player.totalBet == firstPlayerBet);
  }

  // 게임 결과 확인
  void _checkGameResult(OnlineSutdaGame game) {
    final myPlayer = game.players[myPlayerIndex.value];
    final activePlayers = game.players.where((p) => !p.hasFolded).toList();

    if (activePlayers.length == 1) {
      isWinner.value = activePlayers.first.playerId == myPlayer.playerId;
      gameResult.value = isWinner.value ? '승리!' : '패배';
    } else {
      // 족보 비교 결과 확인
      TwoCardSutdaHand? myHand;
      TwoCardSutdaHand? bestHand;

      for (final player in activePlayers) {
        final hand = TwoCardSutdaHand.calculateHand(player.cards);
        if (player.playerId == myPlayer.playerId) {
          myHand = hand;
        }
        if (bestHand == null || hand.rank < bestHand.rank) {
          bestHand = hand;
        }
      }

      if (myHand != null && bestHand != null) {
        isWinner.value = myHand.rank == bestHand.rank;
        gameResult.value = isWinner.value ? '승리!' : '패배';
      }
    }
  }

  // 덱 생성
  List<SutdaCard> _createDeck() {
    final deck = <SutdaCard>[];

    // 화투 카드 생성 (1월~12월, 각 월마다 광/피 카드들)
    for (int month = 1; month <= 12; month++) {
      // 광 카드가 있는 월
      if ([1, 3, 8, 11, 12].contains(month)) {
        deck.add(SutdaCard(month: month, type: 'gwang', value: month));
      }

      // 피 카드 (모든 월에 최소 1장)
      deck.add(SutdaCard(month: month, type: 'pi1', value: month));

      // 추가 피 카드가 있는 월
      if ([1, 2, 3, 4, 5, 6, 7, 9, 10, 12].contains(month)) {
        deck.add(SutdaCard(month: month, type: 'pi2', value: month));
      }

      // 띠 카드가 있는 월
      if ([1, 2, 3, 4, 5, 6, 7, 9, 10, 11].contains(month)) {
        deck.add(SutdaCard(month: month, type: 'tti', value: month));
      }

      // 열 카드가 있는 월
      if ([2, 4, 5, 6, 7, 8, 9, 10, 11].contains(month)) {
        deck.add(SutdaCard(month: month, type: 'yeol', value: month));
      }
    }

    return deck;
  }

  // 게임 나가기
  Future<void> leaveGame() async {
    _gameSubscription?.cancel();
    _searchTimer?.cancel();
    _stopBettingTimer(); // 타이머 정리

    if (currentGame.value != null) {
      // 게임 중이면 자동으로 다이 처리
      if (currentGame.value!.gameState == OnlineGameState.firstBetting ||
          currentGame.value!.gameState == OnlineGameState.secondBetting) {
        await makeBettingAction(BettingAction.die);
      }
    }

    currentGame.value = null;
    isSearchingGame.value = false;
    myPlayerIndex.value = -1;
  }

  // 베팅 타이머 시작
  void _startBettingTimer() {
    _stopBettingTimer(); // 기존 타이머 정리
    bettingTimeLeft.value = 30;
    isBettingTimerActive.value = true;

    developer.log('베팅 타이머 시작: 30초');

    _bettingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (bettingTimeLeft.value > 0) {
        bettingTimeLeft.value--;
      } else {
        // 시간 초과 - 자동으로 다이
        developer.log('베팅 시간 초과, 자동 다이');
        _stopBettingTimer();

        // 시간 초과 메시지를 히스토리에 추가
        final game = currentGame.value!;
        final myPlayer = game.players[myPlayerIndex.value];

        _processBettingAction(BettingAction.die, 0, '다이 (시간 초과)');
      }
    });
  }

  // 베팅 타이머 중지
  void _stopBettingTimer() {
    _bettingTimer?.cancel();
    _bettingTimer = null;
    isBettingTimerActive.value = false;
    bettingTimeLeft.value = 30;
  }

  String _formatBettingHistory(
    OnlineSutdaPlayer player,
    BettingAction action,
    int betAmount,
    String actionText,
    int pot,
  ) {
    if (action == BettingAction.die) {
      return '${player.playerName}: $actionText';
    } else if (action == BettingAction.check) {
      return '${player.playerName}: $actionText (팟: ${pot}P)';
    } else {
      return '${player.playerName}: $actionText (총 베팅: ${player.totalBet + betAmount}P, 팟: ${pot}P)';
    }
  }
}
