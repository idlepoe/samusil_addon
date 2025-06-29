import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/sutda_card.dart';
import '../../controllers/profile_controller.dart';
import '../../components/profile_avatar_widget.dart';
import 'sutda_game_controller.dart';
import 'dart:developer' as developer;

class SutdaGameView extends GetView<SutdaGameController> {
  const SutdaGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF191F28)),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            controller.gameState.value == GameState.ready
                ? '3장 섯다'
                : controller.gameState.value == GameState.firstBetting ||
                    controller.gameState.value == GameState.finalBetting
                ? '${controller.bettingTurn.value == BettingTurn.player ? "플레이어" : "AI"} 턴'
                : '3장 섯다',
            style: TextStyle(
              color:
                  controller.gameState.value == GameState.firstBetting ||
                          controller.gameState.value == GameState.finalBetting
                      ? (controller.bettingTurn.value == BettingTurn.player
                          ? Colors.green
                          : Colors.red)
                      : Color(0xFF191F28),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Color(0xFF191F28)),
            onPressed: () {
              _showGameGuide();
            },
          ),
        ],
      ),
      body: Center(
        child: Obx(() {
          if (controller.gameState.value == GameState.ready) {
            return _buildReadyScreen();
          }
          return _buildGameScreen();
        }),
      ),
    );
  }

  Widget _buildReadyScreen() {
    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF0064FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.casino, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 32),
          Text(
            '3장 섯다',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF191F28),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '• 각자 2장씩 받고 1장 공개\n• 첫 번째 베팅 라운드\n• 세 번째 카드 배분\n• 최종 베팅 후 승부\n\n참가비: 50P',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 48),
          Column(
            children: [
              Text(
                '현재 보유 포인트: ${ProfileController.to.point}P',
                style: TextStyle(
                  fontSize: 14,
                  color:
                      ProfileController.to.point >= controller.baseBet.value
                          ? Colors.green
                          : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    ProfileController.to.point >= controller.baseBet.value
                        ? () {
                          controller.startGame();
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0064FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '게임 시작 (${controller.baseBet.value}P)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameScreen() {
    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          // 게임 정보 헤더
          _buildGameInfo(),

          // 메인 게임 영역
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // AI 카드 영역
                            _buildAiCardArea(),
                            const SizedBox(height: 20),

                            // 중앙 팟 영역
                            _buildPotArea(),
                            const SizedBox(height: 20),

                            // 베팅 히스토리 영역
                            _buildBettingHistory(),
                            const SizedBox(height: 20),

                            // 플레이어 카드 영역
                            _buildPlayerCardArea(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 액션 버튼 영역
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildGameInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E8EB))),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '팟 머니',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  '${controller.pot.value}P',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191F28),
                  ),
                ),
              ],
            ),
            _buildGameStateInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameStateInfo() {
    return Obx(() {
      String stateText = '';
      Color stateColor = Colors.grey;

      switch (controller.gameState.value) {
        case GameState.dealing:
          stateText = '카드 배분 중';
          stateColor = Colors.blue;
          break;
        case GameState.selectingOpenCard:
          stateText = '카드 공개 선택';
          stateColor = Colors.orange;
          break;
        case GameState.firstBetting:
          stateText = '첫 번째 베팅';
          stateColor =
              controller.bettingTurn.value == BettingTurn.player
                  ? Colors.green
                  : Colors.red;
          break;
        case GameState.dealingThirdCard:
          stateText = '세 번째 카드 배분';
          stateColor = Colors.blue;
          break;
        case GameState.finalBetting:
          stateText = '최종 베팅';
          stateColor =
              controller.bettingTurn.value == BettingTurn.player
                  ? Colors.green
                  : Colors.red;
          break;
        case GameState.showdown:
          stateText = '승부 결정';
          stateColor = Colors.purple;
          break;
        default:
          return SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: stateColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: stateColor),
        ),
        child: Text(
          stateText,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: stateColor,
          ),
        ),
      );
    });
  }

  Widget _buildAiCardArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // AI 라벨과 족보
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.smart_toy,
                    color: Color(0xFFFF6B6B),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B6B),
                    ),
                  ),
                ],
              ),
              // AI 족보 칩
              Obx(
                () =>
                    controller.showAiCards.value &&
                            controller.aiHand.value != null
                        ? GestureDetector(
                          onTap: () => _showHandRankingsDialog(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFFF6B6B),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${controller.aiHand.value!.rank}위',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  controller.aiHand.value!.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // AI 카드들
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  controller.aiCards.asMap().entries.map((entry) {
                    bool isOpenCard =
                        entry.key == controller.aiOpenCardIndex.value;
                    bool showFront =
                        controller.showAiCards.value ||
                        (isOpenCard &&
                            controller.gameState.value != GameState.dealing);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildCard(
                        entry.value,
                        false,
                        showFront: showFront,
                        isOpenCard: isOpenCard,
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCardArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 플레이어 프로필 정보와 족보
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ProfileAvatarWidget(
                    photoUrl: ProfileController.to.profileImageUrl,
                    name: ProfileController.to.userName,
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ProfileController.to.userName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0064FF),
                        ),
                      ),
                      Obx(
                        () => Text(
                          '${ProfileController.to.point}P',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // 플레이어 족보 칩
              Obx(() {
                SutdaHand? hand = controller.playerHand.value;

                if (hand == null) return const SizedBox.shrink();

                return GestureDetector(
                  onTap: () => _showAllHandRankingsDialog(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0064FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${hand.rank}위',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hand.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          // 플레이어 카드들
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  controller.playerCards.asMap().entries.map((entry) {
                    bool isOpenCard =
                        entry.key == controller.playerOpenCardIndex.value;
                    bool canSelect =
                        controller.gameState.value ==
                            GameState.selectingOpenCard &&
                        controller.playerOpenCardIndex.value == -1;

                    return GestureDetector(
                      onTap:
                          canSelect
                              ? () => controller.selectCard(entry.key)
                              : null,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: _buildCard(
                          entry.value,
                          true,
                          showFront: true,
                          isOpenCard: isOpenCard,
                          canSelect: canSelect,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          // 카드 선택 안내
          Obx(() {
            if (controller.gameState.value == GameState.selectingOpenCard &&
                controller.playerOpenCardIndex.value == -1) {
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  '공개할 카드를 선택하세요',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildPotArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF0064FF),
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'POT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => Text(
                    '${controller.pot.value}P',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBettingHistory() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, size: 16, color: Color(0xFF8B95A1)),
              const SizedBox(width: 6),
              const Text(
                '게임 진행',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B95A1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 80,
            child: Obx(() {
              if (controller.bettingHistory.isEmpty) {
                return const Center(
                  child: Text(
                    '게임 진행 내역이 여기에 표시됩니다',
                    style: TextStyle(fontSize: 11, color: Color(0xFF8B95A1)),
                  ),
                );
              }

              return ListView.builder(
                reverse: true,
                itemCount: controller.bettingHistory.length,
                itemBuilder: (context, index) {
                  final reversedIndex =
                      controller.bettingHistory.length - 1 - index;
                  final history = controller.bettingHistory[reversedIndex];

                  bool isPlayerAction = history.startsWith('플레이어');
                  bool isAiAction = history.startsWith('AI');
                  bool isSystemMessage = !isPlayerAction && !isAiAction;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      history,
                      style: TextStyle(
                        fontSize: 10,
                        color:
                            isPlayerAction
                                ? const Color(0xFF0064FF)
                                : isAiAction
                                ? const Color(0xFFFF6B6B)
                                : const Color(0xFF8B95A1),
                        fontWeight:
                            isSystemMessage
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    SutdaCard card,
    bool isPlayer, {
    bool showFront = true,
    bool isOpenCard = false,
    bool canSelect = false,
  }) {
    return Container(
      width: 60,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color:
              isOpenCard
                  ? Colors.orange
                  : (canSelect
                      ? const Color(0xFF0064FF)
                      : const Color(0xFFE5E8EB)),
          width: isOpenCard || canSelect ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child:
                showFront
                    ? Image.asset(
                      SutdaGame.getCardImagePath(card),
                      width: 60,
                      height: 90,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${card.month}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF191F28),
                                  ),
                                ),
                                if (isPlayer ||
                                    isOpenCard ||
                                    (showFront && !isPlayer))
                                  Text(
                                    card.type == 'gwang' ? '광' : '피',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                    : Container(
                      color: Colors.grey.shade300,
                      child: Center(
                        child: Icon(
                          Icons.help_outline,
                          color: Colors.grey.shade600,
                          size: 24,
                        ),
                      ),
                    ),
          ),
          if (isOpenCard)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.visibility,
                  size: 8,
                  color: Colors.white,
                ),
              ),
            ),
          if (canSelect)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF0064FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.touch_app,
                  size: 8,
                  color: Colors.white,
                ),
              ),
            ),
          // 월/광 정보 chip (플레이어 카드는 항상, AI 카드는 공개된 경우에만)
          if (isPlayer ||
              (isOpenCard && !isPlayer) ||
              (showFront && !isPlayer && controller.showAiCards.value))
            Positioned(
              bottom: 2,
              left: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      card.type == 'gwang'
                          ? const Color(0xFFFFD700).withOpacity(0.9)
                          : const Color(0xFF191F28).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  card.type == 'gwang' ? '${card.month}광' : '${card.month}월',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: card.type == 'gwang' ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Obx(() {
      if (controller.gameState.value == GameState.firstBetting ||
          controller.gameState.value == GameState.finalBetting) {
        return _buildBettingButtons();
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildBettingButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E8EB))),
      ),
      child: Obx(() {
        if (controller.bettingTurn.value != BettingTurn.player) {
          return Container(
            height: 50,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI가 베팅 중입니다...',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          );
        }

        return Row(
          children: [
            // 다이
            Expanded(
              child: ElevatedButton(
                onPressed: controller.playerFold,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: const Color(0xFF191F28),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  '다이',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 체크/콜
            Expanded(
              child: ElevatedButton(
                onPressed: controller.playerCall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0064FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  controller.currentBet.value == 0 ? '체크' : '콜',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 따당
            Expanded(
              child: ElevatedButton(
                onPressed: controller.playerRaise,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B6B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  '따당 (+${controller.baseBet.value}P)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showGameGuide() {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '3장 섯다 게임 가이드',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '1. 각자 2장의 카드를 받습니다\n'
                '2. 2장 중 1장을 선택해 공개합니다\n'
                '3. 첫 번째 베팅 라운드 진행\n'
                '4. 세 번째 카드를 받습니다\n'
                '5. 최종 베팅 라운드 진행\n'
                '6. 3장 중 2장의 최고 조합으로 승부',
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('확인'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHandRankingsDialog() {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI의 족보 순위',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'AI의 족보는 ${controller.aiHand.value!.name}입니다.\n'
                '이 족보는 ${controller.aiHand.value!.rank}위입니다.',
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('확인'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAllHandRankingsDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: BoxConstraints(maxHeight: 600, maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 헤더
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0064FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.casino,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '섯다 족보표',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF191F28),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '높은 순서대로 정렬',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFF8B95A1),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 구분선
              Container(
                height: 1,
                color: const Color(0xFFF2F4F6),
                margin: const EdgeInsets.symmetric(horizontal: 24),
              ),

              // 족보 리스트
              Flexible(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: SutdaGame.handDescriptions.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      var handInfo = SutdaGame.handDescriptions[index];
                      bool isCurrentHand =
                          controller.playerHand.value?.name == handInfo['name'];

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              isCurrentHand
                                  ? const Color(0xFF0064FF).withOpacity(0.08)
                                  : const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isCurrentHand
                                    ? const Color(0xFF0064FF).withOpacity(0.3)
                                    : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            // 순위 뱃지
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color:
                                    isCurrentHand
                                        ? const Color(0xFF0064FF)
                                        : const Color(0xFF8B95A1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // 족보 정보
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        handInfo['name']!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              isCurrentHand
                                                  ? const Color(0xFF0064FF)
                                                  : const Color(0xFF191F28),
                                        ),
                                      ),
                                      if (isCurrentHand) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0064FF),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: const Text(
                                            '내 족보',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    handInfo['description']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
