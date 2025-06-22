import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../define/define.dart';
import '../../../define/enum.dart';
import '../../../define/arrays.dart';
import '../../../models/article.dart';
import '../../../models/board_info.dart';
import '../../../models/profile.dart';
import '../../../utils/app.dart';
import '../../../main.dart';

enum SortType { latest, popular }

class ArticleListController extends GetxController {
  // 상태 관리
  final Rx<Profile> profile = Profile.init().obs;
  final Rx<BoardInfo> boardInfo = BoardInfo.init().obs;
  final RxList<Article> articleList = <Article>[].obs;
  final RxInt listMaxLength = Define.DEFAULT_BOARD_PAGE_LENGTH.obs;
  final Rx<ViewType> viewType = ViewType.normal.obs;
  final RxBool isDataLoaded = false.obs;
  final Rx<SortType> currentSortType = SortType.latest.obs;

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

    // 데이터 로드 (한 번만 실행)
    if (!isDataLoaded.value) {
      loadData();
    }
  }

  @override
  void onReady() {
    super.onReady();
    // arguments에서 showWriteSheet 확인
    final arguments = Get.arguments;
    if (arguments != null && arguments['showWriteSheet'] == true) {
      // 약간의 지연 후 작성 bottom sheet 표시
      Future.delayed(const Duration(milliseconds: 500), () {
        navigateToEdit();
      });
    }
  }

  // 데이터 로드
  Future<void> loadData() async {
    if (boardInfo.value.board_name.isEmpty) {
      logger.e('boardInfo가 비어있습니다');
      return;
    }

    profile.value = await App.getProfile();
    final articles = await App.getArticleList(
      boardInfo: boardInfo.value,
      search: "",
      limit: Define.DEFAULT_BOARD_GET_LENGTH,
    );

    // 차단된 사용자의 게시글 필터링
    final filteredArticles = await _filterBlockedUsers(articles);
    articleList.value = filteredArticles;
    isDataLoaded.value = true;
  }

  // 차단된 사용자의 게시글 필터링
  Future<List<Article>> _filterBlockedUsers(List<Article> articles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final blockedUsers = prefs.getStringList('blocked_users') ?? [];

      return articles
          .where((article) => !blockedUsers.contains(article.profile_uid))
          .toList();
    } catch (e) {
      logger.e('차단된 사용자 필터링 중 오류: $e');
      return articles;
    }
  }

  // 정렬 타입 변경
  void changeSortType(SortType sortType) {
    currentSortType.value = sortType;
    _sortArticles();
  }

  // 게시글 정렬
  void _sortArticles() {
    final sortedList = List<Article>.from(articleList);

    switch (currentSortType.value) {
      case SortType.latest:
        sortedList.sort((a, b) => b.created_at.compareTo(a.created_at));
        break;
      case SortType.popular:
        // 7일 이내 게시글만 필터링하여 인기순 정렬
        final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
        final recentArticles =
            sortedList
                .where((article) => article.created_at.isAfter(sevenDaysAgo))
                .toList();

        recentArticles.sort((a, b) => b.count_like.compareTo(a.count_like));

        // 7일 이내 게시글을 앞으로, 나머지는 최신순으로 정렬
        final oldArticles =
            sortedList
                .where((article) => article.created_at.isBefore(sevenDaysAgo))
                .toList();
        oldArticles.sort((a, b) => b.created_at.compareTo(a.created_at));

        sortedList.clear();
        sortedList.addAll(recentArticles);
        sortedList.addAll(oldArticles);
        break;
    }

    articleList.value = sortedList;
  }

  // 정렬 타입 텍스트 가져오기
  String getSortTypeText(SortType sortType) {
    switch (sortType) {
      case SortType.latest:
        return '최신순';
      case SortType.popular:
        return '인기순(7일)';
    }
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
    Get.toNamed(
      "/list/${boardInfo.value.board_name}/edit",
      arguments: boardInfo.value,
    );
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
