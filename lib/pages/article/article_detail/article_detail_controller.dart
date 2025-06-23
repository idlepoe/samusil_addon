import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../components/appSnackbar.dart';
import '../../../define/arrays.dart';
import '../../../define/define.dart';
import '../../../models/article.dart';
import '../../../models/board_info.dart';
import '../../../models/main_comment.dart';
import '../../../models/profile.dart';
import '../../../utils/app.dart';
import '../../../utils/http_service.dart';
import '../../../utils/util.dart';

class ArticleDetailController extends GetxController {
  var logger = Logger();

  // 상태 관리
  final RxString articleId = "".obs;
  final Rx<BoardInfo> boardInfo = BoardInfo.init().obs;
  final Rx<Article> article =
      Article(
        id: "",
        board_name: "",
        profile_uid: "",
        profile_name: "",
        profile_photo_url: "",
        count_view: 0,
        count_like: 0,
        count_unlike: 0,
        count_comments: 0,
        title: "",
        contents: [],
        created_at: DateTime.now(),
        is_notice: false,
      ).obs;
  final Rx<Profile> profile = Profile.init().obs;
  final RxList<MainComment> comments = <MainComment>[].obs;
  final RxBool isAlreadyVote = false.obs;
  final RxBool isPressed = false.obs;
  final RxBool isLoading = true.obs;
  final RxBool isLiked = false.obs;
  final Rx<MainComment?> subComment = Rx<MainComment?>(null);
  final RxBool isCommentEmpty = true.obs;
  final RxBool isDataLoaded = false.obs;
  final RxBool isCommentLoading = false.obs;

  // 컨트롤러들
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();

  // 라우트 파라미터에서 id 받기
  String get articleIdFromRoute => Get.parameters['id'] ?? '';

  @override
  void onInit() {
    super.onInit();
    // 라우트 파라미터에서 articleId 설정
    articleId.value = articleIdFromRoute;

    // 댓글 텍스트 변경 감지
    commentController.addListener(() {
      isCommentEmpty.value = commentController.text.trim().isEmpty;
    });

    // 데이터 로드 (한 번만 실행)
    if (!isDataLoaded.value) {
      loadData();
    }
  }

  @override
  void onReady() {
    super.onReady();
    // onReady에서는 추가 작업 없음 (데이터는 onInit에서 로드)
  }

  // 데이터 로드
  Future<void> loadData() async {
    if (articleId.value.isEmpty) {
      logger.e('articleId가 비어있습니다');
      return;
    }

    try {
      article.value = await App.getArticle(id: articleId.value);
      boardInfo.value = Arrays.getBoardInfo(article.value.board_name);
      profile.value = await App.getProfile();
      isAlreadyVote.value = await Utils.checkAlreadyVote(article.value.id);

      // 댓글은 article.value.comments에서 가져옴
      final commentList = article.value.comments ?? [];
      comments.value = List.from(commentList);
      _sortComments();

      // 좋아요 상태 확인
      await checkLikeStatus();

      isLoading.value = false;
      isDataLoaded.value = true;
    } catch (e) {
      logger.e('데이터 로드 실패: $e');
      isLoading.value = false;
    }
  }

  // 좋아요
  Future<void> likeArticle() async {
    try {
      int newLikeCount = await App.articleCountLikeUp(id: article.value.id);
      article.value = article.value.copyWith(count_like: newLikeCount);
    } catch (e) {
      logger.e(e);
    }
  }

  // 싫어요
  Future<void> unlikeArticle() async {
    try {
      int newUnlikeCount = await App.articleCountUnLikeUp(id: article.value.id);
      article.value = article.value.copyWith(count_unlike: newUnlikeCount);
    } catch (e) {
      logger.e(e);
    }
  }

  // 댓글 작성
  Future<void> createComment() async {
    if (commentController.text.trim().isEmpty) {
      AppSnackbar.warning('댓글 내용을 입력해주세요.');
      return;
    }

    // 이미 로딩 중이면 중복 실행 방지
    if (isCommentLoading.value) return;

    try {
      isCommentLoading.value = true;

      // 대댓글 여부 확인
      final isSubComment = subComment.value != null;
      final parentsKey = isSubComment ? subComment.value!.id : "";

      MainComment comment = MainComment(
        id: "",
        contents: commentController.text.trim(),
        profile_uid: profile.value.uid,
        profile_name: profile.value.name,
        profile_photo_url: profile.value.photo_url,
        is_sub: isSubComment,
        parents_key: parentsKey,
      );

      List<MainComment> newComments = await App.createComment(
        article: article.value,
        comment: comment,
      );

      if (newComments.isNotEmpty) {
        comments.value = newComments;
        commentController.clear();
        commentFocusNode.unfocus();
        clearSubComment(); // 대댓글 상태 초기화
        AppSnackbar.success(isSubComment ? '답글이 작성되었습니다.' : '댓글이 작성되었습니다.');

        // 댓글 수 업데이트
        article.value = article.value.copyWith(
          count_comments: article.value.count_comments + 1,
        );
      } else {
        AppSnackbar.error(isSubComment ? '답글 작성에 실패했습니다.' : '댓글 작성에 실패했습니다.');
      }
    } catch (e) {
      logger.e(e);
      AppSnackbar.error('댓글 작성에 실패했습니다.');
    } finally {
      isCommentLoading.value = false;
    }
  }

  // 댓글 삭제
  Future<void> deleteComment(MainComment comment) async {
    try {
      List<MainComment> newComments = await App.deleteComment(
        articleId: articleId.value,
        comment: comment,
      );

      if (newComments.length < comments.length) {
        comments.value = newComments;
        AppSnackbar.success('댓글이 삭제되었습니다.');
      } else {
        AppSnackbar.error('댓글 삭제에 실패했습니다.');
      }
    } catch (e) {
      logger.e(e);
      AppSnackbar.error('댓글 삭제 중 오류가 발생했습니다.');
    }
  }

  // 게시글 삭제
  Future<void> deleteArticle() async {
    try {
      bool success = await App.deleteArticle(article: article.value);
      if (success) {
        AppSnackbar.success('게시글이 삭제되었습니다.');
        Get.back();
      } else {
        AppSnackbar.error('게시글 삭제에 실패했습니다.');
      }
    } catch (e) {
      logger.e(e);
      AppSnackbar.error('게시글 삭제 중 오류가 발생했습니다.');
    }
  }

  // 이미지 저장
  Future<void> saveImage(String imageUrl) async {
    try {
      bool result = await Utils.saveNetworkImage([imageUrl]);
      if (result) {
        Fluttertoast.showToast(msg: "success_image_save".tr);
      } else {
        Fluttertoast.showToast(msg: "error_image_save".tr);
      }
    } catch (e) {
      logger.e('이미지 저장 실패: $e');
      Fluttertoast.showToast(msg: "error_image_save".tr);
    }
  }

  // 답글 설정
  void setSubComment(MainComment? comment) {
    subComment.value = comment;
    if (comment != null) {
      commentFocusNode.requestFocus();
    }
  }

  // 답글 취소
  void clearSubComment() {
    subComment.value = null;
  }

  // 이모티콘 추가
  void addEmojiToComment(String emoji) {
    final currentText = commentController.text;
    final selection = commentController.selection;

    // 선택 영역이 유효하지 않거나 텍스트가 없을 때 처리
    if (!selection.isValid || selection.start < 0) {
      // 텍스트 끝에 이모티콘 추가
      commentController.text = currentText + emoji;
      commentController.selection = TextSelection.collapsed(
        offset: currentText.length + emoji.length,
      );
    } else {
      // 기존 로직: 선택된 영역을 이모티콘으로 교체
      final newText = currentText.replaceRange(
        selection.start,
        selection.end,
        emoji,
      );
      commentController.text = newText;
      commentController.selection = TextSelection.collapsed(
        offset: selection.start + emoji.length,
      );
    }

    commentFocusNode.requestFocus();
  }

  // 게시글 작성자 여부
  bool get isAuthor => article.value.profile_uid == profile.value.uid;

  // 마스터 사용자 여부
  bool get isMaster => profile.value.uid == '00000000000000000';

  // 삭제 가능 여부
  bool get canDelete => isAuthor || isMaster;

  // 댓글 작성자 여부
  bool isCommentAuthor(MainComment comment) =>
      comment.profile_uid == profile.value.uid;

  // 댓글 삭제 가능 여부
  bool canDeleteComment(MainComment comment) {
    return isCommentAuthor(comment) || isMaster;
  }

  // 이미지 개수
  int get imageCount {
    return article.value.contents.where((content) => content.isPicture).length;
  }

  @override
  void onClose() {
    commentController.dispose();
    commentFocusNode.dispose();
    super.onClose();
  }

  void editArticle() {}

  void _sortComments() {
    final sortedComments = List<MainComment>.from(comments);
    sortedComments.sort(
      (a, b) => (a.parents_key.isNotEmpty ? a.parents_key : a.id).compareTo(
        (b.parents_key.isNotEmpty ? b.parents_key : b.id),
      ),
    );
    comments.value = sortedComments;
  }

  // 좋아요 토글 (낙관적 업데이트)
  Future<void> toggleLike() async {
    // 현재 상태 백업 (롤백용)
    final originalIsLiked = isLiked.value;
    final originalLikeCount = article.value.count_like;

    // 즉시 UI 업데이트 (낙관적 업데이트)
    final newIsLiked = !originalIsLiked;
    final newLikeCount =
        newIsLiked ? originalLikeCount + 1 : originalLikeCount - 1;

    isLiked.value = newIsLiked;
    article.value = article.value.copyWith(count_like: newLikeCount);

    // 즉시 성공 메시지 표시
    if (newIsLiked) {
      AppSnackbar.success('좋아요를 눌렀습니다.');
    } else {
      AppSnackbar.info('좋아요를 취소했습니다.');
    }

    try {
      // 백그라운드에서 서버 처리
      final response = await HttpService().toggleLike(
        articleId: article.value.id,
      );

      if (response.success && response.data != null) {
        final data = response.data;
        final serverIsLiked = data['isLiked'] as bool;
        final serverCountLike = data['countLike'] as int;

        // 서버 응답이 예상과 다른 경우 서버 데이터로 동기화
        if (serverIsLiked != newIsLiked || serverCountLike != newLikeCount) {
          isLiked.value = serverIsLiked;
          article.value = article.value.copyWith(count_like: serverCountLike);
        }
      } else {
        // 서버 오류 시 원래 상태로 롤백
        isLiked.value = originalIsLiked;
        article.value = article.value.copyWith(count_like: originalLikeCount);
        AppSnackbar.error(response.error ?? '좋아요 처리에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      // 네트워크 오류 시 원래 상태로 롤백
      logger.e('좋아요 토글 실패: $e');
      isLiked.value = originalIsLiked;
      article.value = article.value.copyWith(count_like: originalLikeCount);
      AppSnackbar.error('네트워크 오류로 좋아요 처리에 실패했습니다. 다시 시도해주세요.');
    }
  }

  // 좋아요 상태 확인
  Future<void> checkLikeStatus() async {
    try {
      final db = FirebaseFirestore.instance;
      final likeRef = db
          .collection(Define.FIRESTORE_COLLECTION_ARTICLE)
          .doc(article.value.id)
          .collection('likes')
          .doc(profile.value.uid);

      final likeDoc = await likeRef.get();
      isLiked.value = likeDoc.exists;
    } catch (e) {
      logger.e('좋아요 상태 확인 실패: $e');
    }
  }
}
