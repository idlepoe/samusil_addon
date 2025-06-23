import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/appBarAction.dart';
import '../../define/define.dart';
import '../../controllers/profile_controller.dart';
import '../../models/profile.dart';
import '../left_drawer/left_drawer.dart';
import 'dash_board_controller.dart';
import 'widgets/race_status_widget.dart';
import 'widgets/date_wish_card_widget.dart';
import 'widgets/game_news_list_widget.dart';
import 'widgets/entertainment_news_list_widget.dart';
import 'widgets/all_articles_widget.dart';
import 'widgets/music_player_widget.dart';
import 'widgets/music_salon_widget.dart';
import 'widgets/favorite_playlists_widget.dart';

class DashBoardView extends GetView<DashBoardController> {
  const DashBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF191F28)),
        title: Text(
          "오피스 라운지",
          style: const TextStyle(
            color: Color(0xFF191F28),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: AppBarAction(context, Profile.init()),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // 게임뉴스, 연예뉴스, 자유게시판 데이터 새로고침
                await controller.refreshDashboard();
              },
              color: const Color(0xFF0064FF),
              backgroundColor: Colors.white,
              child: Obx(
                () => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    20,
                    16,
                    20,
                    // 음악 플레이어가 있을 때 하단 패딩 추가 (YouTube 플레이어 + 미니 플레이어)
                    controller.isPlayerVisible.value ? 320 : 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 코인 가격 스크롤
                      const RaceStatusWidget(),
                      const SizedBox(height: 20),

                      // 오늘 날짜 헤더
                      const DateWishCardWidget(),
                      const SizedBox(height: 20),

                      // 뮤직살롱 섹션
                      const MusicSalonWidget(),
                      const SizedBox(height: 20),

                      // 즐겨찾기 플레이리스트 섹션
                      FavoritePlaylistsWidget(controller: controller),
                      const SizedBox(height: 20),

                      // 게임 뉴스 섹션
                      GameNewsListWidget(controller: controller),
                      const SizedBox(height: 20),

                      // 연예 뉴스 섹션
                      EntertainmentNewsListWidget(controller: controller),
                      const SizedBox(height: 20),

                      // 전체 게시글 섹션
                      AllArticlesWidget(controller: controller),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 음악 플레이어
          const MusicPlayerWidget(),
        ],
      ),
      drawer: const LeftDrawer(),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width / 2,
    );
  }
}
