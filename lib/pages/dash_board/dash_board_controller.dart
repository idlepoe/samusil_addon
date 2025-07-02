import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:simple_pip_mode/simple_pip.dart';

import '../../define/arrays.dart';
import '../../define/define.dart';
import '../../define/enum.dart';
import '../../models/article.dart';
import '../../models/price.dart';
import '../../models/track_article.dart';
import '../../models/youtube/track.dart';
import '../../utils/app.dart';
import '../../utils/http_service.dart';
import '../../utils/util.dart';
import '../../utils/pending_navigation_service.dart';
import '../wish/wish_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/horse_race_controller.dart';
import '../office_music/office_music_detail/office_music_detail_controller.dart';
import '../../main.dart';

class DashBoardController extends GetxController {
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();

  final isCommentLoading = false.obs;
  final showInput = false.obs;

  final listMaxLength = Define.DEFAULT_BOARD_GET_LENGTH.obs;

  // 게시글 데이터 관리
  final RxList<Article> allArticles = <Article>[].obs;
  final RxList<Article> gameNews = <Article>[].obs;
  final RxList<Article> entertainmentNews = <Article>[].obs;
  final RxBool isLoadingAllArticles = false.obs;
  final RxBool isLoadingGameNews = false.obs;
  final RxBool isLoadingEntertainmentNews = false.obs;

  // 뮤직살롱 데이터 관리
  final RxList<TrackArticle> musicSalonPlaylists = <TrackArticle>[].obs;
  final RxBool isLoadingMusicSalon = false.obs;

  // 즐겨찾기 플레이리스트 데이터 관리
  final RxList<TrackArticle> favoritePlaylists = <TrackArticle>[].obs;
  final RxBool isLoadingFavoritePlaylists = false.obs;

  // 음악 플레이어 관리
  YoutubePlayerController? _youtubeController;
  final isPlayerVisible = false.obs;
  final isPlaying = false.obs;
  final isPaused = false.obs;
  final currentTrackArticle = Rx<TrackArticle?>(null);
  final currentTrackIndex = 0.obs;
  final currentTrack = Rx<Track?>(null);
  final isPlayerInitialized = false.obs;
  final playerKey = 0.obs; // YouTube 플레이어 리렌더링을 위한 키

  // 재생 시간 관리
  final currentPosition = 0.0.obs; // 현재 재생 위치 (초)
  final totalDuration = 0.0.obs; // 총 재생 시간 (초)
  final progressPercentage = 0.0.obs; // 재생 진행률 (0.0 ~ 1.0)

  // 플레이어 상태 모니터링
  Timer? _playerMonitorTimer;

  // pip 관련
  final isPipModeActive = false.obs; // PiP 모드 활성 상태를 위한 observable
  SimplePip? _pip; // autoPipMode 관리용

  ViewType viewType = ViewType.normal;

  @override
  void onInit() {
    super.onInit();
    logger.i("DashBoardController onInit called");

    // pip 초기화
    _initPip();

    // 기본 YouTube 컨트롤러 생성 (빈 상태로 시작)
    _initializeDefaultYoutubeController();

    // WishController 바인딩
    if (!Get.isRegistered<WishController>()) {
      Get.put(WishController());
    }

    // HorseRaceController가 없으면 초기화 (Splash에서 초기화되지 않은 경우 대비)
    if (!Get.isRegistered<HorseRaceController>()) {
      Get.put(HorseRaceController());
      logger.i("HorseRaceController를 DashBoardController에서 초기화");
    }
  }

  /// PiP 초기화 (autoPipMode 관리용)
  Future<void> _initPip() async {
    try {
      bool isPipSupported = await SimplePip.isPipAvailable;
      logger.i('PiP Support for autoPipMode: $isPipSupported');

      if (isPipSupported) {
        _pip = SimplePip();
      }
    } catch (e) {
      logger.e('PiP initialization error: $e');
    }
  }

  /// 기본 YouTube 컨트롤러 초기화
  void _initializeDefaultYoutubeController() {
    try {
      // 기본 더미 비디오로 컨트롤러 생성 (재생하지 않음)
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: 'dQw4w9WgXcQ', // 기본 더미 비디오 ID
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true,
          showVideoAnnotations: false,
          showFullscreenButton: true,
          loop: false,
          enableCaption: false,
        ),
      );

      logger.i("Default YouTube controller initialized");
    } catch (e) {
      logger.e("Failed to initialize default YouTube controller: $e");
    }
  }

  @override
  void onReady() async {
    super.onReady();
    logger.i("DashBoardController onReady called");

    // ProfileController 초기화 확인 및 처리
    await _ensureProfileControllerInitialized();

    logger.i("Starting DashBoardController init...");
    await init();
    logger.i("DashBoardController init completed");

    // 지연된 네비게이션 처리
    await _handlePendingNavigation();
  }

  /// ProfileController가 초기화되었는지 확인하고, 필요시 초기화합니다.
  Future<void> _ensureProfileControllerInitialized() async {
    try {
      final profileController = ProfileController.to;

      // ProfileController가 초기화되지 않았다면 초기화
      if (!profileController.isInitialized.value) {
        logger.i("ProfileController가 초기화되지 않았습니다. 초기화를 시작합니다.");

        // 프로필 데이터 로드
        final profile = await App.getProfile();

        // ProfileController 초기화
        await profileController.initializeWithProfile(profile);

        logger.i("ProfileController 초기화 완료");
      } else {
        logger.i("ProfileController가 이미 초기화되어 있습니다.");
      }
    } catch (e) {
      logger.e("ProfileController 초기화 오류: $e");
    }
  }

  /// 지연된 네비게이션 처리 (1회 사용 후 자동 삭제)
  Future<void> _handlePendingNavigation() async {
    try {
      final pendingNavigationService = PendingNavigationService();

      // 지연된 네비게이션이 있는지 확인
      if (await pendingNavigationService.hasPendingNavigation()) {
        final pendingData =
            await pendingNavigationService.getPendingNavigation();

        if (pendingData != null) {
          final route = pendingData['route'] as String?;
          final data = pendingData['data'] as Map<String, dynamic>?;

          logger.i('🚀 지연된 네비게이션 실행: $route, 데이터: $data');

          // 먼저 지연된 네비게이션 정보 삭제 (1회 사용 보장)
          await pendingNavigationService.clearPendingNavigation();
          logger.i('🗑️ 지연된 네비게이션 정보 삭제 완료 (1회 사용)');

          // 약간의 지연 후 네비게이션 실행 (UI가 완전히 로드된 후)
          if (route != null && route.isNotEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              try {
                Get.toNamed(route);
                logger.i('🚀 지연된 네비게이션 완료: $route');
              } catch (navError) {
                logger.e('네비게이션 실행 오류: $navError');
              }
            });
          } else {
            logger.w('지연된 네비게이션 route가 비어있습니다.');
          }
        } else {
          // 데이터가 null이면 저장된 정보 삭제
          await pendingNavigationService.clearPendingNavigation();
          logger.w('지연된 네비게이션 데이터가 null입니다. 정보를 삭제했습니다.');
        }
      }
    } catch (e) {
      logger.e('지연된 네비게이션 처리 오류: $e');
      // 오류 발생 시에도 저장된 정보 삭제 (안전장치)
      try {
        await PendingNavigationService().clearPendingNavigation();
        logger.i('🗑️ 오류 발생으로 인한 지연된 네비게이션 정보 정리 완료');
      } catch (clearError) {
        logger.e('지연된 네비게이션 정보 삭제 오류: $clearError');
      }
    }
  }

  @override
  void onClose() {
    _playerMonitorTimer?.cancel();
    _youtubeController?.close();

    super.onClose();
  }

  Future<void> init() async {
    logger.i("DashBoardController init started");

    if (kIsWeb) {
      logger.i(Uri.base.origin);
    }

    // ProfileController를 통해 프로필 데이터 새로고침
    logger.i("Refreshing profile...");
    await ProfileController.to.refreshProfile();

    // 게시글 데이터 로딩
    logger.i("Loading all articles...");
    await loadAllArticles();
    logger.i("Loading game news...");
    await loadGameNews();
    logger.i("Loading entertainment news...");
    await loadEntertainmentNews();
    logger.i("Loading music salon...");
    await loadMusicSalon();
    logger.i("Loading favorite playlists...");
    await loadFavoritePlaylists();

    logger.i("DashBoardController init completed successfully");
  }

  void onRefreshLite() async {
    listMaxLength.value = Define.DEFAULT_BOARD_GET_LENGTH;
  }

  void onRefresh() async {
    listMaxLength.value = Define.DEFAULT_BOARD_GET_LENGTH;
    await init();
  }

  void onLoading() async {
    listMaxLength.value = listMaxLength.value + Define.DEFAULT_BOARD_GET_LENGTH;

    await Future.delayed(const Duration(seconds: 1));
  }

  // 대시보드 전체 새로고침
  Future<void> refreshDashboard() async {
    logger.i("Dashboard refresh started");

    try {
      // 게임뉴스, 연예뉴스, 자유게시판, 뮤직살롱, 즐겨찾기 플레이리스트 데이터 동시에 새로고침
      await Future.wait([
        loadGameNews(),
        loadEntertainmentNews(),
        loadAllArticles(),
        loadMusicSalon(),
        loadFavoritePlaylists(),
      ]);

      logger.i("Dashboard refresh completed successfully");
    } catch (e) {
      logger.e("Dashboard refresh error: $e");
    }
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

  // 자유게시판 게시글 로딩
  Future<void> loadAllArticles() async {
    if (isLoadingAllArticles.value) return;

    isLoadingAllArticles.value = true;
    try {
      final articles = await App.getArticleList(
        boardInfo: Arrays.getBoardInfo(Define.BOARD_FREE),
        search: "",
        limit: Define.DEFAULT_DASH_BOARD_GET_LENGTH,
      );

      // 차단된 사용자의 게시글 필터링
      final filteredArticles = await _filterBlockedUsers(articles);
      allArticles.value = filteredArticles;
    } catch (e) {
      logger.e("Error loading all articles: $e");
    } finally {
      isLoadingAllArticles.value = false;
    }
  }

  // 게임뉴스 로딩
  Future<void> loadGameNews() async {
    if (isLoadingGameNews.value) return;

    isLoadingGameNews.value = true;
    try {
      final articles = await App.getArticleList(
        boardInfo: Arrays.getBoardInfo(Define.BOARD_GAME_NEWS),
        search: "",
        limit: Define.DEFAULT_DASH_BOARD_GET_LENGTH,
      );

      // 차단된 사용자의 게시글 필터링
      final filteredArticles = await _filterBlockedUsers(articles);
      gameNews.value = filteredArticles;
    } catch (e) {
      logger.e("Error loading game news: $e");
    } finally {
      isLoadingGameNews.value = false;
    }
  }

  // 연예뉴스 로딩
  Future<void> loadEntertainmentNews() async {
    if (isLoadingEntertainmentNews.value) return;

    isLoadingEntertainmentNews.value = true;
    try {
      logger.i("연예뉴스 로딩 시작 - board_name: ${Define.BOARD_ENTERTAINMENT_NEWS}");
      final articles = await App.getArticleList(
        boardInfo: Arrays.getBoardInfo(Define.BOARD_ENTERTAINMENT_NEWS),
        search: "",
        limit: Define.DEFAULT_DASH_BOARD_GET_LENGTH,
      );

      logger.i("연예뉴스 로딩 완료 - 총 ${articles.length}개 게시글");

      // 차단된 사용자의 게시글 필터링
      final filteredArticles = await _filterBlockedUsers(articles);
      entertainmentNews.value = filteredArticles;

      logger.i("연예뉴스 필터링 완료 - 표시할 게시글 ${filteredArticles.length}개");

      if (filteredArticles.isNotEmpty) {
        logger.i("첫 번째 연예뉴스 제목: ${filteredArticles[0].title}");
      }
    } catch (e) {
      logger.e("Error loading entertainment news: $e");
    } finally {
      isLoadingEntertainmentNews.value = false;
    }
  }

  // 뮤직살롱 플레이리스트 로딩
  Future<void> loadMusicSalon() async {
    if (isLoadingMusicSalon.value) return;

    isLoadingMusicSalon.value = true;
    try {
      logger.i("Starting loadMusicSalon...");

      // HttpService 초기화 확인
      HttpService().initialize();

      final response = await HttpService().getTrackArticleList(
        limit: 3,
        orderBy: 'created_at',
        orderDirection: 'desc',
      );

      logger.i(
        "API Response - success: ${response.success}, data: ${response.data}",
      );

      if (response.success && response.data != null) {
        // 응답 데이터 구조 확인
        logger.i("Response data keys: ${response.data.keys}");

        // 다양한 가능한 키 시도
        List<dynamic> dataList = [];
        if (response.data['articles'] != null) {
          dataList = response.data['articles'];
          logger.i("Found articles key with ${dataList.length} items");
        } else if (response.data['data'] != null) {
          dataList = response.data['data'];
          logger.i("Found data key with ${dataList.length} items");
        } else if (response.data['trackArticles'] != null) {
          dataList = response.data['trackArticles'];
          logger.i("Found trackArticles key with ${dataList.length} items");
        } else {
          // 직접 리스트인 경우
          if (response.data is List) {
            dataList = response.data;
            logger.i(
              "Response data is direct list with ${dataList.length} items",
            );
          } else {
            logger.w("Unknown response structure: ${response.data}");
          }
        }

        if (dataList.isNotEmpty) {
          logger.i("First item structure: ${dataList.first}");
          musicSalonPlaylists.value =
              dataList.map((item) => TrackArticle.fromJson(item)).toList();
          logger.i(
            "Successfully parsed ${musicSalonPlaylists.length} playlists",
          );
        } else {
          logger.w("No data found in response");
          musicSalonPlaylists.value = [];
        }
      } else {
        logger.w("Failed to load music salon: ${response.error}");
        musicSalonPlaylists.value = [];
      }
    } catch (e) {
      logger.e("Error loading music salon: $e");
      musicSalonPlaylists.value = [];
    } finally {
      isLoadingMusicSalon.value = false;
      logger.i(
        "loadMusicSalon completed - final count: ${musicSalonPlaylists.length}",
      );
    }
  }

  // 즐겨찾기 플레이리스트 로딩
  Future<void> loadFavoritePlaylists() async {
    if (isLoadingFavoritePlaylists.value) return;

    isLoadingFavoritePlaylists.value = true;
    try {
      logger.i("Starting loadFavoritePlaylists...");

      // OfficeMusicDetailController의 static 메서드 사용
      final playlists = await OfficeMusicDetailController.getFavoritePlaylist();

      // 최대 3개만 표시
      favoritePlaylists.value = playlists.take(3).toList();

      logger.i(
        "Successfully loaded ${favoritePlaylists.length} favorite playlists",
      );
    } catch (e) {
      logger.e("Error loading favorite playlists: $e");
      favoritePlaylists.value = [];
    } finally {
      isLoadingFavoritePlaylists.value = false;
      logger.i(
        "loadFavoritePlaylists completed - final count: ${favoritePlaylists.length}",
      );
    }
  }

  // ===== 음악 플레이어 관련 메서드들 =====

  /// 플레이리스트 재생 시작
  Future<void> playPlaylist(
    TrackArticle trackArticle, {
    int startIndex = 0,
  }) async {
    try {
      logger.i(
        'playPlaylist called - playlist: ${trackArticle.title}, startIndex: $startIndex',
      );

      currentTrackArticle.value = trackArticle;
      currentTrackIndex.value = startIndex;

      if (trackArticle.tracks.isNotEmpty) {
        logger.i(
          'Loading playlist with ${trackArticle.tracks.length} tracks, starting at index: $startIndex',
        );

        // 기존 컨트롤러가 있으면 정리
        if (_youtubeController != null) {
          await _youtubeController!.close();
          _youtubeController = null;
          // UI 업데이트를 위한 약간의 지연
          await Future.delayed(const Duration(milliseconds: 100));
        }

        // 플레이어 리렌더링을 위한 키 업데이트 (새 컨트롤러 생성 전)
        playerKey.value++;
        logger.i('YouTube 플레이어 리렌더링 준비 - playerKey: ${playerKey.value}');

        // 플레이리스트의 모든 비디오 ID 추출
        final videoIds =
            trackArticle.tracks.map((track) => track.videoId).toList();

        logger.i(
          'Creating new YouTube controller for video: ${videoIds[startIndex]}',
        );

        // 첫 번째 비디오로 컨트롤러 생성 후 플레이리스트 로드
        _youtubeController = YoutubePlayerController.fromVideoId(
          videoId: videoIds[startIndex],
          autoPlay: true,
          params: const YoutubePlayerParams(
            showControls: true,
            showVideoAnnotations: false,
            showFullscreenButton: true,
            loop: false,
            enableCaption: false,
          ),
        );

        // 플레이리스트 로드
        await _youtubeController!.loadPlaylist(
          list: videoIds,
          listType: ListType.playlist,
          index: startIndex,
        );

        // 현재 트랙 설정 (UI 즉시 업데이트)
        currentTrack.value = trackArticle.tracks[startIndex];
        isPlayerInitialized.value = true;
        isPlaying.value = true;
        isPaused.value = false;
        isPlayerVisible.value = true;

        logger.i('YouTube 플레이어 리렌더링 완료 - playerKey: ${playerKey.value}');

        logger.i(
          'Track set: ${currentTrack.value?.title}, VideoId: ${currentTrack.value?.videoId}',
        );

        // 플레이어 상태 리스너 등록
        _youtubeController!.listen((event) {
          logger.i('Player state changed: ${event.playerState}');

          // 재생 상태 업데이트
          switch (event.playerState) {
            case PlayerState.playing:
              isPlaying.value = true;
              isPaused.value = false;
              _enableAutoPipMode(); // 재생 시작 시 autoPipMode 활성화
              break;
            case PlayerState.paused:
              isPlaying.value = false;
              isPaused.value = true;
              _disableAutoPipMode(); // 일시정지 시 autoPipMode 비활성화
              break;
            case PlayerState.ended:
              // 플레이리스트에서 자동으로 다음 곡으로 넘어감
              _updateCurrentTrackIndex();
              isPlaying.value = false;
              isPaused.value = true;
              _disableAutoPipMode(); // 트랙이 완전 종료된 경우에도 autoPipMode 비활성화
              break;
            default:
              break;
          }
        });

        // 플레이어 상태 모니터링 시작
        _startPlayerMonitoring();

        logger.i('Playlist loaded successfully');
      } else {
        logger.w('No tracks in playlist');
      }
    } catch (e) {
      logger.e('playPlaylist error: $e');
    }
  }

  /// 특정 트랙 재생
  Future<void> playTrack(Track track) async {
    try {
      logger.i(
        'playTrack called - track: ${track.title}, videoId: ${track.videoId}',
      );

      currentTrack.value = track;

      // 기존 컨트롤러가 있으면 정리
      if (_youtubeController != null) {
        await _youtubeController!.close();
        _youtubeController = null;
        // UI 업데이트를 위한 약간의 지연
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // 플레이어 리렌더링을 위한 키 업데이트 (새 컨트롤러 생성 전)
      playerKey.value++;
      logger.i('YouTube 플레이어 리렌더링 준비 (단일 트랙) - playerKey: ${playerKey.value}');

      logger.i(
        'Creating new YouTube controller for single track: ${track.videoId}',
      );

      // 새 컨트롤러 생성
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: track.videoId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: true,
          showVideoAnnotations: false,
          showFullscreenButton: true,
          loop: false,
        ),
      );

      isPlayerInitialized.value = true;
      isPlaying.value = true;
      isPaused.value = false;
      isPlayerVisible.value = true;

      logger.i('YouTube 플레이어 리렌더링 완료 (단일 트랙) - playerKey: ${playerKey.value}');

      logger.i(
        'Player initialized - isPlaying: ${isPlaying.value}, isPlayerVisible: ${isPlayerVisible.value}',
      );

      // 플레이어 상태 리스너 등록
      _youtubeController!.listen((event) {
        logger.i('Player state changed: ${event.playerState}');
        if (event.playerState == PlayerState.ended) {
          playNext();
        }
      });

      // 플레이어 상태 모니터링 시작
      _startPlayerMonitoring();
    } catch (e) {
      logger.e('playTrack error: $e');
    }
  }

  /// 재생/일시정지 토글
  Future<void> togglePlayPause() async {
    try {
      final playerState = await _youtubeController!.playerState;

      if (playerState == PlayerState.playing) {
        await _youtubeController!.pauseVideo();
        isPlaying.value = false;
        isPaused.value = true;
        _disableAutoPipMode(); // 일시정지 시 autoPipMode 비활성화
      } else {
        await _youtubeController!.playVideo();
        isPlaying.value = true;
        isPaused.value = false;
        _enableAutoPipMode(); // 재생 시 autoPipMode 활성화
      }
    } catch (e) {
      logger.e('togglePlayPause error: $e');
    }
  }

  /// 다음 곡 재생
  Future<void> playNext() async {
    if (_youtubeController == null || currentTrackArticle.value == null) return;

    try {
      final tracks = currentTrackArticle.value!.tracks;
      if (tracks.length <= 1) {
        logger.w('No next track available');
        return;
      }

      final nextIndex = currentTrackIndex.value + 1;

      if (nextIndex < tracks.length) {
        await _youtubeController!.nextVideo();
        currentTrackIndex.value = nextIndex;
        currentTrack.value = tracks[nextIndex];
        logger.i('Moved to next track: ${currentTrack.value?.title}');
      } else {
        // 플레이리스트 끝 - 첫 곡으로 돌아가기
        await _youtubeController!.seekTo(seconds: 0);
        await _youtubeController!.playVideo();
        currentTrackIndex.value = 0;
        currentTrack.value = tracks[0];
        logger.i(
          'Playlist ended, restarted from first track: ${currentTrack.value?.title}',
        );
      }
    } catch (e) {
      logger.e('playNext error: $e');
    }
  }

  /// 이전 곡 재생
  Future<void> playPrevious() async {
    if (_youtubeController == null || currentTrackArticle.value == null) return;

    try {
      final tracks = currentTrackArticle.value!.tracks;
      if (tracks.length <= 1) {
        logger.w('No previous track available');
        return;
      }

      final prevIndex = currentTrackIndex.value - 1;

      if (prevIndex >= 0) {
        await _youtubeController!.previousVideo();
        currentTrackIndex.value = prevIndex;
        currentTrack.value = tracks[prevIndex];
        logger.i('Moved to previous track: ${currentTrack.value?.title}');
      } else {
        // 첫 곡에서 이전 버튼 - 마지막 곡으로
        // YouTube 플레이어에서 마지막 곡으로 이동하는 로직
        await _youtubeController!.seekTo(seconds: 0);
        await _youtubeController!.playVideo();
        currentTrackIndex.value = tracks.length - 1;
        currentTrack.value = tracks[tracks.length - 1];
        logger.i('Moved to last track: ${currentTrack.value?.title}');
      }
    } catch (e) {
      logger.e('playPrevious error: $e');
    }
  }

  /// 플레이어 닫기
  Future<void> closePlayer() async {
    logger.i('Closing player');

    isPlayerVisible.value = false;
    isPlaying.value = false;
    isPaused.value = false;
    isPlayerInitialized.value = false;
    currentTrack.value = null;
    currentTrackArticle.value = null;

    if (_youtubeController != null) {
      await _youtubeController!.close();
      _youtubeController = null;
    }

    // 플레이어 상태 모니터링 중지
    _stopPlayerMonitoring();

    // 플레이어 닫을 때 autoPipMode 비활성화
    _disableAutoPipMode();
  }

  /// 현재 재생 중인 트랙의 포맷된 제목
  String get currentTrackTitle {
    return currentTrack.value?.title ?? '';
  }

  /// 현재 재생 중인 트랙의 설명
  String get currentTrackDescription {
    return currentTrack.value?.description ?? '';
  }

  /// YouTube 플레이어 컨트롤러 getter
  YoutubePlayerController? get youtubeController => _youtubeController;

  /// 시간을 포맷하는 유틸리티 메서드
  String formatTime(double seconds) {
    if (seconds.isNaN || seconds.isInfinite) return '0:00';

    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).floor();
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// AutoPipMode 활성화 (재생 중일 때)
  Future<void> _enableAutoPipMode() async {
    if (_pip != null) {
      try {
        await _pip!.setAutoPipMode();
        logger.i('AutoPipMode enabled - playing');
      } catch (e) {
        logger.e('Failed to enable AutoPipMode: $e');
      }
    }
  }

  /// AutoPipMode 비활성화 (재생 중이 아닐 때)
  Future<void> _disableAutoPipMode() async {
    if (_pip != null) {
      try {
        // simple_pip_mode에서 autoPipMode를 비활성화하는 직접적인 방법이 없으므로
        // 새 인스턴스를 생성하여 기본 상태로 리셋
        await _pip!.setAutoPipMode(autoEnter: false);
        logger.i('AutoPipMode disabled - not playing');
      } catch (e) {
        logger.e('Failed to disable AutoPipMode: $e');
      }
    }
  }

  /// 플레이리스트에서 트랙 변경 시 현재 트랙 인덱스 업데이트
  void _updateCurrentTrackIndex() {
    if (currentTrackArticle.value == null) return;

    try {
      // 플레이리스트가 끝났을 때 다음 곡으로 자동 이동
      final tracks = currentTrackArticle.value!.tracks;
      final nextIndex = currentTrackIndex.value + 1;

      if (nextIndex < tracks.length) {
        // 다음 곡이 있으면 이동
        currentTrackIndex.value = nextIndex;
        currentTrack.value = tracks[nextIndex];
        logger.i('Auto moved to next track: ${currentTrack.value?.title}');
      } else {
        // 플레이리스트 끝 - 첫 곡으로 돌아가기
        currentTrackIndex.value = 0;
        currentTrack.value = tracks[0];
        logger.i(
          'Playlist ended, restarting from first track: ${currentTrack.value?.title}',
        );
      }
    } catch (e) {
      logger.e('_updateCurrentTrackIndex error: $e');
    }
  }

  /// 플레이어 상태 모니터링 시작
  void _startPlayerMonitoring() {
    _playerMonitorTimer?.cancel();

    _playerMonitorTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkPlayerIndex();
    });

    logger.i('Player monitoring started');
  }

  /// 플레이어 상태 모니터링 중지
  void _stopPlayerMonitoring() {
    _playerMonitorTimer?.cancel();
    _playerMonitorTimer = null;
    logger.i('Player monitoring stopped');
  }

  /// 현재 재생 위치 업데이트
  Future<void> _updateCurrentPosition() async {
    if (_youtubeController == null) return;

    try {
      final position = await _youtubeController!.currentTime;
      final duration = await _youtubeController!.duration;

      if (position != null && duration != null && duration > 0) {
        currentPosition.value = position;
        totalDuration.value = duration;
        progressPercentage.value = position / duration;
      }
    } catch (e) {
      // 에러가 발생해도 로그만 출력하고 계속 진행
      // logger.w('Update position error: $e');
    }
  }

  /// YouTube 플레이어의 현재 인덱스 확인
  Future<void> _checkPlayerIndex() async {
    if (_youtubeController == null || currentTrackArticle.value == null) return;

    try {
      // YouTube 플레이어의 현재 플레이리스트 인덱스 확인
      final playlistIndex = await _youtubeController!.playlistIndex;

      if (playlistIndex != null &&
          playlistIndex != currentTrackIndex.value &&
          playlistIndex >= 0 &&
          playlistIndex < currentTrackArticle.value!.tracks.length) {
        // 인덱스가 변경되었으면 현재 트랙 정보 업데이트
        final oldIndex = currentTrackIndex.value;
        final tracks = currentTrackArticle.value!.tracks;

        currentTrackIndex.value = playlistIndex;
        currentTrack.value = tracks[playlistIndex];

        logger.i(
          'Track index updated from monitoring: $oldIndex -> $playlistIndex (${currentTrack.value?.title})',
        );
      }

      // 현재 재생 시간 업데이트
      await _updateCurrentPosition();

      // YouTube 플레이어의 현재 상태 확인
      final playerState = await _youtubeController!.playerState;

      // 재생 상태에 따라 UI 업데이트
      switch (playerState) {
        case PlayerState.playing:
          if (!isPlaying.value) {
            isPlaying.value = true;
            isPaused.value = false;
            logger.i('Player state synced: playing');
          }
          break;
        case PlayerState.paused:
          if (!isPaused.value) {
            isPlaying.value = false;
            isPaused.value = true;
            logger.i('Player state synced: paused');
          }
          break;
        case PlayerState.ended:
          isPlaying.value = false;
          isPaused.value = false;
          logger.i('Player state synced: ended');
          break;
        default:
          break;
      }
    } catch (e) {
      // 에러가 발생해도 계속 모니터링
      logger.w('_checkPlayerIndex error: $e');
    }
  }
}
