import 'package:freezed_annotation/freezed_annotation.dart';
import 'sutda_card.dart';

part 'online_sutda_game.freezed.dart';
part 'online_sutda_game.g.dart';

List<Map<String, dynamic>> cardsToJson(List<SutdaCard> cards) {
  return cards.map((card) => card.toJson()).toList();
}

List<Map<String, dynamic>> playersToJson(List<OnlineSutdaPlayer> players) {
  return players.map((player) => player.toJson()).toList();
}

enum OnlineGameState {
  waiting, // 플레이어 대기 중
  dealing, // 첫 번째 카드 배분
  firstBetting, // 첫 번째 베팅 라운드
  secondDealing, // 두 번째 카드 배분
  secondBetting, // 두 번째 베팅 라운드
  showdown, // 패 공개
  finished, // 게임 종료
}

enum BettingAction {
  check, // 체크 (넘기기)
  ping, // 삥 (기본금)
  call, // 콜
  raise, // 레이즈
  half, // 하프
  quarter, // 쿼터
  ddadang, // 따당
  die, // 다이 (포기)
}

@freezed
abstract class OnlineSutdaPlayer with _$OnlineSutdaPlayer {
  const factory OnlineSutdaPlayer({
    required String playerId,
    required String playerName,
    required String? photoUrl,
    @JsonKey(toJson: cardsToJson) required List<SutdaCard> cards,
    required int totalBet,
    required bool hasFolded,
    required bool isConnected,
    @Default(0) int points,
  }) = _OnlineSutdaPlayer;

  factory OnlineSutdaPlayer.fromJson(Map<String, dynamic> json) =>
      _$OnlineSutdaPlayerFromJson(json);
}

@freezed
abstract class OnlineSutdaGame with _$OnlineSutdaGame {
  const factory OnlineSutdaGame({
    required String gameId,
    required OnlineGameState gameState,
    @JsonKey(toJson: playersToJson) required List<OnlineSutdaPlayer> players,
    required int currentPlayerIndex,
    required int pot,
    required int baseBet,
    required int currentBet,
    required int round, // 1 또는 2
    required List<String> bettingHistory,
    required DateTime createdAt,
    required DateTime? startedAt,
    @Default(false) bool isGameStarted,
    @Default(2) int maxPlayers,
  }) = _OnlineSutdaGame;

  factory OnlineSutdaGame.fromJson(Map<String, dynamic> json) =>
      _$OnlineSutdaGameFromJson(json);
}

@freezed
abstract class BettingMove with _$BettingMove {
  const factory BettingMove({
    required String playerId,
    required BettingAction action,
    required int amount,
    required DateTime timestamp,
  }) = _BettingMove;

  factory BettingMove.fromJson(Map<String, dynamic> json) =>
      _$BettingMoveFromJson(json);
}

// 2장 섯다 족보 계산 클래스
class TwoCardSutdaHand {
  final String name;
  final int rank;
  final List<SutdaCard> cards;

  const TwoCardSutdaHand({
    required this.name,
    required this.rank,
    required this.cards,
  });

  static TwoCardSutdaHand calculateHand(List<SutdaCard> cards) {
    if (cards.length != 2) {
      return const TwoCardSutdaHand(name: '무효', rank: 999, cards: []);
    }

    final card1 = cards[0];
    final card2 = cards[1];

    // 특수 족보 체크
    // 38광땡 (3월 광 + 8월 광)
    if ((card1.month == 3 &&
            card1.type == 'gwang' &&
            card2.month == 8 &&
            card2.type == 'gwang') ||
        (card1.month == 8 &&
            card1.type == 'gwang' &&
            card2.month == 3 &&
            card2.type == 'gwang')) {
      return TwoCardSutdaHand(name: '38광땡', rank: 1, cards: cards);
    }

    // 18광땡 (1월 광 + 8월 광)
    if ((card1.month == 1 &&
            card1.type == 'gwang' &&
            card2.month == 8 &&
            card2.type == 'gwang') ||
        (card1.month == 8 &&
            card1.type == 'gwang' &&
            card2.month == 1 &&
            card2.type == 'gwang')) {
      return TwoCardSutdaHand(name: '18광땡', rank: 2, cards: cards);
    }

    // 13광땡 (1월 광 + 3월 광)
    if ((card1.month == 1 &&
            card1.type == 'gwang' &&
            card2.month == 3 &&
            card2.type == 'gwang') ||
        (card1.month == 3 &&
            card1.type == 'gwang' &&
            card2.month == 1 &&
            card2.type == 'gwang')) {
      return TwoCardSutdaHand(name: '13광땡', rank: 3, cards: cards);
    }

    // 땡 (같은 숫자)
    if (card1.month == card2.month) {
      return TwoCardSutdaHand(
        name: '${card1.month}땡',
        rank: 4 + (10 - card1.month), // 10땡이 가장 높음
        cards: cards,
      );
    }

    // 알리 (1+2)
    if ((card1.month == 1 && card2.month == 2) ||
        (card1.month == 2 && card2.month == 1)) {
      return TwoCardSutdaHand(name: '알리', rank: 15, cards: cards);
    }

    // 독사 (1+4)
    if ((card1.month == 1 && card2.month == 4) ||
        (card1.month == 4 && card2.month == 1)) {
      return TwoCardSutdaHand(name: '독사', rank: 16, cards: cards);
    }

    // 구삥 (4+6)
    if ((card1.month == 4 && card2.month == 6) ||
        (card1.month == 6 && card2.month == 4)) {
      return TwoCardSutdaHand(name: '구삥', rank: 17, cards: cards);
    }

    // 일삥 (1+9)
    if ((card1.month == 1 && card2.month == 9) ||
        (card1.month == 9 && card2.month == 1)) {
      return TwoCardSutdaHand(name: '일삥', rank: 18, cards: cards);
    }

    // 갑오 (4+10)
    if ((card1.month == 4 && card2.month == 10) ||
        (card1.month == 10 && card2.month == 4)) {
      return TwoCardSutdaHand(name: '갑오', rank: 19, cards: cards);
    }

    // 끗수 계산
    final sum = (card1.month + card2.month) % 10;
    return TwoCardSutdaHand(
      name: '${sum}끗',
      rank: 20 + (9 - sum), // 9끗이 가장 높음
      cards: cards,
    );
  }
}
