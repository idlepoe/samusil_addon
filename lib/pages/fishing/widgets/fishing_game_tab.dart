import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../fishing_game_controller.dart';
import '../../../models/fish.dart';
import 'fish_detail_dialog.dart';

/// 낚시 게임 탭
class FishingGameTab extends GetView<FishingGameController> {
  const FishingGameTab({super.key});

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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 현재 물고기 정보 카드 (별도 분리)
                _buildFishInfo(),

                const SizedBox(height: 16),

                // 게임 영역 (전체가 버튼으로 동작)
                Expanded(child: _buildGameArea()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 결과 메시지 위젯
  Widget _buildResultMessage() {
    return Obx(() {
      if (!controller.showResult.value) {
        return const SizedBox.shrink();
      }

      final success = controller.gameResult.value;
      final fish = controller.currentFish.value;

      if (fish == null) return const SizedBox.shrink();

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: success ? Colors.green[50] : Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: success ? Colors.green[300]! : Colors.red[300]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // 좌측: 아이콘과 제목
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  success ? '🎉' : '😢',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  success ? '낚시 성공!' : '낚시 실패!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: success ? Colors.green[800] : Colors.red[800],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // 우측: 메시지 (2줄 표시)
            Expanded(
              child: Text(
                controller.getResultMessage(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: success ? Colors.green[700] : Colors.red[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    });
  }

  /// 현재 물고기 정보
  Widget _buildFishInfo() {
    return Obx(() {
      final fish = controller.currentFish.value;
      if (fish == null) return const SizedBox.shrink();

      // 게임 중에는 물고기 정보를 숨김
      bool isGameActive = controller.isGameActive.value;
      bool showResult = controller.showResult.value;

      // 잡은 물고기인지 확인
      final isCaught = controller.caughtFish.value.contains(fish.name);

      return InkWell(
        onTap: () => _showFishDetailDialog(fish, isCaught),
        borderRadius: BorderRadius.circular(8),
        child: Container(
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
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            fish.appearanceTimeText,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.stars, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${fish.reward}P',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // 터치 가능함을 나타내는 아이콘
              Icon(Icons.info_outline, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      );
    });
  }

  /// 게임 영역 (전체가 버튼으로 동작)
  Widget _buildGameArea() {
    return Obx(() {
      final isGameActive = controller.isGameActive.value;
      final isDisabled = controller.isButtonDisabled.value;
      final showResult = controller.showResult.value;

      String buttonText;
      String statusText;

      if (isGameActive) {
        buttonText = "낚싯줄 당기기";
        statusText = "버튼을 누르고 있으면 낚싯줄이 올라갑니다";
      } else if (showResult) {
        buttonText = "다시 낚시하기";
        statusText = "결과를 확인하고 다시 도전해보세요";
      } else {
        buttonText = "낚시 시작";
        statusText = "게임 영역을 터치하여 낚시를 시작하세요";
      }

      return GestureDetector(
        onTap:
            !isGameActive && !isDisabled
                ? (showResult ? controller.restartGame : controller.startGame)
                : null,
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 게임 콘텐츠 영역
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 결과 메시지
                    _buildResultMessage(),

                    // 결과 메시지와 게임 영역 사이 간격
                    if (controller.showResult.value) const SizedBox(height: 24),

                    // 게임 영역
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF87CEEB).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF4682B4),
                            width: 2,
                          ),
                        ),
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
                    ),

                    const SizedBox(height: 20),

                    // 버튼 영역 (별도 컨테이너)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isDisabled
                                ? Colors.grey[400]
                                : const Color(0xFF4682B4),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            buttonText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 버튼 눌림 효과 (전체 영역)
              if (isGameActive && controller.isButtonPressed.value)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF4682B4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  /// 낚싯대 영역
  Widget _buildFishingRod() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
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
              left: 40, // 원래 위치로 복원
              right: 40, // 원래 위치로 복원
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

          // 루어 이미지 (플레이어바 대신) - 전경에 위치, 물고기 범위와 겹침
          Obx(() {
            final playerBarHeight =
                FishingGameController.barSize *
                (MediaQuery.of(Get.context!).size.height * 0.5);
            final isPressed = controller.isButtonPressed.value;

            return AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              left: 40,
              right: 40,
              top:
                  (1 -
                      controller.playerBarPosition.value -
                      FishingGameController.barSize / 2) *
                  (MediaQuery.of(Get.context!).size.height * 0.3),
              child: Container(
                height: playerBarHeight,
                child: Center(
                  child: AnimatedRotation(
                    turns: isPressed ? -0.1 : 0.1, // 눌렀을 때 왼쪽(-), 놓았을 때 오른쪽(+)
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Image.asset(
                      'assets/lure.png',
                      width: playerBarHeight * 1.6, // 2배 크기 (0.8 * 2)
                      height: playerBarHeight * 1.6, // 2배 크기 (0.8 * 2)
                      fit: BoxFit.contain,
                    ),
                  ),
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

        // 게이지 수준에 따른 파스텔 색상 결정
        Color gaugeColor;
        if (gauge >= 0.8) {
          gaugeColor = const Color(0xFFB8E6B8); // 파스텔 그린
        } else if (gauge >= 0.6) {
          gaugeColor = const Color(0xFFFFE4B5); // 파스텔 오렌지
        } else if (gauge >= 0.4) {
          gaugeColor = const Color(0xFFFFD1DC); // 파스텔 핑크
        } else if (gauge >= 0.2) {
          gaugeColor = const Color(0xFFFFB6C1); // 파스텔 로즈
        } else {
          gaugeColor = const Color(0xFFFFC0CB); // 파스텔 레드
        }

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
                        // 게이지 채워진 부분 (하단부터)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: constraints.maxHeight * gauge,
                          child: Container(
                            decoration: BoxDecoration(
                              color: gaugeColor,
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

  /// 물고기 상세 정보 다이얼로그
  void _showFishDetailDialog(Fish fish, bool isCaught) {
    showDialog(
      context: Get.context!,
      builder: (context) => FishDetailDialog(fish: fish, isCaught: isCaught),
    );
  }
}
