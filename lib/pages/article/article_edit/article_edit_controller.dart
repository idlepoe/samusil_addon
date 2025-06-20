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
    if (titleController.text.isEmpty) {
      Get.snackbar(
        '알림',
        '제목을 입력해주세요',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (isPressed.value) return;

    isPressed.value = true;

    try {
      Profile profile = await App.getProfile();
      String thumbnail = "";
      List<ArticleContent> updateContents = [];

      for (int i = 0; i < contentList.length; i++) {
        String contents = "";
        if (contentList[i].isPicture) {
          contents = await Utils.uploadImageToStorage(
            contentList[i].file,
            folder: 'articles',
            fileName:
                '${Utils.getDateTimeKey()}_${i}_${Utils.getRandomString(4)}.jpg',
          );
        } else {
          contents = contentList[i].textEditingController!.text;
          if (contents.isEmpty) continue;
        }

        ArticleContent target = ArticleContent(
          isPicture: contentList[i].isPicture,
          contents: contents,
        );
        updateContents.add(target);
      }

      Article article = Article(
        id: "",
        title: titleController.text,
        board_name: boardInfo.value.title,
        contents: updateContents,
        profile_uid: profile.uid,
        profile_name: profile.name,
        profile_photo_url: profile.photo_url,
        thumbnail: thumbnail,
        count_view: 0,
        count_like: 0,
        count_unlike: 0,
        count_comments: 0,
        created_at: DateTime.now(),
        is_notice: false,
      );

      await App.createArticle(article: article);
      await App.pointUpdate(
        profileKey: profile.uid,
        point: Define.POINT_WRITE_ARTICLE,
      );

      Fluttertoast.showToast(msg: "글이 성공적으로 작성되었습니다");

      Get.back();
    } catch (e) {
      logger.e('글쓰기 오류: $e');
      Get.snackbar(
        '오류',
        '글쓰기에 실패했습니다',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isPressed.value = false;
    }
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
