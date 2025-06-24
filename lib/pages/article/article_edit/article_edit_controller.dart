import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../define/define.dart';
import '../../../define/arrays.dart';
import '../../../models/article.dart';
import '../../../models/article_contents.dart';
import '../../../models/board_info.dart';
import '../../../models/profile.dart';
import '../../../utils/app.dart';
import '../../../utils/util.dart';
import '../../../components/appSnackbar.dart';

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

  final String? articleId;

  ArticleEditController({this.articleId});

  // 라우트 파라미터에서 boardName 받기
  String get boardNameFromRoute => Get.parameters['boardName'] ?? '';

  @override
  void onInit() {
    super.onInit();

    // arguments로 전달된 boardInfo가 있으면 우선 사용
    final boardInfoArg = Get.arguments as BoardInfo?;
    if (boardInfoArg != null) {
      init(boardInfoArg);
      logger.d(
        "ArticleEditController boardInfoArg: ${boardInfoArg.board_name}",
      );

      // 글쓰기 권한 체크
      if (!boardInfoArg.isCanWrite) {
        Get.back();
        AppSnackbar.error('이 게시판에서는 글을 작성할 수 없습니다.');
        return;
      }
      return; // arguments가 있으면 라우트 파라미터는 무시
    }

    // 라우트 파라미터에서 boardName으로 boardInfo 설정
    final boardName = boardNameFromRoute;
    if (boardName.isNotEmpty) {
      final board = Arrays.getBoardInfo(boardName);
      init(board);
      logger.d(
        "ArticleEditController boardName: $boardName, boardInfo: ${board.board_name}",
      );

      // 글쓰기 권한 체크
      if (!board.isCanWrite) {
        Get.back();
        AppSnackbar.error('이 게시판에서는 글을 작성할 수 없습니다.');
        return;
      }
    }

    if (articleId != null) {
      // loadArticle(articleId!);
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

  // 게시글 작성/수정
  Future<void> writeArticle({Function()? onSuccess}) async {
    if (isPressed.value) return;

    try {
      isPressed.value = true;

      // 제목 처리
      String title = titleController.text.trim();
      if (title.isEmpty) {
        title = "제목 없음";
      }

      // 콘텐츠 처리
      List<ArticleContent> processedContents = [];
      for (var content in contentList) {
        if (content.isPicture) {
          if (content.file != null) {
            // 이미지 파일 업로드
            String imageUrl = await Utils.uploadImageToStorage(
              content.file,
              fileName: content.contents,
            );
            if (imageUrl.isNotEmpty) {
              processedContents.add(
                ArticleContent(isPicture: true, contents: imageUrl),
              );
            }
          } else if (content.contents.isNotEmpty) {
            // 이미 업로드된 이미지 URL
            processedContents.add(
              ArticleContent(isPicture: true, contents: content.contents),
            );
          }
        } else {
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
        AppSnackbar.warning('텍스트를 입력해주세요.');
        return;
      }

      // 프로필 정보 가져오기
      Profile profile = await App.getProfile();

      if (articleId != null) {
        // 게시글 수정
        Article article = Article(
          id: articleId!,
          board_name: boardInfo.value.board_name,
          profile_uid: profile.uid,
          profile_name: profile.name,
          profile_photo_url: profile.photo_url,
          count_view: 0,
          count_like: 0,
          count_unlike: 0,
          count_comments: 0,
          title: title,
          contents: processedContents,
          created_at: DateTime.now().toUtc(),
          is_notice: false,
        );

        logger.d("updateArticle board_name: ${boardInfo.value.board_name}");
        logger.d("updateArticle article: ${article.toJson()}");

        String? result = await App.updateArticle(article: article);
        if (result != null) {
          // 성공 시 콜백 호출 (콜백에서 Get.back() 처리)
          if (onSuccess != null) {
            onSuccess();
          } else {
            // 콜백이 없는 경우에만 직접 뒤로가기
            Get.back();
          }
          // 뒤로가기 처리 후 Snackbar 표시
          AppSnackbar.success('게시글이 수정되었습니다.');
          return; // 성공 시 여기서 함수 종료
        } else {
          AppSnackbar.error('게시글 수정에 실패했습니다.');
          return;
        }
      } else {
        // 새 게시글 작성
        Article article = Article(
          id: "",
          board_name: boardInfo.value.board_name,
          profile_uid: profile.uid,
          profile_name: profile.name,
          profile_photo_url: profile.photo_url,
          count_view: 0,
          count_like: 0,
          count_unlike: 0,
          count_comments: 0,
          title: title,
          contents: processedContents,
          created_at: DateTime.now().toUtc(),
          is_notice: false,
        );

        logger.d("writeArticle board_name: ${boardInfo.value.board_name}");
        logger.d("writeArticle article: ${article.toJson()}");

        String? result = await App.createArticle(article: article);
        if (result != null) {
          // 성공 시 콜백 호출 (콜백에서 Get.back() 처리)
          if (onSuccess != null) {
            onSuccess();
          } else {
            // 콜백이 없는 경우에만 직접 뒤로가기
            Get.back();
          }
          // 뒤로가기 처리 후 Snackbar 표시
          AppSnackbar.success('게시글이 작성되었습니다.');
          return; // 성공 시 여기서 함수 종료
        } else {
          AppSnackbar.error('게시글 작성에 실패했습니다.');
          return;
        }
      }
    } catch (e) {
      logger.e("writeArticle error: $e");
      AppSnackbar.error(
        articleId != null ? '게시글 수정 중 오류가 발생했습니다.' : '게시글 작성 중 오류가 발생했습니다.',
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
