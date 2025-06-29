import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/online_sutda_controller.dart';
import '../../models/online_sutda_game.dart';
import '../../models/sutda_card.dart';
import '../../components/profile_avatar_widget.dart';
import '../../controllers/profile_controller.dart';

class OnlineSutdaView extends GetView<OnlineSutdaController> {
  const OnlineSutdaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            controller.leaveGame();
            Get.back();
          },
        ),
        title: const Text(
          '온라인 2장 섯다',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isSearchingGame.value &&
            controller.currentGame.value == null) {
          return _buildSearchingView();
        }

        if (controller.currentGame.value == null) {
          return _buildStartView();
        }

        return _buildGameView();
      }),
    );
  }

  Widget _buildStartView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF2D5A3D),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(Icons.casino, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 30),
          const Text(
            '온라인 2장 섯다',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '다른 플레이어와 실시간으로 섯다를 즐겨보세요',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: controller.startSearchingGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              '게임 시작',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              color: Color(0xFF4CAF50),
              strokeWidth: 4,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            '게임을 찾는 중...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '다른 플레이어를 기다리고 있습니다',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 40),
          TextButton(
            onPressed: () {
              controller.leaveGame();
            },
            child: const Text(
              '취소',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameView() {
    final game = controller.currentGame.value!;

    return Column(
      children: [
        // 게임 상태 표시
        _buildGameStatusBar(game),

        // 메인 게임 영역
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // 상대방 영역
                _buildOpponentArea(game),

                const SizedBox(height: 8),

                // 중앙 팟 영역
                _buildPotArea(game),

                const SizedBox(height: 8),

                // 베팅 히스토리
                _buildBettingHistory(game),

                const Spacer(),

                // 내 카드 영역
                _buildMyCardArea(game),
              ],
            ),
          ),
        ),

        // 액션 버튼 영역
        _buildActionButtons(game),
      ],
    );
  }

  Widget _buildGameStatusBar(OnlineSutdaGame game) {
    String statusText = '';
    Color statusColor = Colors.white;

    switch (game.gameState) {
      case OnlineGameState.waiting:
        statusText = '플레이어 대기 중';
        statusColor = Colors.orange;
        break;
      case OnlineGameState.dealing:
        statusText = '카드 배분 중';
        statusColor = Colors.blue;
        break;
      case OnlineGameState.firstBetting:
        statusText = '1라운드 베팅';
        statusColor = controller.isMyTurn.value ? Colors.green : Colors.red;
        break;
      case OnlineGameState.secondDealing:
        statusText = '두 번째 카드 배분';
        statusColor = Colors.blue;
        break;
      case OnlineGameState.secondBetting:
        statusText = '2라운드 베팅';
        statusColor = controller.isMyTurn.value ? Colors.green : Colors.red;
        break;
      case OnlineGameState.showdown:
        statusText = '승부 결정';
        statusColor = Colors.purple;
        break;
      case OnlineGameState.finished:
        statusText = '게임 종료';
        statusColor = Colors.grey;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: const Color(0xFF2D5A3D),
      child: Column(
        children: [
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (controller.isMyTurn.value &&
              (game.gameState == OnlineGameState.firstBetting ||
                  game.gameState == OnlineGameState.secondBetting))
            Column(
              children: [
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    '내 턴 - ${controller.bettingTimeLeft.value}초',
                    style: TextStyle(
                      color:
                          controller.bettingTimeLeft.value <= 10
                              ? Colors.red
                              : Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildOpponentArea(OnlineSutdaGame game) {
    final opponent = game.players.firstWhere(
      (player) => player.playerId != ProfileController.to.uid,
      orElse: () => game.players.first,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D5A3D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 상대방 정보
          Row(
            children: [
              ProfileAvatarWidget(
                photoUrl: opponent.photoUrl,
                name: opponent.playerName,
                size: 28,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      opponent.playerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${opponent.points}P',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (opponent.hasFolded)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '포기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // 상대방 카드
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                opponent.cards.asMap().entries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    child: _buildCard(
                      entry.value,
                      showFront: controller.showOpponentCards.value,
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMyCardArea(OnlineSutdaGame game) {
    final myPlayer = game.players[controller.myPlayerIndex.value];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D5A3D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 내 정보
          Row(
            children: [
              ProfileAvatarWidget(
                photoUrl: ProfileController.to.profileImageUrl,
                name: ProfileController.to.userName,
                size: 28,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ProfileController.to.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Obx(
                      () => Text(
                        '${ProfileController.to.point}P',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 내 족보 표시
              if (myPlayer.cards.length == 2)
                _buildHandRankChip(myPlayer.cards),
            ],
          ),
          const SizedBox(height: 12),
          // 내 카드
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                myPlayer.cards.asMap().entries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    child: _buildCard(entry.value, showFront: true),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(SutdaCard card, {bool showFront = false}) {
    return Container(
      width: 60,
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                showFront
                    ? Image.asset(
                      SutdaGame.getCardImagePath(card),
                      width: 60,
                      height: 85,
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
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1E3A2F), Color(0xFF2D5A3D)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.casino,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
          ),
          // 월/광 정보 chip (앞면일 때만)
          if (showFront)
            Positioned(
              bottom: 2,
              left: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                decoration: BoxDecoration(
                  color:
                      card.type == 'gwang'
                          ? const Color(0xFFFFD700).withOpacity(0.9)
                          : const Color(0xFF191F28).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  card.type == 'gwang' ? '${card.month}광' : '${card.month}월',
                  style: TextStyle(
                    fontSize: 7,
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

  Widget _buildHandRankChip(List<SutdaCard> cards) {
    if (cards.length != 2) return const SizedBox.shrink();

    final hand = TwoCardSutdaHand.calculateHand(cards);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        hand.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPotArea(OnlineSutdaGame game) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D5A3D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
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
                Text(
                  '${game.pot}P',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBettingHistory(OnlineSutdaGame game) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D5A3D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '게임 진행',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: game.bettingHistory.length,
              itemBuilder: (context, index) {
                final reversedIndex = game.bettingHistory.length - 1 - index;
                final history = game.bettingHistory[reversedIndex];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Text(
                    history,
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(OnlineSutdaGame game) {
    if (!controller.isMyTurn.value ||
        (game.gameState != OnlineGameState.firstBetting &&
            game.gameState != OnlineGameState.secondBetting)) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF2D5A3D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 첫 번째 줄 버튼들
          Row(
            children: [
              // 체크
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      () => controller.makeBettingAction(BettingAction.check),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('체크'),
                ),
              ),
              const SizedBox(width: 8),
              // 콜
              if (game.currentBet > 0)
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        () => controller.makeBettingAction(BettingAction.call),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('콜 (${game.currentBet}P)'),
                  ),
                ),
              const SizedBox(width: 8),
              // 다이
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      () => controller.makeBettingAction(BettingAction.die),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('다이'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 두 번째 줄 버튼들
          Row(
            children: [
              // 삥
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      () => controller.makeBettingAction(BettingAction.ping),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('삥 (${game.baseBet}P)'),
                ),
              ),
              const SizedBox(width: 8),
              // 쿼터
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      () => controller.makeBettingAction(BettingAction.quarter),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('쿼터 (${(game.pot / 4).floor()}P)'),
                ),
              ),
              const SizedBox(width: 8),
              // 하프
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      () => controller.makeBettingAction(BettingAction.half),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('하프 (${(game.pot / 2).floor()}P)'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
