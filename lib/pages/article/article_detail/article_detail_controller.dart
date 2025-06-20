import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../../define/arrays.dart';
import '../../../define/define.dart';
import '../../../models/article.dart';
import '../../../models/board_info.dart';
import '../../../models/main_comment.dart';
import '../../../models/profile.dart';
import '../../../utils/app.dart';
import '../../../utils/util.dart';

class ArticleDetailController extends GetxController {
  var logger = Logger();

  // 상태 관리
  final RxString articleKey = "".obs;
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
  final Rx<MainComment?> subComment = Rx<MainComment?>(null);

  // 컨트롤러들
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();

  // 라우트 파라미터에서 articleId 받기
  String get articleIdFromRoute => Get.parameters['articleId'] ?? '';

  @override
  void onInit() {
    super.onInit();
    // 라우트 파라미터에서 articleId 설정
    articleKey.value = articleIdFromRoute;
  }

  @override
  void onReady() {
    super.onReady();
    // 페이지가 준비되면 데이터 로드
    loadData();
  }

  // 데이터 로드
  Future<void> loadData() async {
    if (articleKey.value.isEmpty) {
      logger.e('articleKey가 비어있습니다');
      return;
    }

    try {
      article.value = await App.getArticle(id: articleKey.value);
      boardInfo.value = Arrays.getBoardInfo(article.value.board_name);
      profile.value = await App.getProfile();
      isAlreadyVote.value = await Utils.checkAlreadyVote(article.value.id);

      await loadComments();

      isLoading.value = false;
    } catch (e) {
      logger.e('데이터 로드 실패: $e');
      isLoading.value = false;
    }
  }

  // 댓글 로드
  Future<void> loadComments() async {
    try {
      final commentList = await App.getComments(id: article.value.id);
      comments.value = commentList;
      _sortComments();
    } catch (e) {
      logger.e(e);
    }
  }

  // 댓글 정렬
  void _sortComments() {
    comments.sort(
      (a, b) => (a.parents_key.isNotEmpty ? a.parents_key : a.id).compareTo(
        (b.parents_key.isNotEmpty ? b.parents_key : b.id),
      ),
    );
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
      Get.snackbar(
        '알림',
        '댓글 내용을 입력해주세요.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      MainComment comment = MainComment(
        id: "",
        contents: commentController.text.trim(),
        profile_uid: profile.value.uid,
        profile_name: profile.value.name,
        profile_photo_url: profile.value.photo_url,
        created_at: DateTime.now(),
        is_sub: false,
        parents_key: "",
      );

      comments.value = await App.createComment(
        article: article.value,
        comment: comment,
      );

      commentController.clear();
      commentFocusNode.unfocus();

      // 댓글 수 업데이트
      article.value = article.value.copyWith(
        count_comments: article.value.count_comments + 1,
      );
    } catch (e) {
      logger.e(e);
    }
  }

  // 댓글 삭제
  Future<void> deleteComment(MainComment comment) async {
    try {
      comments.value = await App.deleteComment(
        articleId: articleKey.value,
        comment: comment,
      );
    } catch (e) {
      logger.e(e);
    }
  }

  // 게시글 삭제
  Future<void> deleteArticle() async {
    try {
      bool success = await App.deleteArticle(article: article.value);
      if (success) {
        Get.back();
      }
    } catch (e) {
      logger.e(e);
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

  // 공유
  void shareArticle() {
    Share.share(
      'https://nippon-life.web.app/#/detail/${article.value.id}',
      subject: article.value.title,
    );
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
}
