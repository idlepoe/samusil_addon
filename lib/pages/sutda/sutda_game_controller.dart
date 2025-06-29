import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../../models/sutda_card.dart';
import '../../controllers/profile_controller.dart';
import '../../components/appSnackbar.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../../utils/app.dart';
import '../../utils/http_service.dart';
import 'package:cloud_functions/cloud_functions.dart';

enum GameState {
  ready,
  dealing,
  selectingOpenCard, // 2장 중 1장 공개 선택
  firstBetting, // 첫 번째 베팅
  dealingThirdCard, // 세 번째 카드 배분
  finalBetting, // 최종 베팅
  showdown,
  finished,
}

enum BettingTurn { player, ai }

class SutdaGameController extends GetxController {
  // 게임 상태
  final gameState = GameState.ready.obs;
  final bettingTurn = BettingTurn.player.obs;
  final bettingRoundComplete = false.obs;
  final isDie = false.obs; // 다이 여부 추적

  // 카드 관련
  final playerCards = <SutdaCard>[].obs;
  final aiCards = <SutdaCard>[].obs;
  final playerOpenCardIndex = RxInt(-1);
  final aiOpenCardIndex = RxInt(-1);
  final showPlayerCards = true.obs;
  final showAiCards = false.obs;
  final playerHand = Rxn<SutdaHand>();
  final aiHand = Rxn<SutdaHand>();

  // 카드 선택 관련
  final selectedCardIndices = <int>[].obs;
  final isCardSelectionComplete = false.obs;
  final temporaryHand = Rxn<SutdaHand>();

  // 베팅 관련
  final currentBet = RxInt(0);
  final playerTotalBet = RxInt(0);
  final aiTotalBet = RxInt(0);
  final pot = RxInt(0);
  final baseBet = RxInt(50);
  final isPlayerFirst = false.obs;
  final gamePhase = RxInt(1);

  // 게임 결과
  final gameResult = ''.obs;
  final isPlayerWin = false.obs;
  final finalPointChange = 0.obs; // 최종 포인트 변화량

  // 베팅 히스토리
  final bettingHistory = <String>[].obs;

  // 덱
  List<SutdaCard> deck = [];

  final ProfileController profileController = ProfileController.to;

  // HTTP 서비스 (fishing_game_controller와 동일한 방식)
  final HttpService _httpService = HttpService();

  Timer? dealingTimer;
  Timer? aiTimer;

  Random random = Random();

  // 베팅 라운드 추적 변수 추가
  final playerHasBet = false.obs;
  final aiHasBet = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDeck();
  }

  @override
  void onClose() {
    dealingTimer?.cancel();
    aiTimer?.cancel();
    super.onClose();
  }

  void _initializeDeck() {
    deck = SutdaGame.createDeck();
    print('덱 구성 완료: ${deck.length}장');
  }

  void startGame() {
    // 게임 시작 전 포인트 확인
    if (ProfileController.to.point < baseBet.value) {
      AppSnackbar.error('게임 참여를 위해서는 최소 ${baseBet.value}P가 필요합니다.');
      return;
    }

    // 낙관적 업데이트: 즉시 포인트 차감 (로컬)
    _deductPointsOptimistically();

    // 백그라운드에서 서버에 참가비 차감 요청
    _payGameFeeToServer();

    _startNewGame();
  }

  /// 낙관적 업데이트로 포인트 차감 (로컬)
  void _deductPointsOptimistically() {
    final currentProfile = ProfileController.to.profile.value;
    final updatedProfile = currentProfile.copyWith(
      point: currentProfile.point - baseBet.value,
    );
    ProfileController.to.profile.value = updatedProfile;

    developer.log('낙관적 업데이트: 참가비 ${baseBet.value}P 차감');
  }

  /// 서버에 참가비 차감 요청
  Future<void> _payGameFeeToServer() async {
    try {
      final response = await _httpService.updatePoints(
        pointsChange: -baseBet.value.toDouble(),
        actionType: 'sutda_game',
        description: '섯다 참가',
        metadata: {'gameType': 'sutda', 'baseBet': baseBet.value},
      );

      if (response.success) {
        developer.log('서버 참가비 차감 성공');
      } else {
        developer.log('서버 참가비 차감 실패: ${response.error}');
        // 실패 시에도 게임은 계속 진행 (낙관적 업데이트)
      }
    } catch (e) {
      developer.log('참가비 차감 요청 중 오류: $e');
      // 에러 발생 시에도 게임은 계속 진행
    }
  }

  /// 승리 시 포인트 지급
  Future<void> _payWinReward() async {
    try {
      final response = await _httpService.updatePoints(
        pointsChange: pot.value.toDouble(),
        actionType: 'sutda_game',
        description: '섯다 승리',
        metadata: {
          'gameType': 'sutda',
          'potAmount': pot.value,
          'playerTotalBet': playerTotalBet.value,
          'aiTotalBet': aiTotalBet.value,
        },
      );

      if (response.success) {
        developer.log('승리 보상 지급 성공: ${pot.value}P');
        // 로컬 포인트 업데이트
        final currentProfile = ProfileController.to.profile.value;
        final updatedProfile = currentProfile.copyWith(
          point: currentProfile.point + pot.value,
        );
        ProfileController.to.profile.value = updatedProfile;
      } else {
        developer.log('승리 보상 지급 실패: ${response.error}');
      }
    } catch (e) {
      developer.log('승리 보상 지급 중 오류: $e');
    }
  }

  /// 베팅 시 포인트 차감
  Future<void> _payBetAmount(int amount, String description) async {
    try {
      // 낙관적 업데이트
      final currentProfile = ProfileController.to.profile.value;
      final updatedProfile = currentProfile.copyWith(
        point: currentProfile.point - amount,
      );
      ProfileController.to.profile.value = updatedProfile;

      // 서버 업데이트
      final response = await _httpService.updatePoints(
        pointsChange: -amount.toDouble(),
        actionType: 'sutda_game',
        description: description,
        metadata: {
          'gameType': 'sutda',
          'betAmount': amount,
          'currentPot': pot.value,
        },
      );

      if (!response.success) {
        developer.log('베팅 포인트 차감 실패: ${response.error}');
      }
    } catch (e) {
      developer.log('베팅 포인트 차감 중 오류: $e');
    }
  }

  void _startNewGame() {
    print('새 게임 시작');

    // 게임 상태 초기화
    gameState.value = GameState.dealing;
    bettingRoundComplete.value = false;
    isDie.value = false; // 다이 상태 초기화

    // 카드 초기화
    playerCards.clear();
    aiCards.clear();
    playerOpenCardIndex.value = -1;
    aiOpenCardIndex.value = -1;
    selectedCardIndices.clear();
    temporaryHand.value = null;
    showPlayerCards.value = true;
    showAiCards.value = false; // AI 카드 숨기기

    // 족보 초기화
    playerHand.value = null;
    aiHand.value = null;

    // 베팅 초기화 (기본 베팅 50점)
    pot.value = baseBet.value * 2;
    currentBet.value = 0; // 초기에는 베팅 없음
    playerTotalBet.value = baseBet.value;
    aiTotalBet.value = baseBet.value;
    finalPointChange.value = 0;
    playerHasBet.value = false; // 베팅 추적 초기화
    aiHasBet.value = false;

    // 히스토리 초기화
    bettingHistory.clear();
    bettingHistory.add('게임 시작 - 각자 ${baseBet.value}P 참가');

    // 덱 재초기화 및 섞기
    _initializeDeck();
    deck.shuffle(random);

    // 첫 번째 턴을 랜덤으로 결정
    isPlayerFirst.value = DateTime.now().millisecondsSinceEpoch % 2 == 0;
    bettingTurn.value =
        isPlayerFirst.value ? BettingTurn.player : BettingTurn.ai;
    print('첫 번째 턴: ${bettingTurn.value == BettingTurn.player ? "플레이어" : "AI"}');

    // 카드 배분 시작 (각자 2장씩)
    _startDealing();
  }

  void _startDealing() {
    print('카드 배분 시작 - 각자 2장씩');

    // 덱에 충분한 카드가 있는지 확인
    if (deck.length < 6) {
      // 최소 6장 필요 (플레이어 3장 + AI 3장)
      developer.log('덱에 카드가 부족합니다. 덱을 재초기화합니다.');
      _initializeDeck();
      deck.shuffle(random);
    }

    // 각자 2장씩 배분
    for (int i = 0; i < 2; i++) {
      if (deck.length < 2) {
        developer.log('카드 배분 중 덱이 부족합니다.');
        AppSnackbar.error('카드 배분 오류가 발생했습니다.');
        gameState.value = GameState.ready;
        return;
      }

      final playerCard = deck.removeAt(0);
      final aiCard = deck.removeAt(0);

      playerCards.add(playerCard);
      aiCards.add(aiCard);

      developer.log(
        '플레이어 카드 ${i + 1}: ${playerCard.month}월 ${playerCard.type}',
      );
      developer.log('AI 카드 ${i + 1}: ${aiCard.month}월 ${aiCard.type}');
    }

    // 실시간 족보 계산 시작
    _calculateRealTimeHand();

    Future.delayed(const Duration(milliseconds: 1500), () {
      showPlayerCards.value = true;
      gameState.value = GameState.selectingOpenCard;

      // AI는 자동으로 카드 선택
      _aiSelectOpenCard();
    });
  }

  void _calculateRealTimeHand() {
    // 플레이어 실시간 족보 계산
    if (playerCards.length >= 2) {
      playerHand.value = SutdaGame.calculateThreeCardHand(playerCards);
    }

    // AI 족보 계산 (공개된 경우에만)
    if (showAiCards.value && aiCards.length >= 2) {
      aiHand.value = SutdaGame.calculateThreeCardHand(aiCards);
    }
  }

  // 플레이어가 공개할 카드 선택
  void selectOpenCard(int index) {
    if (gameState.value != GameState.selectingOpenCard) return;
    if (index < 0 || index >= playerCards.length) return;

    playerOpenCardIndex.value = index;
    developer.log('플레이어가 ${index}번째 카드 공개 선택');

    // 첫 번째 베팅 라운드 시작 (AI가 이미 선택 완료된 상태에서)
    _startFirstBetting();
  }

  void _aiSelectOpenCard() {
    // AI는 랜덤하게 카드 선택 (실제로는 더 복잡한 로직 가능)
    aiOpenCardIndex.value = random.nextInt(2);
    developer.log('AI가 ${aiOpenCardIndex.value}번째 카드 공개');
  }

  void _startFirstBetting() {
    gameState.value = GameState.firstBetting;
    gamePhase.value = 1;
    playerHasBet.value = false;
    aiHasBet.value = false;
    bettingHistory.add('--- 1라운드 베팅 ---');

    if (bettingTurn.value == BettingTurn.ai) {
      _performAiAction();
    }
  }

  void check() {
    if (gameState.value != GameState.firstBetting &&
        gameState.value != GameState.finalBetting)
      return;

    developer.log('플레이어 체크');
    _addBettingHistory('체크');
    currentBet.value = 0;
    _processBetting();
  }

  void call() {
    if (gameState.value != GameState.firstBetting &&
        gameState.value != GameState.finalBetting)
      return;

    int callAmount = currentBet.value;
    if (callAmount > 0) {
      developer.log('플레이어 콜 (${callAmount}P)');
      _addBettingHistory('콜 (${callAmount}P)');
      _payBetAmount(callAmount, '섯다 콜');

      if (bettingTurn.value == BettingTurn.player) {
        playerTotalBet.value += callAmount;
      } else {
        aiTotalBet.value += callAmount;
      }
      pot.value += callAmount;
    } else {
      developer.log('플레이어 체크');
      _addBettingHistory('체크');
    }

    _processBetting();
  }

  void raise() {
    if (gameState.value != GameState.firstBetting &&
        gameState.value != GameState.finalBetting)
      return;

    int raiseAmount = currentBet.value + baseBet.value;
    developer.log('플레이어 따당 (+${baseBet.value}P)');
    _addBettingHistory('따당 (+${baseBet.value}P)');
    _payBetAmount(raiseAmount, '섯다 레이즈');

    if (bettingTurn.value == BettingTurn.player) {
      playerTotalBet.value += raiseAmount;
    } else {
      aiTotalBet.value += raiseAmount;
    }
    pot.value += raiseAmount;
    currentBet.value = raiseAmount;

    _processBetting();
  }

  void die() {
    if (gameState.value != GameState.firstBetting &&
        gameState.value != GameState.finalBetting)
      return;

    developer.log('플레이어 다이');
    _addBettingHistory('다이');
    isDie.value = true;
    isPlayerWin.value = bettingTurn.value == BettingTurn.ai;
    gameState.value = GameState.showdown;
    showAiCards.value = true;
    _handleGameResult();
  }

  void _processBetting() {
    // 현재 턴의 플레이어가 베팅했음을 표시
    if (bettingTurn.value == BettingTurn.player) {
      playerHasBet.value = true;
    } else {
      aiHasBet.value = true;
    }

    // 베팅 라운드가 완료되었는지 확인
    if (_isBettingRoundComplete()) {
      _nextGamePhase();
      return;
    }

    // 베팅 턴 변경
    bettingTurn.value =
        bettingTurn.value == BettingTurn.player
            ? BettingTurn.ai
            : BettingTurn.player;

    // AI 턴이면 AI 액션 수행
    if (bettingTurn.value == BettingTurn.ai) {
      _performAiAction();
    }
  }

  bool _isBettingRoundComplete() {
    // 양쪽 모두 베팅했고, 베팅 금액이 같으면 라운드 완료
    if (!playerHasBet.value || !aiHasBet.value) {
      return false; // 둘 중 하나라도 베팅하지 않았으면 라운드 미완료
    }

    // 양쪽 모두 베팅했고, 베팅 금액이 같으면 라운드 완료
    return playerTotalBet.value == aiTotalBet.value;
  }

  void _nextGamePhase() {
    if (gameState.value == GameState.firstBetting) {
      // 첫 번째 베팅 완료 -> 세 번째 카드 배분
      _dealThirdCard();
    } else if (gameState.value == GameState.finalBetting) {
      // 최종 베팅 완료 -> 승부 결정
      _showdown();
    }
  }

  void _dealThirdCard() {
    gameState.value = GameState.dealingThirdCard;
    developer.log('세 번째 카드 배분');
    bettingHistory.add('--- 세 번째 카드 배분 ---');

    // 덱에 충분한 카드가 있는지 확인
    if (deck.length < 2) {
      developer.log('세 번째 카드 배분 시 덱이 부족합니다.');
      AppSnackbar.error('카드 배분 오류가 발생했습니다.');
      gameState.value = GameState.ready;
      return;
    }

    // 3번째 카드 배분
    final playerThirdCard = deck.removeAt(0);
    final aiThirdCard = deck.removeAt(0);

    playerCards.add(playerThirdCard);
    aiCards.add(aiThirdCard);

    developer.log(
      '플레이어 3번째 카드: ${playerThirdCard.month}월 ${playerThirdCard.type}',
    );
    developer.log('AI 3번째 카드: ${aiThirdCard.month}월 ${aiThirdCard.type}');

    // 실시간 족보 재계산
    _calculateRealTimeHand();

    Future.delayed(const Duration(milliseconds: 1000), () {
      // 최종 베팅 라운드 시작
      gameState.value = GameState.finalBetting;
      gamePhase.value = 2;
      currentBet.value = 0; // 베팅 초기화
      playerHasBet.value = false; // 2라운드 베팅 추적 초기화
      aiHasBet.value = false;
      bettingHistory.add('--- 2라운드 베팅 ---');

      if (bettingTurn.value == BettingTurn.ai) {
        _performAiAction();
      }
    });
  }

  void _showdown() {
    gameState.value = GameState.showdown;
    showAiCards.value = true;

    // 최종 족보 계산
    _calculateRealTimeHand();

    developer.log('승부 결정');
    developer.log(
      '플레이어 족보: ${playerHand.value?.name ?? "없음"} (${playerHand.value?.rank ?? 0})',
    );
    developer.log(
      'AI 족보: ${aiHand.value?.name ?? "없음"} (${aiHand.value?.rank ?? 0})',
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (playerHand.value == null || aiHand.value == null) {
        isPlayerWin.value = false;
        _handleGameResult();
        return;
      }

      bool playerWins = playerHand.value!.rank < aiHand.value!.rank;
      isPlayerWin.value = playerWins;
      _handleGameResult();
    });
  }

  void _handleGameResult() {
    String resultText = isPlayerWin.value ? "승리!" : "패배...";
    bettingHistory.add('--- 게임 종료: $resultText ---');

    // AI 카드를 보이도록 설정 (패배 시에도 족보 확인 가능)
    showAiCards.value = true;

    // 최종 족보 계산 (다이얼로그에서 표시하기 위해)
    _calculateRealTimeHand();

    if (isPlayerWin.value) {
      // 승리: 팟 머니 획득
      _payWinReward();
    }

    // 결과 다이얼로그 표시
    _showGameResultDialog();
  }

  void _showGameResultDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 결과 아이콘
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color:
                      isPlayerWin.value
                          ? const Color(0xFF00C851).withOpacity(0.1)
                          : const Color(0xFFFF3B30).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  isPlayerWin.value
                      ? Icons.emoji_events
                      : Icons.sentiment_dissatisfied,
                  size: 40,
                  color:
                      isPlayerWin.value
                          ? const Color(0xFF00C851)
                          : const Color(0xFFFF3B30),
                ),
              ),
              const SizedBox(height: 20),

              // 결과 텍스트
              Text(
                isPlayerWin.value ? '승리!' : '패배',
                style: TextStyle(
                  color:
                      isPlayerWin.value
                          ? const Color(0xFF00C851)
                          : const Color(0xFFFF3B30),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              if (isDie.value) ...[
                const SizedBox(height: 8),
                Text(
                  '${bettingTurn.value == BettingTurn.player ? "플레이어" : "AI"}가 다이했습니다',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8B95A1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // 카드 비교
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E8EB)),
                ),
                child: Column(
                  children: [
                    // 플레이어 카드
                    _buildResultCardRow(
                      '플레이어',
                      playerCards,
                      playerHand.value,
                      const Color(0xFF0064FF),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'VS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B95A1),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // AI 카드
                    _buildResultCardRow(
                      'AI',
                      aiCards,
                      aiHand.value,
                      const Color(0xFFFF6B6B),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 포인트 변화
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      isPlayerWin.value
                          ? const Color(0xFF00C851).withOpacity(0.1)
                          : const Color(0xFFFF3B30).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isPlayerWin.value
                            ? const Color(0xFF00C851)
                            : const Color(0xFFFF3B30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isPlayerWin.value
                          ? Icons.trending_up
                          : Icons.trending_down,
                      color:
                          isPlayerWin.value
                              ? const Color(0xFF00C851)
                              : const Color(0xFFFF3B30),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isPlayerWin.value
                          ? '+${pot.value}P'
                          : '-${playerTotalBet.value}P (총 손실)',
                      style: TextStyle(
                        color:
                            isPlayerWin.value
                                ? const Color(0xFF00C851)
                                : const Color(0xFFFF3B30),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 버튼
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // 다이얼로그 닫기
                        Get.back(); // 게임 화면 닫기 (홈으로)
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B95A1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '홈으로',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // 다이얼로그 닫기
                        startGame(); // 새 게임 시작
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0064FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '다시 하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildResultCardRow(
    String playerName,
    List<SutdaCard> cards,
    SutdaHand? hand,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          playerName,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              cards
                  .map(
                    (card) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 30,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFE5E8EB)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Image.asset(
                          SutdaGame.getCardImagePath(card),
                          width: 30,
                          height: 45,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${card.month}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      card.type == 'gwang' ? '광' : '피',
                                      style: const TextStyle(fontSize: 8),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 8),
        if (hand != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${hand.rank}위 ${hand.name}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  void _performAiAction() {
    // AI 액션 로직 구현
    aiTimer = Timer(const Duration(seconds: 2), () {
      if (gameState.value == GameState.firstBetting ||
          gameState.value == GameState.finalBetting) {
        _aiMakeBettingDecision();
      }
    });
  }

  void _aiMakeBettingDecision() {
    // AI 베팅 로직 (간단한 확률 기반)
    double foldChance = 0.2;
    double raiseChance = 0.3;

    // AI 족보에 따른 확률 조정 (rank가 낮을수록 좋은 족보)
    if (aiHand.value != null && aiHand.value!.rank <= 15) {
      raiseChance = 0.6;
      foldChance = 0.1;
    }

    double randomValue = random.nextDouble();

    if (randomValue < foldChance) {
      // AI 다이
      developer.log('AI 다이');
      die();
    } else if (randomValue < foldChance + raiseChance) {
      // AI 레이즈
      developer.log('AI 레이즈');
      raise();
    } else {
      // AI 콜/체크
      developer.log('AI 콜/체크');
      call();
    }
  }

  void _addBettingHistory(String action) {
    String player = bettingTurn.value == BettingTurn.player ? "플레이어" : "AI";
    String turnInfo = gamePhase.value == 1 ? "[1턴]" : "[2턴]";
    bettingHistory.add('$turnInfo $player: $action');
  }

  // 뷰에서 호출하는 메서드들
  void selectCard(int index) {
    if (gameState.value == GameState.selectingOpenCard) {
      selectOpenCard(index);
    }
  }

  void playerFold() {
    die();
  }

  void playerCall() {
    call();
  }

  void playerRaise() {
    raise();
  }
}
