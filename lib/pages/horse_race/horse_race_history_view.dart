import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/appCircularProgress.dart';
import 'horse_race_history_controller.dart';

class HorseRaceHistoryView extends GetView<HorseRaceHistoryController> {
  const HorseRaceHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('경마 기록'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AppCircularProgress());
        }

        if (controller.raceHistory.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  '경마 기록이 없습니다',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshHistory,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount:
                controller.raceHistory.length + 1, // +1 for top winners widget
            itemBuilder: (context, index) {
              // 첫 번째 아이템은 24시간 승리 통계
              if (index == 0) {
                return _buildTopWinnersWidget();
              }

              // 나머지는 경마 기록
              final raceIndex = index - 1;
              final race = controller.raceHistory[raceIndex];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 경마 제목과 날짜
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              race.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            controller.formatDate(race.createdAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 순위 표시
                      Row(
                        children: [
                          // 1등
                          _buildRankCard(
                            rank: '1등',
                            horseName: race.firstPlace?.name ?? '',
                            color: Colors.amber,
                            icon: Icons.emoji_events,
                            coinImage: race.firstPlace?.image,
                          ),
                          const SizedBox(width: 8),

                          // 2등
                          _buildRankCard(
                            rank: '2등',
                            horseName: race.secondPlace?.name ?? '',
                            color: Colors.grey[400]!,
                            icon: Icons.workspace_premium,
                            coinImage: race.secondPlace?.image,
                          ),
                          const SizedBox(width: 8),

                          // 3등
                          _buildRankCard(
                            rank: '3등',
                            horseName: race.thirdPlace?.name ?? '',
                            color: Colors.brown[300]!,
                            icon: Icons.military_tech,
                            coinImage: race.thirdPlace?.image,
                          ),
                        ],
                      ),

                      // 총 참여자 수
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.people,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '총 ${race.totalBets}명 참여',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildRankCard({
    required String rank,
    required String horseName,
    required Color color,
    required IconData icon,
    String? coinImage,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(
              rank,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            // 코인 이미지와 이름을 함께 표시
            if (horseName.isNotEmpty && coinImage != null) ...[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: ClipOval(
                  child: Image.network(
                    coinImage,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 24,
                        height: 24,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.currency_bitcoin,
                          size: 16,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              horseName.isEmpty ? '미정' : horseName,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    horseName.isEmpty ? FontWeight.normal : FontWeight.bold,
                color: horseName.isEmpty ? Colors.grey : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopWinnersWidget() {
    return Obx(() {
      if (controller.isLoadingStats.value) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: 120,
            child: const Center(child: AppCircularProgress()),
          ),
        );
      }

      if (controller.topWinners.isEmpty) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.trending_up, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  '지난 24시간 동안 완료된 경마가 없습니다',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '경마가 완료되면 승리 통계가 표시됩니다',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
        );
      }

      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '24시간 최다 승리 코인',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF191F28),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children:
                    controller.topWinners.asMap().entries.map((entry) {
                      final index = entry.key;
                      final winner = entry.value;
                      final rankColors = [
                        Colors.amber,
                        Colors.grey[400]!,
                        Colors.brown[300]!,
                      ];
                      final rankIcons = [
                        Icons.emoji_events,
                        Icons.workspace_premium,
                        Icons.military_tech,
                      ];

                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                          child: _buildWinnerCard(
                            rank: '${index + 1}등',
                            winner: winner,
                            color: rankColors[index],
                            icon: rankIcons[index],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildWinnerCard({
    required String rank,
    required dynamic winner,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // 순위 아이콘
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 6),
          Text(
            rank,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          // 코인 이미지
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: ClipOval(
              child: Image.network(
                winner.image,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 32,
                    height: 32,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.currency_bitcoin,
                      size: 20,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          // 코인 이름
          Text(
            winner.symbol,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // 승수
          Text(
            '${winner.wins}승',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          // 승률
          Text(
            '${winner.winRate.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
