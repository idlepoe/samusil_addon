import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../define/define.dart';
import '../../../define/enum.dart';
import '../../../define/arrays.dart';
import '../../../models/article.dart';
import '../../../models/board_info.dart';
import '../../../models/profile.dart';
import '../../../utils/app.dart';
import '../../../main.dart';

class ArticleListController extends GetxController {
  // 상태 관리
  final Rx<Profile> profile = Profile.init().obs;
  final Rx<BoardInfo> boardInfo = BoardInfo.init().obs;
  final RxList<Article> articleList = <Article>[].obs;
  final RxInt listMaxLength = Define.DEFAULT_BOARD_PAGE_LENGTH.obs;
  final Rx<ViewType> viewType = ViewType.normal.obs;

  // 라우트 파라미터에서 boardName 받기
  String get boardNameFromRoute => Get.parameters['boardName'] ?? '';

  @override
  void onInit() {
    super.onInit();
    // 라우트 파라미터에서 boardName으로 boardInfo 설정
    final boardName = boardNameFromRoute;
    if (boardName.isNotEmpty) {
      boardInfo.value = Arrays.getBoardInfo(boardName);
    }
  }

  @override
  void onReady() {
    super.onReady();
    // 페이지가 준비되면 데이터 로드
    loadData();
  }

  // 데이터 로드
  Future<void> loadData() async {
    if (boardInfo.value.board_name.isEmpty) {
      logger.e('boardInfo가 비어있습니다');
      return;
    }

    profile.value = await App.getProfile();
    articleList.value = await App.getArticleList(
      boardInfo: boardInfo.value,
      search: "",
      limit: Define.DEFAULT_BOARD_GET_LENGTH,
    );
  }

  // 새로고침
  Future<void> onRefresh() async {
    listMaxLength.value = Define.DEFAULT_BOARD_PAGE_LENGTH;
    await loadData();
  }

  // 추가 로딩
  Future<void> onLoading() async {
    listMaxLength.value =
        listMaxLength.value + Define.DEFAULT_BOARD_PAGE_LENGTH >
                articleList.length
            ? articleList.length
            : listMaxLength.value + Define.DEFAULT_BOARD_PAGE_LENGTH;
    await Future.delayed(const Duration(seconds: 1));
  }

  // 검색 페이지로 이동
  void navigateToSearch() {
    Get.toNamed("/list/${boardInfo.value.board_name}/search");
  }

  // 글쓰기 페이지로 이동
  void navigateToEdit() {
    Get.toNamed("/list/${boardInfo.value.board_name}/edit");
  }

  // 대시보드로 이동
  void navigateToDashboard() {
    Get.offAllNamed("/");
  }

  // 게시글 상세 페이지로 이동
  void goToDetail(Article article) {
    Get.toNamed('/detail/${article.id}');
  }

  // 현재 표시할 게시글 목록
  List<Article> get displayArticles {
    final length =
        listMaxLength.value > articleList.length
            ? articleList.length
            : listMaxLength.value;
    return articleList.take(length).toList();
  }

  // 게시글에 이미지가 있는지 확인
  bool hasPicture(Article article) {
    return article.contents.any((content) => content.isPicture);
  }

  // 게시글에 내용이 없는지 확인
  bool hasNoContents(Article article) {
    return article.contents.isEmpty;
  }

  // 게시글 작성 가능 여부
  bool get canWrite => boardInfo.value.isCanWrite;

  void goToEdit(Article article) {
    Get.toNamed('/edit/${article.id}');
  }
}
