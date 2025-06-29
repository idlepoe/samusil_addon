import 'package:freezed_annotation/freezed_annotation.dart';

part 'sutda_card.freezed.dart';
part 'sutda_card.g.dart';

@freezed
abstract class SutdaCard with _$SutdaCard {
  const factory SutdaCard({
    required int month,
    required String type,
    required int value,
  }) = _SutdaCard;

  factory SutdaCard.fromJson(Map<String, dynamic> json) =>
      _$SutdaCardFromJson(json);
}

@freezed
abstract class SutdaHand with _$SutdaHand {
  const factory SutdaHand({
    required String name,
    required int rank,
    required int value,
  }) = _SutdaHand;

  factory SutdaHand.fromJson(Map<String, dynamic> json) =>
      _$SutdaHandFromJson(json);
}

class SutdaGame {
  // 섯다에서 실제로 사용하는 20장 카드 (실제 섯다 규칙에 맞게 수정)
  static List<SutdaCard> createDeck() {
    return [
      // 1월 광 (1)
      const SutdaCard(month: 1, type: 'gwang', value: 1),
      // 1월 피 (1)
      const SutdaCard(month: 1, type: 'pi1', value: 1),

      // 2월 피 (2)
      const SutdaCard(month: 2, type: 'pi1', value: 2),
      // 2월 피 (2)
      const SutdaCard(month: 2, type: 'pi2', value: 2),

      // 3월 광 (3)
      const SutdaCard(month: 3, type: 'gwang', value: 3),
      // 3월 피 (3)
      const SutdaCard(month: 3, type: 'pi1', value: 3),

      // 4월 피 (4)
      const SutdaCard(month: 4, type: 'pi1', value: 4),
      // 4월 피 (4)
      const SutdaCard(month: 4, type: 'pi2', value: 4),

      // 5월 피 (5)
      const SutdaCard(month: 5, type: 'pi1', value: 5),
      // 5월 피 (5)
      const SutdaCard(month: 5, type: 'pi2', value: 5),

      // 6월 피 (6)
      const SutdaCard(month: 6, type: 'pi1', value: 6),
      // 6월 피 (6)
      const SutdaCard(month: 6, type: 'pi2', value: 6),

      // 7월 피 (7)
      const SutdaCard(month: 7, type: 'pi1', value: 7),
      // 7월 피 (7)
      const SutdaCard(month: 7, type: 'pi2', value: 7),

      // 8월 광 (8)
      const SutdaCard(month: 8, type: 'gwang', value: 8),
      // 8월 피 (8)
      const SutdaCard(month: 8, type: 'pi1', value: 8),

      // 9월 피 (9)
      const SutdaCard(month: 9, type: 'pi1', value: 9),
      // 9월 피 (9)
      const SutdaCard(month: 9, type: 'pi2', value: 9),

      // 10월 피 (10)
      const SutdaCard(month: 10, type: 'pi1', value: 10),
      // 10월 피 (10)
      const SutdaCard(month: 10, type: 'pi2', value: 10),
    ];
  }

  // 섯다 카드 이미지 경로 반환
  static String getCardImagePath(SutdaCard card) {
    final month = card.month.toString().padLeft(2, '0');
    return 'assets/hwatu/${month}_${card.type}.png';
  }

  // 2장 족보 계산
  static SutdaHand calculateHand(SutdaCard card1, SutdaCard card2) {
    // 광땡 체크
    if (card1.type == 'gwang' && card2.type == 'gwang') {
      if ((card1.value == 3 && card2.value == 8) ||
          (card1.value == 8 && card2.value == 3)) {
        return const SutdaHand(name: '38광땡', rank: 1, value: 38);
      } else if ((card1.value == 1 && card2.value == 8) ||
          (card1.value == 8 && card2.value == 1)) {
        return const SutdaHand(name: '18광땡', rank: 2, value: 18);
      } else if ((card1.value == 1 && card2.value == 3) ||
          (card1.value == 3 && card2.value == 1)) {
        return const SutdaHand(name: '13광땡', rank: 3, value: 13);
      }
    }

    // 땡 체크
    if (card1.value == card2.value) {
      switch (card1.value) {
        case 10:
          return const SutdaHand(name: '장땡', rank: 4, value: 10);
        case 9:
          return const SutdaHand(name: '9땡', rank: 5, value: 9);
        case 8:
          return const SutdaHand(name: '8땡', rank: 6, value: 8);
        case 7:
          return const SutdaHand(name: '7땡', rank: 7, value: 7);
        case 6:
          return const SutdaHand(name: '6땡', rank: 8, value: 6);
        case 5:
          return const SutdaHand(name: '5땡', rank: 9, value: 5);
        case 4:
          return const SutdaHand(name: '4땡', rank: 10, value: 4);
        case 3:
          return const SutdaHand(name: '3땡', rank: 11, value: 3);
        case 2:
          return const SutdaHand(name: '2땡', rank: 12, value: 2);
        case 1:
          return const SutdaHand(name: '1땡', rank: 13, value: 1);
      }
    }

    // 특수 족보 체크
    final values = [card1.value, card2.value]..sort();
    if (values[0] == 1 && values[1] == 2) {
      return const SutdaHand(name: '알리', rank: 14, value: 12);
    } else if (values[0] == 1 && values[1] == 4) {
      return const SutdaHand(name: '독사', rank: 15, value: 14);
    } else if (values[0] == 1 && values[1] == 9) {
      return const SutdaHand(name: '구삥', rank: 16, value: 19);
    } else if (values[0] == 1 && values[1] == 10) {
      return const SutdaHand(name: '장삥', rank: 17, value: 110);
    } else if (values[0] == 4 && values[1] == 10) {
      return const SutdaHand(name: '장사', rank: 18, value: 410);
    } else if (values[0] == 4 && values[1] == 6) {
      return const SutdaHand(name: '세륙', rank: 19, value: 46);
    }

    // 끗수 계산
    final sum = (card1.value + card2.value) % 10;
    switch (sum) {
      case 9:
        return const SutdaHand(name: '9끗', rank: 20, value: 9);
      case 8:
        return const SutdaHand(name: '8끗', rank: 21, value: 8);
      case 7:
        return const SutdaHand(name: '7끗', rank: 22, value: 7);
      case 6:
        return const SutdaHand(name: '6끗', rank: 23, value: 6);
      case 5:
        return const SutdaHand(name: '5끗', rank: 24, value: 5);
      case 4:
        return const SutdaHand(name: '4끗', rank: 25, value: 4);
      case 3:
        return const SutdaHand(name: '3끗', rank: 26, value: 3);
      case 2:
        return const SutdaHand(name: '2끗', rank: 27, value: 2);
      case 1:
        return const SutdaHand(name: '1끗', rank: 28, value: 1);
      case 0:
        return const SutdaHand(name: '망통', rank: 29, value: 0);
      default:
        return const SutdaHand(name: '망통', rank: 29, value: 0);
    }
  }

  // 3장 섯다 족보 계산 (3장 중 2장을 선택하여 계산)
  static SutdaHand calculateThreeCardHand(List<SutdaCard> cards) {
    if (cards.length < 2) {
      return const SutdaHand(name: '패 없음', rank: 999, value: 0);
    }

    if (cards.length == 2) {
      // 2장일 때는 그대로 계산
      return calculateHand(cards[0], cards[1]);
    }

    // 3장일 때 - 모든 가능한 2장 조합 중 최고 족보 선택
    List<SutdaHand> allHands = [];

    // 3장 중 2장씩 가능한 모든 조합 (3가지)
    for (int i = 0; i < cards.length; i++) {
      for (int j = i + 1; j < cards.length; j++) {
        allHands.add(calculateHand(cards[i], cards[j]));
      }
    }

    // 가장 높은 족보 선택 (rank가 낮을수록 높은 족보)
    SutdaHand bestHand = allHands[0];
    for (var hand in allHands) {
      if (hand.rank < bestHand.rank) {
        // rank가 낮을수록 높은 족보
        bestHand = hand;
      }
    }

    return bestHand;
  }

  // 족보 설명 목록
  static const handDescriptions = [
    {'name': '38광땡', 'description': '3월 광 + 8월 광'},
    {'name': '18광땡', 'description': '1월 광 + 8월 광'},
    {'name': '13광땡', 'description': '1월 광 + 3월 광'},
    {'name': '장땡', 'description': '10 + 10'},
    {'name': '9땡', 'description': '9 + 9'},
    {'name': '8땡', 'description': '8 + 8'},
    {'name': '7땡', 'description': '7 + 7'},
    {'name': '6땡', 'description': '6 + 6'},
    {'name': '5땡', 'description': '5 + 5'},
    {'name': '4땡', 'description': '4 + 4'},
    {'name': '3땡', 'description': '3 + 3'},
    {'name': '2땡', 'description': '2 + 2'},
    {'name': '1땡', 'description': '1 + 1'},
    {'name': '알리', 'description': '1 + 2'},
    {'name': '독사', 'description': '1 + 4'},
    {'name': '구삥', 'description': '1 + 9'},
    {'name': '장삥', 'description': '1 + 10'},
    {'name': '장사', 'description': '4 + 10'},
    {'name': '세륙', 'description': '4 + 6'},
    {'name': '9끗', 'description': '합이 9'},
    {'name': '8끗', 'description': '합이 8'},
    {'name': '7끗', 'description': '합이 7'},
    {'name': '6끗', 'description': '합이 6'},
    {'name': '5끗', 'description': '합이 5'},
    {'name': '4끗', 'description': '합이 4'},
    {'name': '3끗', 'description': '합이 3'},
    {'name': '2끗', 'description': '합이 2'},
    {'name': '1끗', 'description': '합이 1'},
    {'name': '망통', 'description': '합이 0'},
  ];
}
