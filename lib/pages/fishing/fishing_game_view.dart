import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'fishing_game_controller.dart';

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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 현재 물고기 정보
                  _buildFishInfo(),

                  // 결과 메시지 (물고기 카드 아래)
                  _buildResultMessage(),

                  const SizedBox(height: 20),

                  // 게임 영역
                  Expanded(
                    child: Row(
                      children: [
                        // 낚싯대 영역 (왼쪽)
                        Expanded(flex: 3, child: _buildFishingRod()),
                        const SizedBox(width: 20),

                        // 성공 게이지 (오른쪽)
                        _buildSuccessGauge(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 통합 컨트롤 버튼
                  _buildUnifiedControlButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              isGameActive && !showResult ? '❓' : fish.emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isGameActive && !showResult ? '???' : fish.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isGameActive && !showResult
                        ? '어떤 물고기가 나올까요?'
                        : fish.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (!isGameActive || showResult)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(fish.difficulty),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${fish.reward}P',
                  style: const TextStyle(
                    color: Colors.white,
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
              duration: const Duration(milliseconds: 200), // 부드러운 애니메이션
              curve: Curves.easeInOut, // 부드러운 곡선
              left: 20,
              right: 20,
              top:
                  (1 - controller.fishPosition.value - fish.size / 2) *
                  (Get.height * 0.4), // 대략적인 높이 계산
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150), // 크기 변화도 부드럽게
                curve: Curves.easeInOut,
                height: fish.size * (Get.height * 0.4),
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.7), // 물고기 범위는 불투명하게
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
                          style: TextStyle(
                            fontSize: 24,
                            shadows: [
                              Shadow(
                                color: Colors.white.withOpacity(0.8),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }),

          // 플레이어 바 (초록색) - 반투명으로 물고기가 보이도록
          Obx(
            () => Positioned(
              left: 40, // 물고기 범위(left: 20)보다 더 안쪽에 위치
              right: 40, // 물고기 범위(right: 20)보다 더 안쪽에 위치
              top:
                  (1 -
                      controller.playerBarPosition.value -
                      FishingGameController.barSize / 2) *
                  (Get.height * 0.4),
              child: Container(
                height: FishingGameController.barSize * (Get.height * 0.4),
                decoration: BoxDecoration(
                  color: (controller.isButtonPressed.value
                          ? Colors.lightGreen
                          : Colors.green)
                      .withOpacity(0.4), // 플레이어 바를 더 투명하게
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green[800]!,
                    width: 3,
                  ), // 테두리 굵게
                ),
              ),
            ),
          ),
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Obx(
        () => Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(4),
                child: Stack(
                  children: [
                    // 배경
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    // 게이지
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: controller.successGauge.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getGaugeColor(
                              controller.successGauge.value,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '${(controller.successGauge.value * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 게이지 색상
  Color _getGaugeColor(double value) {
    if (value < 0.3) return Colors.red;
    if (value < 0.7) return Colors.orange;
    return Colors.green;
  }

  /// 통합 컨트롤 버튼
  Widget _buildUnifiedControlButton() {
    return Obx(() {
      if (!controller.isGameActive.value) {
        // 게임이 시작되지 않았을 때 - 시작 버튼
        return SizedBox(
          width: double.infinity,
          height: 80,
          child: ElevatedButton(
            onPressed:
                controller.isButtonDisabled.value
                    ? null
                    : () => controller.startGame(),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  controller.isButtonDisabled.value
                      ? Colors.grey
                      : Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: controller.isButtonDisabled.value ? 0 : 4,
            ),
            child: Text(
              controller.showResult.value
                  ? (controller.gameResult.value ? '🎣 다시 낚시하기' : '🎣 재도전하기')
                  : '🎣 낚시 시작',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        );
      } else {
        // 게임 중일 때 - 낚싯줄 당기기 버튼
        return GestureDetector(
          onTapDown:
              controller.isButtonDisabled.value
                  ? null
                  : (_) => controller.onButtonPressed(),
          onTapUp:
              controller.isButtonDisabled.value
                  ? null
                  : (_) => controller.onButtonReleased(),
          onTapCancel:
              controller.isButtonDisabled.value
                  ? null
                  : () => controller.onButtonReleased(),
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color:
                  controller.isButtonDisabled.value
                      ? Colors.grey
                      : (controller.isButtonPressed.value
                          ? Colors.blue[700]
                          : Colors.blue),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                controller.isButtonDisabled.value
                    ? '🎣 잠시 기다려주세요...'
                    : '🎣 낚싯줄 당기기\n(길게 누르세요)',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  /// 결과 메시지 (물고기 카드 아래)
  Widget _buildResultMessage() {
    return Obx(() {
      if (!controller.showResultMessage.value) {
        return const SizedBox.shrink();
      }

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    controller.gameResult.value
                        ? Colors.green.withOpacity(0.9)
                        : Colors.red.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color:
                      controller.gameResult.value
                          ? Colors.green[700]!
                          : Colors.red[700]!,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  // 결과 아이콘
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.bounceOut,
                    builder: (context, iconValue, child) {
                      return Transform.scale(
                        scale: iconValue,
                        child: Text(
                          controller.gameResult.value ? '🎉' : '😢',
                          style: const TextStyle(fontSize: 32),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 16),

                  // 결과 메시지
                  Expanded(
                    child: Text(
                      controller.getResultMessage(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
