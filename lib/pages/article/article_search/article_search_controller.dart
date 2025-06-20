import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../define/define.dart';
import '../../../models/article.dart';
import '../../../models/board_info.dart';
import '../../../models/article_contents.dart';
import '../../../utils/app.dart';
import '../../../utils/util.dart';
import '../../../define/arrays.dart';

class ArticleSearchController extends GetxController {
  var logger = Logger();

  final Rx<BoardInfo> boardInfo = BoardInfo.init().obs;
  final RxList<Article> list = <Article>[].obs;
  final TextEditingController searchTextFieldController =
      TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    final boardName = Get.parameters['boardName'] ?? '';
    if (boardName.isNotEmpty) {
      boardInfo.value = Arrays.getBoardInfo(boardName);
    }
    getArticleList();
  }

  Future<void> getArticleList() async {
    list.value = await App.getArticleList(
      boardInfo: boardInfo.value,
      search: searchTextFieldController.text,
      limit: Define.DEFAULT_BOARD_GET_LENGTH,
    );
  }

  @override
  void onClose() {
    searchTextFieldController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
