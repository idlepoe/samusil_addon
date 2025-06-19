import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../components/appBarAction.dart';
import '../../define/define.dart';
import '../left_drawer/left_drawer.dart';
import 'dash_board_controller.dart';
import 'widgets/index.dart';

class DashBoardView extends GetView<DashBoardController> {
  const DashBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
        iconTheme: const IconThemeData(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        elevation: 0,
        title: Text(
          "app_name".tr,
          style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        ),
        centerTitle: true,
        actions: AppBarAction(context, controller.profile.value),
      ),
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          header: ClassicHeader(
            idleText: "header_idle_text".tr,
            releaseText: "header_release_text".tr,
            refreshingText: "header_loading_text".tr,
            completeText: "header_complete_text".tr,
          ),
          enablePullDown: true,
          onRefresh: controller.onRefreshLite,
          footer: ClassicFooter(
            idleText: "footer_can_loading_text".tr,
            canLoadingText: "footer_can_loading_text".tr,
            loadingText: "footer_loading_text".tr,
          ),
          enablePullUp: false,
          onLoading: controller.onLoading,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CoinPriceScrollWidget(coinList: controller.coinList),
                Column(
                  children: [
                    const DateHeaderWidget(),
                    WishCardWidget(
                      controller: controller,
                      wishList: controller.wishList,
                      wishCount: controller.wishCount.value,
                    ),
                    GameNewsListWidget(
                      controller: controller,
                      gameList: controller.gameList,
                    ),
                    AllArticlesWidget(
                      controller: controller,
                      articleList: controller.articleList,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: WishInputBottomSheet(controller: controller),
      drawer: const LeftDrawer(),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width / 2,
    );
  }
}
