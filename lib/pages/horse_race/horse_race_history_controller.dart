import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../models/horse_race.dart';
import '../../define/define.dart';

class RaceHistoryItem {
  final String id;
  final String title;
  final DateTime createdAt;
  final Horse? firstPlace;
  final Horse? secondPlace;
  final Horse? thirdPlace;
  final int totalBets;

  RaceHistoryItem({
    required this.id,
    required this.title,
    required this.createdAt,
    this.firstPlace,
    this.secondPlace,
    this.thirdPlace,
    required this.totalBets,
  });

  factory RaceHistoryItem.fromHorseRace(HorseRace race, int totalBets) {
    // movements 배열의 마지막 값(최종 위치)을 기준으로 순위 계산
    final horsesWithFinalPosition =
        race.horses.map((horse) {
          final finalPosition =
              horse.movements.isNotEmpty
                  ? horse.movements.last
                  : horse.currentPosition;
          return MapEntry(horse, finalPosition);
        }).toList();

    // 최종 위치가 가장 작은 순서대로 정렬 (가장 앞선 말이 1등)
    horsesWithFinalPosition.sort((a, b) => a.value.compareTo(b.value));

    // 1, 2, 3등 추출
    Horse? firstPlace =
        horsesWithFinalPosition.isNotEmpty
            ? horsesWithFinalPosition[0].key
            : null;
    Horse? secondPlace =
        horsesWithFinalPosition.length > 1
            ? horsesWithFinalPosition[1].key
            : null;
    Horse? thirdPlace =
        horsesWithFinalPosition.length > 2
            ? horsesWithFinalPosition[2].key
            : null;

    return RaceHistoryItem(
      id: race.id,
      title: '코인 경마 ${race.currentRound}라운드',
      createdAt: race.endTime,
      firstPlace: firstPlace,
      secondPlace: secondPlace,
      thirdPlace: thirdPlace,
      totalBets: totalBets,
    );
  }
}

class HorseRaceHistoryController extends GetxController {
  final logger = Logger();
  final RxList<RaceHistoryItem> raceHistory = <RaceHistoryItem>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  /// 경마 히스토리 로드
  Future<void> loadHistory() async {
    try {
      isLoading.value = true;

      // 완료된 경마들을 최신순으로 가져오기 (최대 50개)
      final raceQuery =
          await FirebaseFirestore.instance
              .collection(Define.FIRESTORE_COLLECTION_HORSE_RACE)
              .where('isFinished', isEqualTo: true)
              .orderBy('endTime', descending: true)
              .limit(50)
              .get();

      final List<RaceHistoryItem> historyItems = [];
      logger.d('완료된 경마 수: ${raceQuery.docs.length}');

      for (final raceDoc in raceQuery.docs) {
        try {
          final raceData = raceDoc.data();
          final race = HorseRace.fromJson(raceData);

          logger.d('경마 데이터: ${race.id}, 완료: ${race.isFinished}');
          logger.d(
            '말들의 최종 위치: ${race.horses.map((h) => '${h.name}: ${h.movements.isNotEmpty ? h.movements.last : h.currentPosition}').join(', ')}',
          );

          // 해당 경마의 총 베팅 수 계산
          final betsQuery =
              await FirebaseFirestore.instance
                  .collection(Define.FIRESTORE_COLLECTION_HORSE_RACE)
                  .doc(race.id)
                  .collection('bets')
                  .get();

          final totalBets = betsQuery.docs.length;

          final historyItem = RaceHistoryItem.fromHorseRace(race, totalBets);
          logger.d(
            '히스토리 아이템: 1등=${historyItem.firstPlace?.name}, 2등=${historyItem.secondPlace?.name}, 3등=${historyItem.thirdPlace?.name}',
          );

          historyItems.add(historyItem);
        } catch (e) {
          logger.e('경마 데이터 파싱 오류: $e');
          // 개별 경마 데이터 파싱 오류는 무시하고 계속 진행
          continue;
        }
      }

      raceHistory.value = historyItems;
    } catch (e) {
      // 전체 로딩 실패 시 빈 리스트로 설정
      raceHistory.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// 히스토리 새로고침
  Future<void> refreshHistory() async {
    await loadHistory();
  }

  /// 날짜 포맷팅
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(date);
    } else if (difference.inDays == 1) {
      return '어제';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return DateFormat('MM/dd').format(date);
    }
  }
}
