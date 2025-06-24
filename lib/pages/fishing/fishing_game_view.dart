import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'fishing_game_controller.dart';
import '../../models/fish.dart';

class FishingGameView extends GetView<FishingGameController> {
  const FishingGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB), // 하늘색 배경
      appBar: AppBar(
        title: const Text(
          '🎣 낚시 게임',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4682B4),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 왼쪽: 게임 화면
              Expanded(flex: 3, child: _buildGameArea()),

              const SizedBox(width: 16),

              // 오른쪽: 물고기 도감
              Expanded(flex: 2, child: _buildFishCollection()),
            ],
          ),
        ),
      ),
    );
  }

  /// 게임 영역 (왼쪽)
  Widget _buildGameArea() {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 현재 물고기 정보
            _buildFishInfo(),

            // 결과 메시지
            _buildResultMessage(),

            const SizedBox(height: 16),

            // 게임 영역
            Expanded(
              child: Row(
                children: [
                  // 낚싯대 영역
                  Expanded(flex: 3, child: _buildFishingRod()),
                  const SizedBox(width: 16),

                  // 성공 게이지
                  _buildSuccessGauge(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 통합 컨트롤 버튼
            _buildUnifiedControlButton(),
          ],
        ),
      ),
    );
  }

  /// 물고기 도감 (오른쪽)
  Widget _buildFishCollection() {
    return Container(
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
            return Container(
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
              final caughtFishSet =
                  controller.caughtFish.value; // reactive 변수 직접 참조
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: allFish.length,
                itemBuilder: (context, index) {
                  final fish = allFish[index];
                  final isCaught = caughtFishSet.contains(fish.name);
                  return _buildFishCollectionItem(fish, isCaught);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// 도감 아이템
  Widget _buildFishCollectionItem(Fish fish, bool isCaught) {
    return GestureDetector(
      onTap: () => _showFishDetailDialog(fish, isCaught),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: Stack(
          children: [
            // 메인 컨테이너
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isCaught ? Colors.blue[50] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCaught ? Colors.blue[200]! : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    isCaught ? fish.emoji : '❓',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCaught ? fish.name : '???',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isCaught ? Colors.black : Colors.grey[600],
                          ),
                        ),
                        if (isCaught) ...[
                          Text(
                            fish.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            fish.appearanceTimeText,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (isCaught)
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
                  // 아직 잡지 못한 물고기의 출현 상태 뱃지 (오른쪽에 표시)
                  if (!isCaught)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            fish.isAvailableNow() ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        fish.isAvailableNow() ? '출현중' : '미출현',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                    color: fish.isAvailableNow() ? Colors.green : Colors.red,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Text(
                    fish.isAvailableNow() ? '출현중' : '미출현',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    _getDifficultyColor(fish.difficulty).withOpacity(0.1),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 물고기 이모지와 이름
                  Row(
                    children: [
                      Text(
                        isCaught ? fish.emoji : '❓',
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isCaught ? fish.name : '???',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isCaught) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(fish.difficulty),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _getDifficultyText(fish.difficulty),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 설명
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        Text(
                          isCaught
                              ? fish.description
                              : '이 물고기는 아직 잡지 못했습니다.\n낚시를 해서 잡아보세요!',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (isCaught) ...[
                          const SizedBox(height: 12),
                          Divider(color: Colors.grey[300]),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '출현 장소: ${fish.location}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '출현 시간: ${fish.appearanceTimeText}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.stars,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '보상: ${fish.reward}P',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  if (isCaught) ...[
                    const SizedBox(height: 16),

                    // 포획 메시지
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[300]!),
                      ),
                      child: Text(
                        fish.catchMessage,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          color: Colors.green[800],
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 통계 정보
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            '난이도',
                            _getDifficultyText(fish.difficulty),
                            _getDifficultyColor(fish.difficulty),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FutureBuilder<int>(
                            future: controller.getFishCount(fish.name),
                            builder: (context, snapshot) {
                              final count = snapshot.data ?? 0;
                              return _buildStatCard(
                                '잡은 횟수',
                                '${count}마리',
                                Colors.blue,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 20),

                  // 닫기 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4682B4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '닫기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  /// 통계 카드
  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 난이도 텍스트
  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 1:
        return '쉬움';
      case 2:
        return '보통';
      case 3:
        return '어려움';
      case 4:
        return '희귀';
      case 5:
        return '전설';
      default:
        return '알 수 없음';
    }
  }

  /// 현재 물고기 정보
  Widget _buildFishInfo() {
    return Obx(() {
      final fish = controller.currentFish.value;
      if (fish == null) return const SizedBox.shrink();

      // 게임 중에는 물고기 정보를 숨김
      bool isGameActive = controller.isGameActive.value;
      bool showResult = controller.showResult.value;

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Text(
              isGameActive && !showResult ? '❓' : fish.emoji,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isGameActive && !showResult ? '???' : fish.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isGameActive && !showResult
                        ? '어떤 물고기가 나올까요?'
                        : fish.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isGameActive || showResult) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            fish.appearanceTimeText,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (!isGameActive || showResult)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(fish.difficulty),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${fish.reward}P',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  /// 결과 메시지
  Widget _buildResultMessage() {
    return Obx(() {
      if (!controller.showResultMessage.value) {
        return const SizedBox.shrink();
      }

      final isSuccess = controller.gameResult.value;
      final message = controller.getResultMessage();

      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSuccess ? Colors.green[50] : Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSuccess ? Colors.green[300]! : Colors.red[300]!,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.cancel,
              color: isSuccess ? Colors.green : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 12,
                  color: isSuccess ? Colors.green[800] : Colors.red[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// 난이도별 색상
  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1: // 쉬움
        return Colors.green;
      case 2: // 보통
        return Colors.orange;
      case 3: // 어려움
        return Colors.red;
      case 4: // 희귀
        return Colors.purple;
      case 5: // 전설
        return Colors.amber[700]!;
      default:
        return Colors.grey;
    }
  }

  /// 낚싯대 영역
  Widget _buildFishingRod() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4169E1).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4169E1), width: 2),
      ),
      child: Stack(
        children: [
          // 물고기 범위 (노란색) - 배경에 위치
          Obx(() {
            final fish = controller.currentFish.value;
            if (fish == null) return const SizedBox.shrink();

            return AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: 40,
              right: 40,
              top:
                  (1 - controller.fishPosition.value - fish.size / 2) *
                  (MediaQuery.of(Get.context!).size.height * 0.3),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                height:
                    fish.size * (MediaQuery.of(Get.context!).size.height * 0.3),
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1.2),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Text(
                          fish.emoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }),

          // 플레이어 바 (초록색) - 전경에 위치
          Obx(() {
            return Positioned(
              left: 40,
              right: 40,
              top:
                  (1 -
                      controller.playerBarPosition.value -
                      FishingGameController.barSize / 2) *
                  (MediaQuery.of(Get.context!).size.height * 0.3),
              child: Container(
                height:
                    FishingGameController.barSize *
                    (MediaQuery.of(Get.context!).size.height * 0.3),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[700]!, width: 2),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 성공 게이지
  Widget _buildSuccessGauge() {
    return Container(
      width: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[400]!, width: 2),
      ),
      child: Obx(() {
        final gauge = controller.successGauge.value;
        return Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey[200], // 배경색
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        // 게이지 배경 (전체)
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.green, Colors.orange, Colors.red],
                            ),
                          ),
                        ),
                        // 게이지 마스크 (비어있는 부분)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height:
                              constraints.maxHeight *
                              (1.0 - gauge), // 상단부터 비어있는 높이
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  /// 통합 컨트롤 버튼
  Widget _buildUnifiedControlButton() {
    return Obx(() {
      final isGameActive = controller.isGameActive.value;
      final isDisabled = controller.isButtonDisabled.value;
      final showResult = controller.showResult.value;

      String buttonText;
      VoidCallback? onPressed;

      if (isGameActive) {
        buttonText = "낚싯줄 당기기";
        onPressed = isDisabled ? null : () {};
      } else if (showResult) {
        buttonText = "다시 낚시하기";
        onPressed = isDisabled ? null : controller.restartGame;
      } else {
        buttonText = "낚시 시작";
        onPressed = isDisabled ? null : controller.startGame;
      }

      return GestureDetector(
        onTap: !isGameActive && !isDisabled ? onPressed : null,
        onTapDown:
            isGameActive && !isDisabled
                ? (_) => controller.onButtonPressed()
                : null,
        onTapUp:
            isGameActive && !isDisabled
                ? (_) => controller.onButtonReleased()
                : null,
        onTapCancel:
            isGameActive && !isDisabled
                ? () => controller.onButtonReleased()
                : null,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: isDisabled ? Colors.grey : const Color(0xFF4682B4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }
}
