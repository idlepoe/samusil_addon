import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../models/horse_race.dart';
import '../../define/define.dart';

class CoinWinStats {
  final String coinId;
  final String name;
  final String symbol;
  final String image;
  final int totalRaces;
  final int wins;
  final double winRate;

  CoinWinStats({
    required this.coinId,
    required this.name,
    required this.symbol,
    required this.image,
    required this.totalRaces,
    required this.wins,
    required this.winRate,
  });
}

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
  final RxList<CoinWinStats> topWinners = <CoinWinStats>[].obs;
  final RxBool isLoadingStats = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
    loadTopWinners();
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

  /// 24시간 동안 가장 많이 승리한 코인들 로드
  Future<void> loadTopWinners() async {
    try {
      isLoadingStats.value = true;

      // 24시간 전 시간 계산
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(hours: 24));

      // 24시간 내 완료된 경마들 가져오기
      final raceQuery =
          await FirebaseFirestore.instance
              .collection(Define.FIRESTORE_COLLECTION_HORSE_RACE)
              .where('isFinished', isEqualTo: true)
              .where('endTime', isGreaterThan: Timestamp.fromDate(yesterday))
              .get();

      logger.i('24시간 내 완료된 경마 수: ${raceQuery.docs.length}');

      // 24시간 내 경마가 없으면 빈 리스트 반환
      if (raceQuery.docs.isEmpty) {
        logger.i('24시간 내 완료된 경마가 없습니다');
        topWinners.value = [];
        return;
      }

      // 코인별 승리 통계 계산
      final Map<String, Map<String, dynamic>> coinStats = {};

      for (final raceDoc in raceQuery.docs) {
        try {
          final raceData = raceDoc.data();
          final race = HorseRace.fromJson(raceData);

          // 각 말의 최종 위치 계산
          final horsesWithFinalPosition =
              race.horses.map((horse) {
                final finalPosition =
                    horse.movements.isNotEmpty
                        ? horse.movements.last
                        : horse.currentPosition;
                return MapEntry(horse, finalPosition);
              }).toList();

          // 최종 위치로 정렬 (가장 앞선 말이 1등)
          horsesWithFinalPosition.sort((a, b) => b.value.compareTo(a.value));

          // 1등 말 찾기
          if (horsesWithFinalPosition.isNotEmpty) {
            final winner = horsesWithFinalPosition.first.key;

            if (!coinStats.containsKey(winner.coinId)) {
              coinStats[winner.coinId] = {
                'name': winner.name,
                'symbol': winner.symbol,
                'image': winner.image,
                'totalRaces': 0,
                'wins': 0,
              };
            }

            coinStats[winner.coinId]!['wins']++;
          }

          // 모든 말의 총 경주 수 증가
          for (final horse in race.horses) {
            if (!coinStats.containsKey(horse.coinId)) {
              coinStats[horse.coinId] = {
                'name': horse.name,
                'symbol': horse.symbol,
                'image': horse.image,
                'totalRaces': 0,
                'wins': 0,
              };
            }
            coinStats[horse.coinId]!['totalRaces']++;
          }
        } catch (e) {
          logger.e('경마 통계 처리 오류: $e');
          continue;
        }
      }

      // CoinWinStats 객체로 변환 및 정렬
      final List<CoinWinStats> winStats =
          coinStats.entries.where((entry) => entry.value['totalRaces'] > 0).map(
            (entry) {
              final stats = entry.value;
              final winRate =
                  stats['totalRaces'] > 0
                      ? (stats['wins'] / stats['totalRaces']) * 100
                      : 0.0;

              return CoinWinStats(
                coinId: entry.key,
                name: stats['name'],
                symbol: stats['symbol'],
                image: stats['image'],
                totalRaces: stats['totalRaces'],
                wins: stats['wins'],
                winRate: winRate,
              );
            },
          ).toList();

      // 승수로 정렬 후 승률로 정렬
      winStats.sort((a, b) {
        if (a.wins != b.wins) {
          return b.wins.compareTo(a.wins); // 승수 내림차순
        }
        return b.winRate.compareTo(a.winRate); // 승률 내림차순
      });

      // 상위 3개만 저장
      topWinners.value = winStats.take(3).toList();
    } catch (e) {
      logger.e('승리 통계 로딩 오류: $e');
      topWinners.value = [];
    } finally {
      isLoadingStats.value = false;
    }
  }

  /// 히스토리 새로고침
  Future<void> refreshHistory() async {
    await Future.wait([loadHistory(), loadTopWinners()]);
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
