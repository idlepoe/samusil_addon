import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../define/arrays.dart';
import '../../define/define.dart';
import '../../define/enum.dart';
import '../../models/article.dart';
import '../../models/coin.dart';
import '../../models/price.dart';
import '../../models/profile.dart';
import '../../utils/app.dart';
import '../../utils/util.dart';
import '../wish/wish_controller.dart';
import '../../main.dart';

class DashBoardController extends GetxController {
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();

  final isCommentLoading = false.obs;
  final showInput = false.obs;

  final listMaxLength = Define.DEFAULT_BOARD_GET_LENGTH.obs;

  final profile = Profile.init().obs;

  ViewType viewType = ViewType.normal;

  @override
  void onInit() {
    super.onInit();

    // WishController 바인딩
    if (!Get.isRegistered<WishController>()) {
      Get.put(WishController());
    }

    init();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> init() async {
    if (kIsWeb) {
      logger.i(Uri.base.origin);
    }

    profile.value = await App.getProfile();
  }

  void onRefreshLite() async {
    listMaxLength.value = Define.DEFAULT_BOARD_GET_LENGTH;
  }

  void onRefresh() async {
    listMaxLength.value = Define.DEFAULT_BOARD_GET_LENGTH;
    await init();
  }

  void onLoading() async {
    listMaxLength.value = listMaxLength.value + Define.DEFAULT_BOARD_GET_LENGTH;

    await Future.delayed(const Duration(seconds: 1));
  }
}
