import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../define/arrays.dart';
import '../../define/define.dart';
import '../../define/enum.dart';
import '../../models/article.dart';
import '../../models/coin.dart';
import '../../models/profile.dart';
import '../../models/wish.dart';
import '../../utils/app.dart';
import '../../utils/util.dart';

class DashBoardController extends GetxController {
  var logger = Logger();

  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();

  final isCommentLoading = false.obs;
  final showInput = false.obs;

  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  final listMaxLength = Define.DEFAULT_BOARD_GET_LENGTH.obs;

  final profile = Profile.init().obs;
  final wishList = <Wish>[].obs;
  final wishCount = 0.obs;
  final articleList = <Article>[].obs;
  final gameList = <Article>[].obs;
  final coinList = <Coin>[].obs;

  ViewType viewType = ViewType.normal;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    if (kIsWeb) {
      logger.i(Uri.base.origin);
    }
    logger.i("DashBoardController init");

    profile.value = await App.checkUser();
    wishList.value = await App.getWishList();

    gameList.value = await App.getArticleList(
      Arrays.getBoardInfoByIndex(Define.INDEX_BOARD_GAME_NEWS_PAGE),
      "",
      Define.DEFAULT_DASH_BOARD_GET_LENGTH,
    );

    articleList.value = await App.getArticleList(
      Arrays.getBoardInfoByIndex(Define.INDEX_BOARD_ALL_PAGE),
      "",
      Define.DEFAULT_DASH_BOARD_GET_LENGTH,
    );

    await getExternalData();
  }

  Future<void> getExternalData() async {
    if (await App.isMaster()) {
      Timer.periodic(const Duration(minutes: 60), (timer) async {
        await App.getCoinPriceFromPaprika(Get.context!);
      });
    }
  }

  void onRefreshLite() async {
    logger.i("onRefreshLite");
    listMaxLength.value = Define.DEFAULT_BOARD_GET_LENGTH;

    gameList.value = await App.getArticleList(
      Arrays.getBoardInfoByIndex(Define.INDEX_BOARD_GAME_NEWS_PAGE),
      "",
      Define.DEFAULT_DASH_BOARD_GET_LENGTH,
    );

    articleList.value = await App.getArticleList(
      Arrays.getBoardInfoByIndex(Define.INDEX_BOARD_ALL_PAGE),
      "",
      Define.DEFAULT_DASH_BOARD_GET_LENGTH,
    );

    refreshController.refreshCompleted();
  }

  void onRefresh() async {
    logger.i("onRefresh");
    listMaxLength.value = Define.DEFAULT_BOARD_GET_LENGTH;
    await init();
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    logger.i("loading");
    listMaxLength.value =
        listMaxLength.value + Define.DEFAULT_BOARD_GET_LENGTH >
                articleList.length
            ? articleList.length
            : listMaxLength.value + Define.DEFAULT_BOARD_GET_LENGTH;

    await Future.delayed(const Duration(seconds: 1));
    refreshController.loadComplete();
  }

  Future<void> showKeyboardInput() async {
    bool alreadyWished = await Utils.getAlreadyWish();
    if (alreadyWished) {
      Get.snackbar('알림', 'already_wished'.tr);
      showInput.value = false;
      return;
    }

    logger.d("showKeyboardInput");
    logger.d(commentController.text.isEmpty);

    if (commentController.text.isEmpty) {
      showInput.value = !showInput.value;
      if (showInput.value) {
        commentFocusNode.requestFocus();
      }
    }
  }

  Future<void> createWish(String wish) async {
    if (wish.isEmpty || isCommentLoading.value) {
      return;
    }

    isCommentLoading.value = true;

    List<Wish> newWishList = await App.updateWish(profile.value, wish);
    wishList.value = newWishList;

    await Utils.setAlreadyWish(Utils.getStringToday());
    profile.value = profile.value.copyWith(
      wish_streak: profile.value.wish_streak + 1,
    );

    Get.snackbar('성공', 'success_create_wish'.tr);

    profile.value = await App.checkUser();
    isCommentLoading.value = false;
    commentController.text = "";
    showInput.value = false;
  }

  Future<void> articleCountViewUp(String articleKey) async {
    await App.articleCountViewUp(articleKey);
  }
}
