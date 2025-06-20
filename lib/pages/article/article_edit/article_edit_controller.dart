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
  final RxBool isReorderMode = false.obs;
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
    final newContent = Contents(
      false,
      "",
      null,
      null,
      TextEditingController(),
      FocusNode(),
    );
    contentList.add(newContent);

    // 새로 추가된 텍스트 컴포넌트에 포커스 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      newContent.focusNode?.requestFocus();
    });
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

  // 순서 변경 모드 토글
  void toggleReorderMode() {
    isReorderMode.value = !isReorderMode.value;
  }

  // 글쓰기
  Future<void> writeArticle() async {
    try {
      isPressed.value = true;

      // 제목과 본문 텍스트 추출
      String title = titleController.text.trim();
      String firstTextContent = "";

      // 첫 번째 텍스트 콘텐츠 찾기
      for (var content in contentList) {
        if (!content.isPicture && content.textEditingController != null) {
          String text = content.textEditingController!.text.trim();
          if (text.isNotEmpty &&
              text.replaceAll(RegExp(r'\s+'), '').isNotEmpty) {
            firstTextContent = text;
            break;
          }
        }
      }

      // 제목이 없고 본문 텍스트도 없는 경우
      if (title.isEmpty && firstTextContent.isEmpty) {
        Get.snackbar(
          '알림',
          '텍스트를 입력해주세요.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      // 제목이 없으면 본문 텍스트를 제목으로 사용 (최대 15자)
      if (title.isEmpty && firstTextContent.isNotEmpty) {
        title =
            firstTextContent.length > 15
                ? "${firstTextContent.substring(0, 15)}..."
                : firstTextContent;
      }

      // 이미지 업로드 처리
      List<ArticleContent> processedContents = [];
      for (var content in contentList) {
        if (content.isPicture && content.file != null) {
          // 이미지 파일을 Storage에 업로드
          String imageUrl = await Utils.uploadImageToStorage(
            content.file,
            fileName: content.contents,
          );

          if (imageUrl.isNotEmpty) {
            processedContents.add(
              ArticleContent(isPicture: true, contents: imageUrl),
            );
          }
        } else if (!content.isPicture &&
            content.textEditingController != null) {
          String text = content.textEditingController!.text.trim();
          if (text.isNotEmpty &&
              text.replaceAll(RegExp(r'\s+'), '').isNotEmpty) {
            processedContents.add(
              ArticleContent(isPicture: false, contents: text),
            );
          }
        }
      }

      // 최소 하나의 콘텐츠가 있는지 확인
      if (processedContents.isEmpty) {
        Get.snackbar(
          '알림',
          '텍스트를 입력해주세요.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      // 프로필 정보 가져오기
      Profile profile = await App.getProfile();

      // Article 객체 생성
      Article article = Article(
        id: "",
        board_name: boardInfo.value.board_name,
        profile_uid: profile.uid,
        profile_name: profile.name,
        profile_photo_url: profile.profile_image_url,
        count_view: 0,
        count_like: 0,
        count_unlike: 0,
        count_comments: 0,
        title: title,
        contents: processedContents,
        created_at: DateTime.now().toUtc(),
        is_notice: false,
      );

      // 게시글 작성
      await App.createArticle(article: article);

      // 성공 시 이전 화면으로 이동
      Get.back();
    } catch (e) {
      logger.e("writeArticle error: $e");
      Get.snackbar(
        '오류',
        '게시글 작성 중 오류가 발생했습니다.',
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
