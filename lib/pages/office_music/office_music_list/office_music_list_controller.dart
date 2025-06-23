import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/track_article.dart';
import '../../../utils/http_service.dart';
import '../../../components/appSnackbar.dart';

enum FilterType {
  latest, // 최신순
  popularDay, // 인기순(하루)
  popularWeek, // 인기순(일주일)
  popularMonth, // 인기순(한달)
  popularAll, // 인기순(전체)
  likes, // 좋아요순
}

class OfficeMusicListController extends GetxController {
  final trackArticles = <TrackArticle>[].obs;
  final isLoading = false.obs;
  final hasMore = true.obs;
  final currentFilter = FilterType.latest.obs;
  String? lastDocumentId;

  @override
  void onInit() {
    super.onInit();
    loadTrackArticles();
  }

  Future<void> loadTrackArticles({bool isRefresh = false}) async {
    if (isLoading.value && !isRefresh) return;

    isLoading.value = true;

    try {
      // 새로고침인 경우 초기화
      if (isRefresh) {
        lastDocumentId = null;
        trackArticles.clear();
        hasMore.value = true;
      }

      // 필터에 따른 정렬 옵션 설정
      String orderBy;
      String orderDirection;

      switch (currentFilter.value) {
        case FilterType.latest:
          orderBy = 'created_at';
          orderDirection = 'desc';
          break;
        case FilterType.popularDay:
        case FilterType.popularWeek:
        case FilterType.popularMonth:
        case FilterType.popularAll:
          orderBy = 'count_view';
          orderDirection = 'desc';
          break;
        case FilterType.likes:
          orderBy = 'count_like';
          orderDirection = 'desc';
          break;
      }

      final response = await HttpService().getTrackArticleList(
        lastDocumentId: lastDocumentId,
        limit: 20,
        orderBy: orderBy,
        orderDirection: orderDirection,
      );

      if (response.success && response.data != null) {
        // onRequest 방식의 응답 구조에 맞게 수정
        final data = response.data;
        final List<dynamic> trackArticleList = data['trackArticles'] ?? [];

        // TrackArticle 객체로 변환
        final newTrackArticles =
            trackArticleList
                .map((json) => TrackArticle.fromJson(json))
                .toList();

        if (isRefresh) {
          trackArticles.value = newTrackArticles;
        } else {
          trackArticles.addAll(newTrackArticles);
        }

        // 페이지네이션 정보 업데이트
        hasMore.value = data['hasMore'] ?? false;
        lastDocumentId = data['lastDocumentId'];
      } else {
        if (!isRefresh) {
          AppSnackbar.error(response.error ?? '플레이리스트를 불러오는데 실패했습니다.');
        }
      }
    } catch (e) {
      if (!isRefresh) {
        AppSnackbar.error('플레이리스트를 불러오는데 실패했습니다.');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // 새로고침
  Future<void> onRefresh() async {
    await loadTrackArticles(isRefresh: true);
  }

  // 필터 변경
  Future<void> changeFilter(FilterType filter) async {
    if (currentFilter.value == filter) return;

    currentFilter.value = filter;
    await loadTrackArticles(isRefresh: true);
  }

  // 필터 이름 반환
  String getFilterName(FilterType filter) {
    switch (filter) {
      case FilterType.latest:
        return '최신순';
      case FilterType.popularDay:
        return '인기순(하루)';
      case FilterType.popularWeek:
        return '인기순(일주일)';
      case FilterType.popularMonth:
        return '인기순(한달)';
      case FilterType.popularAll:
        return '인기순(전체)';
      case FilterType.likes:
        return '좋아요순';
    }
  }

  // 더 불러오기
  Future<void> loadMore() async {
    if (hasMore.value && !isLoading.value) {
      await loadTrackArticles();
    }
  }

  // 플레이리스트 생성 페이지로 이동
  Future<void> goToCreatePlaylist() async {
    final result = await Get.toNamed('/office-music-edit');

    print('goToCreatePlaylist result: $result'); // 디버깅용 로그

    // 플레이리스트가 생성되었다면 목록 새로고침
    if (result != null && result is Map && result['refresh'] == true) {
      print('Refreshing playlist...'); // 디버깅용 로그
      await onRefresh();
    }
  }

  // 플레이리스트 상세 페이지로 이동
  void goToPlaylistDetail(TrackArticle trackArticle) {
    Get.toNamed('/track-article-detail', arguments: {'id': trackArticle.id});
  }

  // 총 재생시간 계산
  String getTotalDuration(TrackArticle trackArticle) {
    int totalSeconds = 0;
    for (var track in trackArticle.tracks) {
      totalSeconds += track.duration;
    }
    return formatDuration(totalSeconds);
  }

  // 재생시간 포맷팅
  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '${hours}시간 ${minutes}분';
    } else if (minutes > 0) {
      return '${minutes}분 ${remainingSeconds}초';
    } else {
      return '${remainingSeconds}초';
    }
  }
}
