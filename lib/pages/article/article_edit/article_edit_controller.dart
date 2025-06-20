import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../define/define.dart';
import '../../../models/article.dart';
import '../../../models/article_contents.dart';
import '../../../models/board_info.dart';
import '../../../models/profile.dart';
import '../../../utils/app.dart';
import '../../../utils/util.dart';

class Contents {
  bool isPicture;
  String contents;
  ImageProvider<Object>? picture;
  XFile? file;
  TextEditingController? textEditingController;
  FocusNode? focusNode;

  Contents(
    this.isPicture,
    this.contents,
    this.picture,
    this.file,
    this.textEditingController,
    this.focusNode,
  );
}

class ArticleEditController extends GetxController {
  var logger = Logger();

  // 상태 관리
  final RxBool isPressed = false.obs;
  final Rx<BoardInfo> boardInfo = BoardInfo.init().obs;
  final RxList<Contents> contentList = <Contents>[].obs;

  // 컨트롤러들
  final TextEditingController titleController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  final String? articleKey;

  ArticleEditController({this.articleKey});

  @override
  void onInit() {
    super.onInit();

    final boardInfoArg = Get.arguments as BoardInfo?;

    if (boardInfoArg != null) {
      init(boardInfoArg);
    }

    if (articleKey != null) {
      // loadArticle(articleKey!);
    }
  }

  // 초기화
  void init(BoardInfo board) {
    boardInfo.value = board;
    contentList.clear();
    contentList.add(
      Contents(false, "", null, null, TextEditingController(), FocusNode()),
    );
  }

  // 텍스트 추가
  void addTextContent() {
    contentList.add(
      Contents(false, "", null, null, TextEditingController(), FocusNode()),
    );
  }

  // 이미지 추가
  Future<void> addImageContent() async {
    final pickedFileList = await picker.pickMultiImage();
    int index = 0;

    for (XFile pickedFile in pickedFileList) {
      if (pickedFileList.isNotEmpty) {
        ImageProvider<Object> image = await Utils.xFileToImage(pickedFile);
        logger.i(image);

        contentList.insert(
          index,
          Contents(
            true,
            "${Utils.getDateTimeKey()}.${pickedFile.path.split(".").last}",
            image,
            pickedFile,
            null,
            null,
          ),
        );
        index++;
      }
    }
  }

  // 콘텐츠 삭제
  void removeContent(int index) {
    contentList.removeAt(index);
  }

  // 콘텐츠 순서 변경
  void reorderContent(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    dynamic item = contentList.removeAt(oldIndex);
    contentList.insert(newIndex, item);
  }

  // 글쓰기
  Future<void> writeArticle() async {
  }

  @override
  void onClose() {
    titleController.dispose();
    for (var content in contentList) {
      content.textEditingController?.dispose();
      content.focusNode?.dispose();
    }
    super.onClose();
  }
}
