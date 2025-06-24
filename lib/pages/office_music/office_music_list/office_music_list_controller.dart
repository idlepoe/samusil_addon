import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/track_article.dart';
import '../../../utils/http_service.dart';
import '../../../components/appSnackbar.dart';

enum SortType { latest, viewCount, popular }

class OfficeMusicListController extends GetxController {
  final trackArticles = <TrackArticle>[].obs;
  final isLoading = false.obs;
  final hasMore = true.obs;
  final currentSortType = SortType.latest.obs;
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

      final response = await HttpService().getTrackArticleList(
        lastDocumentId: lastDocumentId,
        limit: 20,
        orderBy: 'created_at',
        orderDirection: 'desc',
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

        // 클라이언트 사이드에서 정렬 적용
        _sortTrackArticles();

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

  // 플레이리스트 정렬
  void _sortTrackArticles() {
    final sortedList = List<TrackArticle>.from(trackArticles);

    switch (currentSortType.value) {
      case SortType.latest:
        sortedList.sort((a, b) => b.created_at.compareTo(a.created_at));
        break;
      case SortType.viewCount:
        // 7일 이내 플레이리스트만 필터링하여 조회순 정렬
        final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
        final recentPlaylists =
            sortedList
                .where((playlist) => playlist.created_at.isAfter(sevenDaysAgo))
                .toList();

        recentPlaylists.sort((a, b) => b.count_view.compareTo(a.count_view));

        // 7일 이내 플레이리스트를 앞으로, 나머지는 최신순으로 정렬
        final oldPlaylists =
            sortedList
                .where((playlist) => playlist.created_at.isBefore(sevenDaysAgo))
                .toList();
        oldPlaylists.sort((a, b) => b.created_at.compareTo(a.created_at));

        sortedList.clear();
        sortedList.addAll(recentPlaylists);
        sortedList.addAll(oldPlaylists);
        break;
      case SortType.popular:
        // 7일 이내 플레이리스트만 필터링하여 좋아요순 정렬
        final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
        final recentPlaylists =
            sortedList
                .where((playlist) => playlist.created_at.isAfter(sevenDaysAgo))
                .toList();

        recentPlaylists.sort((a, b) => b.count_like.compareTo(a.count_like));

        // 7일 이내 플레이리스트를 앞으로, 나머지는 최신순으로 정렬
        final oldPlaylists =
            sortedList
                .where((playlist) => playlist.created_at.isBefore(sevenDaysAgo))
                .toList();
        oldPlaylists.sort((a, b) => b.created_at.compareTo(a.created_at));

        sortedList.clear();
        sortedList.addAll(recentPlaylists);
        sortedList.addAll(oldPlaylists);
        break;
    }

    trackArticles.value = sortedList;
  }

  // 새로고침
  Future<void> onRefresh() async {
    await loadTrackArticles(isRefresh: true);
  }

  // 정렬 타입 변경
  void changeSortType(SortType sortType) {
    currentSortType.value = sortType;
    _sortTrackArticles();
  }

  // 정렬 타입 텍스트 가져오기
  String getSortTypeText(SortType sortType) {
    switch (sortType) {
      case SortType.latest:
        return '최신순';
      case SortType.viewCount:
        return '조회순(7일)';
      case SortType.popular:
        return '좋아요순(7일)';
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
