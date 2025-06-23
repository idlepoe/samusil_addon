import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../models/youtube/track.dart';
import '../../../utils/http_service.dart';
import '../../../components/appSnackbar.dart';

class YouTubeSearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxList<Track> searchResults = <Track>[].obs;
  final RxList<Track> selectedTracks = <Track>[].obs;
  final RxBool isLoading = false.obs;
  final RxString currentSearchQuery = ''.obs;

  // 캐시 키 접두사
  static const String _cachePrefix = 'youtube_search_cache_';
  static const String _cacheKeysKey = 'youtube_search_cache_keys';

  @override
  void onInit() {
    super.onInit();
    // 기존에 선택된 트랙이 있다면 받아오기
    final arguments = Get.arguments;
    if (arguments != null && arguments['selectedTracks'] != null) {
      selectedTracks.value = List<Track>.from(arguments['selectedTracks']);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // YouTube 검색 (캐시 우선)
  Future<void> searchYouTube(String query) async {
    if (query.trim().isEmpty) {
      AppSnackbar.warning('검색어를 입력해주세요.');
      return;
    }

    currentSearchQuery.value = query.trim();
    isLoading.value = true;

    try {
      // 캐시된 결과 먼저 확인
      final cachedResults = await _getCachedResults(query.trim());
      if (cachedResults.isNotEmpty) {
        searchResults.value = cachedResults;
        isLoading.value = false;
        AppSnackbar.info('캐시된 검색 결과를 표시합니다.');
        return;
      }

      // 캐시가 없으면 API 호출
      final results = await HttpService.youtubeSearch(search: query.trim());
      if (results.isNotEmpty) {
        // 검색 결과를 Track 모델로 변환
        final tracks =
            results
                .map(
                  (sessionTrack) => Track(
                    id: sessionTrack.id,
                    videoId: sessionTrack.videoId,
                    title: sessionTrack.title,
                    description: sessionTrack.description,
                    thumbnail: sessionTrack.thumbnail,
                    duration: sessionTrack.duration,
                  ),
                )
                .toList();

        searchResults.value = tracks;

        // 결과를 캐시에 저장
        await _cacheResults(query.trim(), tracks);

        AppSnackbar.success('${tracks.length}개의 검색 결과를 찾았습니다.');
      } else {
        searchResults.clear();
        AppSnackbar.info('검색 결과가 없습니다.');
      }
    } catch (e) {
      AppSnackbar.error('검색 중 오류가 발생했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  // 트랙 선택/해제 토글
  void toggleTrackSelection(Track track) {
    final index = selectedTracks.indexWhere((t) => t.videoId == track.videoId);
    if (index >= 0) {
      selectedTracks.removeAt(index);
    } else {
      selectedTracks.add(track);
    }
  }

  // 트랙이 선택되었는지 확인
  bool isTrackSelected(Track track) {
    return selectedTracks.any((t) => t.videoId == track.videoId);
  }

  // 선택된 트랙들을 이전 화면으로 전달
  Future<void> confirmSelection() async {
    if (selectedTracks.isEmpty) {
      AppSnackbar.warning('선택된 음악이 없습니다.');
      return;
    }

    // 로딩 상태 표시
    isLoading.value = true;

    try {
      // 선택된 각 트랙의 실제 duration 가져오기
      final List<Track> tracksWithDuration = [];

      for (final track in selectedTracks) {
        final duration = await HttpService.getYoutubeLength(
          videoId: track.videoId,
        );

        // duration을 가져왔으면 업데이트, 실패하면 기본값 180초(3분) 사용
        final updatedTrack = track.copyWith(duration: duration ?? 180);

        tracksWithDuration.add(updatedTrack);
      }

      // 완료된 트랙들을 전달
      Get.back(result: tracksWithDuration);
    } catch (e) {
      AppSnackbar.error('음악 정보를 가져오는 중 오류가 발생했습니다.');
      // 에러가 발생해도 기본 duration으로 진행
      final tracksWithDefaultDuration =
          selectedTracks.map((track) => track.copyWith(duration: 180)).toList();
      Get.back(result: tracksWithDefaultDuration);
    } finally {
      isLoading.value = false;
    }
  }

  // 캐시에서 검색 결과 가져오기
  Future<List<Track>> _getCachedResults(String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _cachePrefix + query;
      final cachedJson = prefs.getString(cacheKey);

      if (cachedJson != null) {
        final cachedData = json.decode(cachedJson);
        final cacheTime = DateTime.parse(cachedData['timestamp']);

        // 캐시가 24시간 이내인지 확인
        if (DateTime.now().difference(cacheTime).inHours < 24) {
          final List<dynamic> tracksJson = cachedData['tracks'];
          return tracksJson.map((json) => Track.fromJson(json)).toList();
        } else {
          // 만료된 캐시 삭제
          await _removeCachedResults(query);
        }
      }
    } catch (e) {
      print('캐시 로드 실패: $e');
    }

    return [];
  }

  // 검색 결과를 캐시에 저장
  Future<void> _cacheResults(String query, List<Track> tracks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _cachePrefix + query;

      final cacheData = {
        'timestamp': DateTime.now().toIso8601String(),
        'tracks': tracks.map((track) => track.toJson()).toList(),
      };

      await prefs.setString(cacheKey, json.encode(cacheData));

      // 캐시 키 목록에 추가
      final cacheKeys = prefs.getStringList(_cacheKeysKey) ?? [];
      if (!cacheKeys.contains(query)) {
        cacheKeys.add(query);
        await prefs.setStringList(_cacheKeysKey, cacheKeys);
      }
    } catch (e) {
      print('캐시 저장 실패: $e');
    }
  }

  // 만료된 캐시 삭제
  Future<void> _removeCachedResults(String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _cachePrefix + query;

      await prefs.remove(cacheKey);

      // 캐시 키 목록에서도 제거
      final cacheKeys = prefs.getStringList(_cacheKeysKey) ?? [];
      cacheKeys.remove(query);
      await prefs.setStringList(_cacheKeysKey, cacheKeys);
    } catch (e) {
      print('캐시 삭제 실패: $e');
    }
  }

  // 전체 캐시 정리 (선택적으로 사용)
  Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKeys = prefs.getStringList(_cacheKeysKey) ?? [];

      for (final query in cacheKeys) {
        await prefs.remove(_cachePrefix + query);
      }

      await prefs.remove(_cacheKeysKey);
      AppSnackbar.success('캐시가 모두 삭제되었습니다.');
    } catch (e) {
      AppSnackbar.error('캐시 삭제 중 오류가 발생했습니다.');
    }
  }
}
