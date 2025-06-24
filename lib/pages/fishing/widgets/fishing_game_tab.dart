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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 현재 물고기 정보 카드
              _buildFishInfo(),

              const SizedBox(height: 20),

              // 게임 영역
              Expanded(child: _buildGameArea()),
            ],
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
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                success
                    ? [
                      const Color(0xFF10B981).withOpacity(0.1),
                      const Color(0xFF059669).withOpacity(0.05),
                    ]
                    : [
                      const Color(0xFFEF4444).withOpacity(0.1),
                      const Color(0xFFDC2626).withOpacity(0.05),
                    ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                success
                    ? const Color(0xFF10B981).withOpacity(0.2)
                    : const Color(0xFFEF4444).withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // 좌측: 아이콘
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    success
                        ? const Color(0xFF10B981).withOpacity(0.1)
                        : const Color(0xFFEF4444).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                success ? '🎉' : '😢',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 16),
            // 우측: 텍스트 내용
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    success ? '낚시 성공!' : '낚시 실패!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color:
                          success
                              ? const Color(0xFF059669)
                              : const Color(0xFFDC2626),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.getResultMessage(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color:
                          success
                              ? const Color(0xFF047857)
                              : const Color(0xFFB91C1C),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showFishDetailDialog(fish, isCaught),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF64748B).withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Row(
              children: [
                // 물고기 이모지 컨테이너
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF3B82F6).withOpacity(0.1),
                        const Color(0xFF1D4ED8).withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      isGameActive && !showResult ? '❓' : fish.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isGameActive && !showResult ? '???' : fish.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isGameActive && !showResult
                            ? '어떤 물고기가 나올까요?'
                            : fish.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!isGameActive || showResult) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: const Color(0xFF3B82F6),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    fish.appearanceTimeText,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF3B82F6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.stars,
                                    size: 14,
                                    color: const Color(0xFF10B981),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${fish.reward}P',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF10B981),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // 정보 아이콘
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF64748B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    size: 20,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
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
      final hasInsufficientPoints = controller.hasInsufficientPoints.value;

      String buttonText;
      String statusText;

      if (hasInsufficientPoints && !isGameActive) {
        buttonText = "포인트 부족";
        statusText = controller.insufficientPointsMessage;
      } else if (isGameActive) {
        buttonText = "낚싯줄 당기기";
        statusText = "버튼을 누르고 있으면 낚싯줄이 올라갑니다";
      } else if (showResult) {
        buttonText = hasInsufficientPoints ? "포인트 부족" : "다시 낚시하기";
        statusText =
            hasInsufficientPoints
                ? controller.insufficientPointsMessage
                : "결과를 확인하고 다시 도전해보세요";
      } else {
        buttonText = "낚시 시작 (참여비: 5P)";
        statusText = "게임 영역을 터치하여 낚시를 시작하세요";
      }

      return GestureDetector(
        onTap:
            !isGameActive && !isDisabled && !hasInsufficientPoints
                ? (showResult ? controller.restartGame : controller.startGame)
                : null,
        onTapDown:
            isGameActive && !isDisabled && !hasInsufficientPoints
                ? (_) => controller.onButtonPressed()
                : null,
        onTapUp:
            isGameActive && !isDisabled && !hasInsufficientPoints
                ? (_) => controller.onButtonReleased()
                : null,
        onTapCancel:
            isGameActive && !isDisabled && !hasInsufficientPoints
                ? () => controller.onButtonReleased()
                : null,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF64748B).withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Stack(
            children: [
              // 게임 콘텐츠 영역
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // 결과 메시지
                    _buildResultMessage(),

                    // 게임 영역
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF0EA5E9).withOpacity(0.1),
                              const Color(0xFF0284C7).withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF0EA5E9).withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            // 낚싯대 영역
                            Expanded(flex: 3, child: _buildFishingRod()),
                            const SizedBox(width: 20),

                            // 성공 게이지
                            _buildSuccessGauge(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 버튼 영역
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        gradient:
                            (isDisabled || hasInsufficientPoints)
                                ? LinearGradient(
                                  colors: [
                                    const Color(0xFF94A3B8),
                                    const Color(0xFF64748B),
                                  ],
                                )
                                : LinearGradient(
                                  colors: [
                                    const Color(0xFF3B82F6),
                                    const Color(0xFF1D4ED8),
                                  ],
                                ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (isDisabled || hasInsufficientPoints)
                                    ? const Color(0xFF64748B).withOpacity(0.2)
                                    : const Color(0xFF3B82F6).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                            spreadRadius: -2,
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
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
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
                    color: const Color(0xFF3B82F6).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(24),
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
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
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
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFBBF24).withOpacity(0.8),
                      const Color(0xFFF59E0B).withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD97706), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFBBF24).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
                          style: const TextStyle(fontSize: 24),
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
                    turns: isPressed ? -0.1 : 0.1,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF64748B).withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/lure.png',
                        width: playerBarHeight * 1.6,
                        height: playerBarHeight * 1.6,
                        fit: BoxFit.contain,
                      ),
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
      width: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        final gauge = controller.successGauge.value;

        // 게이지 수준에 따른 그라데이션 색상 결정
        List<Color> gaugeColors;
        if (gauge >= 0.8) {
          gaugeColors = [const Color(0xFF10B981), const Color(0xFF059669)];
        } else if (gauge >= 0.6) {
          gaugeColors = [const Color(0xFFF59E0B), const Color(0xFFD97706)];
        } else if (gauge >= 0.4) {
          gaugeColors = [const Color(0xFFEC4899), const Color(0xFFDB2777)];
        } else if (gauge >= 0.2) {
          gaugeColors = [const Color(0xFFEF4444), const Color(0xFFDC2626)];
        } else {
          gaugeColors = [const Color(0xFFEF4444), const Color(0xFFB91C1C)];
        }

        return Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFF1F5F9),
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
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: gaugeColors,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: gaugeColors[0].withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
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
