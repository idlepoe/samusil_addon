import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/appBarAction.dart';
import '../../define/define.dart';
import '../../controllers/profile_controller.dart';
import '../../models/profile.dart';
import '../left_drawer/left_drawer.dart';
import 'dash_board_controller.dart';
import 'widgets/coin_price_scroll_widget.dart';
import 'widgets/date_wish_card_widget.dart';
import 'widgets/game_news_list_widget.dart';
import 'widgets/all_articles_widget.dart';

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
          "app_name".tr,
          style: const TextStyle(
            color: Color(0xFF191F28),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: AppBarAction(context, Profile.init()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 코인 가격 스크롤
            const CoinPriceScrollWidget(),
            const SizedBox(height: 20),

            // 오늘 날짜 헤더
            const DateWishCardWidget(),
            const SizedBox(height: 20),

            // 게임 뉴스 섹션
            GameNewsListWidget(controller: controller),
            const SizedBox(height: 20),

            // 전체 게시글 섹션
            AllArticlesWidget(controller: controller),
            const SizedBox(height: 20),
          ],
        ),
      ),
      drawer: const LeftDrawer(),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width / 2,
    );
  }
}
