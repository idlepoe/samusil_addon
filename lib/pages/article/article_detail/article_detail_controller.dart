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
      await App.articleCountViewUp(id: articleKey.value);
      article.value = await App.getArticle(id: articleKey.value);
      boardInfo.value = Arrays.getBoardInfo(article.value.board_name);
      profile.value = await App.getProfile();
      isAlreadyVote.value = await Utils.checkAlreadyVote(article.value.key);

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
      final commentList = await App.getComments(id: article.value.key);
      comments.value = commentList;
      _sortComments();
    } catch (e) {
      logger.e('댓글 로드 실패: $e');
      comments.clear();
    }
  }

  // 댓글 정렬
  void _sortComments() {
    comments.sort(
      (a, b) => (a.parents_key.isNotEmpty ? a.parents_key : a.key).compareTo(
        (b.parents_key.isNotEmpty ? b.parents_key : b.key),
      ),
    );
  }

  // 좋아요
  Future<void> likeArticle() async {
    if (isPressed.value || isAlreadyVote.value) return;

    isPressed.value = true;

    try {
      article.value = article.value.copyWith(
        count_like: await App.articleCountLikeUp(key: article.value.key),
      );

      await Utils.setAlreadyVote(article.value.key);
      isAlreadyVote.value = true;

      await App.pointUpdate(
        profileKey: article.value.profile_uid,
        point: Define.POINT_RECEIVE_LIKE,
      );
      await App.pointUpdate(
        profileKey: profile.value.uid,
        point: Define.POINT_LIKE,
      );

      Fluttertoast.showToast(msg: "success_article_like".tr);
    } catch (e) {
      logger.e('좋아요 실패: $e');
      Fluttertoast.showToast(msg: "error_article_like".tr);
    } finally {
      isPressed.value = false;
    }
  }

  // 싫어요
  Future<void> unlikeArticle() async {
    if (isPressed.value || isAlreadyVote.value) return;

    isPressed.value = true;

    try {
      article.value = article.value.copyWith(
        count_unlike: await App.articleCountUnLikeUp(key: article.value.key),
      );

      await Utils.setAlreadyVote(article.value.key);
      isAlreadyVote.value = true;

      Fluttertoast.showToast(msg: "success_article_unlike".tr);
    } catch (e) {
      logger.e('싫어요 실패: $e');
      Fluttertoast.showToast(msg: "error_article_unlike".tr);
    } finally {
      isPressed.value = false;
    }
  }

  // 댓글 작성
  Future<void> writeComment() async {
    if (commentController.text.isEmpty || isPressed.value) return;

    isPressed.value = true;

    try {
      MainComment comment = MainComment(
        key: Utils.getDateTimeKey(),
        contents: commentController.text,
        profile_uid: profile.value.uid,
        profile_name: profile.value.name,
        profile_photo_url: profile.value.photo_url,
        created_at: DateTime.now(),
        is_sub: false,
        parents_key: "",
      );

      List<MainComment> newComments = await App.createComment(
        article: article.value,
        comment: comment,
      );

      if (newComments.isNotEmpty) {
        comments.value = newComments;
        commentController.clear();
        commentFocusNode.unfocus();

        // 포인트 업데이트
        await App.pointUpdate(
          profileKey: profile.value.uid,
          point: Define.POINT_WRITE_COMMENT,
        );
      }
    } catch (e) {
      logger.e("댓글 작성 오류: $e");
    } finally {
      isPressed.value = false;
    }
  }

  // 댓글 삭제
  Future<void> deleteComment(MainComment comment) async {
    try {
      List<MainComment> afterList = await App.deleteComment(
        articleKey: article.value.key,
        comment: comment,
      );

      comments.value = afterList;
      _sortComments();

      article.value = article.value.copyWith(
        count_comments: article.value.count_comments - 1,
      );

      Fluttertoast.showToast(msg: "success_delete_comment".tr);
    } catch (e) {
      logger.e('댓글 삭제 실패: $e');
      Fluttertoast.showToast(msg: "error_delete_comment".tr);
    }
  }

  // 게시글 삭제
  Future<bool> deleteArticle() async {
    try {
      await App.deleteArticle(article: article.value);
      Fluttertoast.showToast(msg: "success_delete_article".tr);
      return true;
    } catch (e) {
      logger.e('게시글 삭제 실패: $e');
      Fluttertoast.showToast(msg: "error_delete_article".tr);
      return false;
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
      'https://nippon-life.web.app/#/detail/${article.value.key}',
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
