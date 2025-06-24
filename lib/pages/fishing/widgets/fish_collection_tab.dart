import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../fishing_game_controller.dart';
import '../../../models/fish.dart';
import 'fish_detail_dialog.dart';

/// 물고기 도감 탭
class FishCollectionTab extends GetView<FishingGameController> {
  const FishCollectionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 도감 헤더
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF4682B4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.book, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text(
                      '물고기 도감',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Obx(() {
                      final caughtCount = controller.caughtFish.value.length;
                      final totalCount = Fish.allFish.length;
                      return Text(
                        '$caughtCount/$totalCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // 진행률 바
              Obx(() {
                final progress =
                    controller.caughtFish.value.length / Fish.allFish.length;
                return SizedBox(
                  height: 4,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF4682B4),
                    ),
                  ),
                );
              }),

              // 물고기 목록
              Expanded(
                child: Obx(() {
                  final allFish = Fish.allFish;
                  final caughtFishSet = controller.caughtFish.value;
                  final todayLocation = Fish.getTodayLocation();

                  // 오늘 출현 가능한 물고기를 먼저 표시
                  final todayFish =
                      allFish
                          .where((fish) => fish.location == todayLocation)
                          .toList();
                  final otherFish =
                      allFish
                          .where((fish) => fish.location != todayLocation)
                          .toList();

                  return ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      // 오늘 출현 가능한 물고기 섹션
                      if (todayFish.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.today,
                                size: 16,
                                color: Colors.green[700],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '오늘 출현 가능한 물고기 (${Fish.getTodayLocationDescription()})',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
                                  maxLines: null, // 여러 줄 표시 허용
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...todayFish.map(
                          (fish) => _buildFishItem(fish, caughtFishSet),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // 기타 물고기 섹션
                      if (otherFish.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.water_drop,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '기타 물고기',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...otherFish.map(
                          (fish) => _buildFishItem(fish, caughtFishSet),
                        ),
                      ],
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 물고기 아이템 위젯
  Widget _buildFishItem(Fish fish, Set<String> caughtFishSet) {
    final isCaught = caughtFishSet.contains(fish.name);
    final isAvailableNow = fish.isAvailableNow();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showFishDetailDialog(fish, isCaught),
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCaught ? Colors.white : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      isCaught
                          ? _getDifficultyColor(fish.difficulty)
                          : Colors.grey[300]!,
                  width: isCaught ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  // 물고기 이모지
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          isCaught
                              ? _getDifficultyColor(
                                fish.difficulty,
                              ).withOpacity(0.1)
                              : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        isCaught ? fish.emoji : '❓',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 물고기 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCaught ? fish.name : '???',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isCaught ? Colors.black : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isCaught ? fish.description : '이 물고기는 아직 잡지 못했습니다.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // 우측 정보 (포인트만 표시)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (isCaught) ...[
                        // 포인트 표시
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(fish.difficulty),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${fish.reward}P',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      // 아직 잡지 못한 물고기의 출현 상태 뱃지 (오른쪽에 표시)
                      if (!isCaught)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isAvailableNow ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isAvailableNow ? '출현중' : '미출현',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // 출현 상태 뱃지 (잡은 물고기만 왼쪽 최상단에 겹쳐서 표시)
            if (isCaught)
              Positioned(
                left: -1,
                top: -1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isAvailableNow ? Colors.green : Colors.red,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Text(
                    isAvailableNow ? '출현중' : '미출현',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // 보유 수량 표시 (우측 최상단에 표시, 0마리일 때는 표시하지 않음)
            if (isCaught)
              Positioned(
                right: -1,
                top: -1,
                child: Obx(() {
                  final count = controller.getCurrentFishCount(fish.id);
                  if (count > 0) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Text(
                        '보유: ${count}마리',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ),
          ],
        ),
      ),
    );
  }

  /// 물고기 상세 정보 다이얼로그
  void _showFishDetailDialog(Fish fish, bool isCaught) {
    showDialog(
      context: Get.context!,
      builder: (context) => FishDetailDialog(fish: fish, isCaught: isCaught),
    );
  }

  /// 난이도별 색상
  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
