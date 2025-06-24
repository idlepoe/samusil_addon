import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../../../models/track_article.dart';
import '../../../models/profile.dart';
import '../../../utils/http_service.dart';
import '../../../utils/app.dart';
import '../../../define/define.dart';
import '../../../components/appSnackbar.dart';
import '../../../main.dart';
import '../../dash_board/dash_board_controller.dart';

class OfficeMusicDetailController extends GetxController {
  final trackArticle = Rx<TrackArticle?>(null);
  final isLoading = false.obs;
  final isLiked = false.obs;
  final isFavorited = false.obs; // 즐겨찾기 상태
  final currentPlayingIndex = Rx<int?>(null);
  final isAuthor = false.obs; // 작성자 여부

  String? trackArticleId;

  @override
  void onInit() {
    super.onInit();

    // Arguments에서 ID 가져오기
    final arguments = Get.arguments;
    if (arguments != null && arguments['id'] != null) {
      trackArticleId = arguments['id'];
      loadTrackArticleDetail();
    }
  }

  Future<void> loadTrackArticleDetail() async {
    if (trackArticleId == null) return;

    isLoading.value = true;

    try {
      final response = await HttpService().getTrackArticleDetail(
        id: trackArticleId!,
        incrementView: true,
      );

      if (response.success && response.data != null) {
        trackArticle.value = TrackArticle.fromJson(response.data);

        // 좋아요 상태 확인
        await checkLikeStatus();

        // 즐겨찾기 상태 확인
        await _checkFavoriteStatus();

        // 작성자 여부 확인
        await _checkAuthorStatus();
      } else {
        Get.back();
        AppSnackbar.error(response.error ?? '플레이리스트를 불러오는데 실패했습니다.');
      }
    } catch (e) {
      logger.e('loadTrackArticleDetail error: $e');
      Get.back();
      AppSnackbar.error('플레이리스트를 불러오는데 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  // 즐겨찾기 상태 확인
  Future<void> _checkFavoriteStatus() async {
    if (trackArticle.value == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favorite_playlists') ?? [];
      isFavorited.value = favoriteIds.contains(trackArticle.value!.id);
    } catch (e) {
      logger.e('_checkFavoriteStatus error: $e');
    }
  }

  // 즐겨찾기 토글 (로컬 처리만)
  Future<void> toggleFavorite() async {
    if (trackArticle.value == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favorite_playlists') ?? [];
      final favoriteData = prefs.getStringList('favorite_playlists_data') ?? [];

      if (isFavorited.value) {
        // 즐겨찾기 제거
        final index = favoriteIds.indexOf(trackArticle.value!.id);
        if (index != -1) {
          favoriteIds.removeAt(index);
          favoriteData.removeAt(index);
        }
        isFavorited.value = false;
        AppSnackbar.info('즐겨찾기에서 제거되었습니다.');
      } else {
        // 즐겨찾기 추가
        favoriteIds.add(trackArticle.value!.id);
        favoriteData.add(jsonEncode(trackArticle.value!.toJson()));
        isFavorited.value = true;
        AppSnackbar.success('즐겨찾기에 추가되었습니다.');
      }

      await prefs.setStringList('favorite_playlists', favoriteIds);
      await prefs.setStringList('favorite_playlists_data', favoriteData);
    } catch (e) {
      logger.e('toggleFavorite error: $e');
      AppSnackbar.error('즐겨찾기 처리 중 오류가 발생했습니다.');
    }
  }

  // 즐겨찾기 목록 가져오기 (static 메서드)
  static Future<List<TrackArticle>> getFavoritePlaylist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteData = prefs.getStringList('favorite_playlists_data') ?? [];

      return favoriteData.map((data) {
        final json = jsonDecode(data);
        return TrackArticle.fromJson(json);
      }).toList();
    } catch (e) {
      logger.e('getFavoritePlaylist error: $e');
      return [];
    }
  }

  // 즐겨찾기에서 특정 플레이리스트 제거 (static 메서드)
  static Future<bool> removeFavoritePlaylist(String playlistId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favorite_playlists') ?? [];
      final favoriteData = prefs.getStringList('favorite_playlists_data') ?? [];

      final index = favoriteIds.indexOf(playlistId);
      if (index != -1) {
        favoriteIds.removeAt(index);
        favoriteData.removeAt(index);

        await prefs.setStringList('favorite_playlists', favoriteIds);
        await prefs.setStringList('favorite_playlists_data', favoriteData);
        return true;
      }
      return false;
    } catch (e) {
      logger.e('removeFavoritePlaylist error: $e');
      return false;
    }
  }

  // 좋아요 상태 확인 (Article Detail과 동일한 방식)
  Future<void> checkLikeStatus() async {
    if (trackArticle.value == null) return;

    try {
      final profile = await App.getProfile();
      final db = FirebaseFirestore.instance;
      final likeRef = db
          .collection(Define.FIRESTORE_COLLECTION_TRACK_ARTICLE)
          .doc(trackArticle.value!.id)
          .collection('likes')
          .doc(profile.uid);

      final likeDoc = await likeRef.get();
      isLiked.value = likeDoc.exists;
    } catch (e) {
      logger.e('좋아요 상태 확인 실패: $e');
    }
  }

  // 좋아요 토글 (낙관적 업데이트)
  Future<void> toggleLike() async {
    if (trackArticle.value == null) return;

    // 현재 상태 백업 (롤백용)
    final originalIsLiked = isLiked.value;
    final originalLikeCount = trackArticle.value!.count_like;

    // 즉시 UI 업데이트 (낙관적 업데이트)
    final newIsLiked = !originalIsLiked;
    final newLikeCount =
        newIsLiked ? originalLikeCount + 1 : originalLikeCount - 1;

    isLiked.value = newIsLiked;
    trackArticle.value = trackArticle.value!.copyWith(count_like: newLikeCount);

    // 즉시 성공 메시지 표시
    if (newIsLiked) {
      AppSnackbar.success('좋아요를 눌렀습니다.');
    } else {
      AppSnackbar.info('좋아요를 취소했습니다.');
    }

    try {
      // 백그라운드에서 서버 처리
      final response = await HttpService().toggleTrackArticleLike(
        id: trackArticle.value!.id,
      );

      if (response.success && response.data != null) {
        final data = response.data;
        final serverIsLiked = data['isLiked'] as bool;
        final serverCountLike = data['countLike'] as int;

        // 서버 응답이 예상과 다른 경우 서버 데이터로 동기화
        if (serverIsLiked != newIsLiked || serverCountLike != newLikeCount) {
          isLiked.value = serverIsLiked;
          trackArticle.value = trackArticle.value!.copyWith(
            count_like: serverCountLike,
          );
        }
      } else {
        // 서버 오류 시 원래 상태로 롤백
        isLiked.value = originalIsLiked;
        trackArticle.value = trackArticle.value!.copyWith(
          count_like: originalLikeCount,
        );
        AppSnackbar.error(response.error ?? '좋아요 처리에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      // 네트워크 오류 시 원래 상태로 롤백
      logger.e('toggleLike error: $e');
      isLiked.value = originalIsLiked;
      trackArticle.value = trackArticle.value!.copyWith(
        count_like: originalLikeCount,
      );
      AppSnackbar.error('네트워크 오류로 좋아요 처리에 실패했습니다. 다시 시도해주세요.');
    }
  }

  // 트랙 재생 (Dashboard 플레이어 사용)
  void playTrack(int index) {
    if (trackArticle.value == null ||
        index >= trackArticle.value!.tracks.length)
      return;

    try {
      currentPlayingIndex.value = index;

      // Dashboard로 이동
      Get.offAllNamed('/');

      // Dashboard 컨트롤러 찾기 (약간의 지연 후)
      Future.delayed(const Duration(milliseconds: 100), () {
        try {
          final dashboardController = Get.find<DashBoardController>();
          dashboardController.playPlaylist(
            trackArticle.value!,
            startIndex: index,
          );
          AppSnackbar.info('${trackArticle.value!.tracks[index].title} 재생');
        } catch (e) {
          logger.e('playTrack - Dashboard controller error: $e');
          AppSnackbar.error('재생 중 오류가 발생했습니다.');
        }
      });
    } catch (e) {
      logger.e('playTrack error: $e');
      AppSnackbar.error('재생 중 오류가 발생했습니다.');
    }
  }

  // 전체 재생
  void playAll() {
    if (trackArticle.value == null || trackArticle.value!.tracks.isEmpty)
      return;

    try {
      // Dashboard로 이동
      Get.offAllNamed('/');

      // Dashboard 컨트롤러 찾기 (약간의 지연 후)
      Future.delayed(const Duration(milliseconds: 100), () {
        try {
          final dashboardController = Get.find<DashBoardController>();
          dashboardController.playPlaylist(trackArticle.value!, startIndex: 0);
          AppSnackbar.success('전체 재생을 시작합니다.');
        } catch (e) {
          logger.e('playAll - Dashboard controller error: $e');
          AppSnackbar.error('재생 중 오류가 발생했습니다.');
        }
      });
    } catch (e) {
      logger.e('playAll error: $e');
      AppSnackbar.error('재생 중 오류가 발생했습니다.');
    }
  }

  // 셔플 재생
  void shufflePlay() {
    if (trackArticle.value == null || trackArticle.value!.tracks.isEmpty)
      return;

    try {
      final tracks = trackArticle.value!.tracks;
      final randomIndex =
          (tracks.length * (DateTime.now().millisecondsSinceEpoch % 100) / 100)
              .floor();

      // Dashboard로 이동
      Get.offAllNamed('/');

      // Dashboard 컨트롤러 찾기 (약간의 지연 후)
      Future.delayed(const Duration(milliseconds: 100), () {
        try {
          final dashboardController = Get.find<DashBoardController>();
          dashboardController.playPlaylist(
            trackArticle.value!,
            startIndex: randomIndex,
          );
          AppSnackbar.success('셔플 재생을 시작합니다.');
        } catch (e) {
          logger.e('shufflePlay - Dashboard controller error: $e');
          AppSnackbar.error('재생 중 오류가 발생했습니다.');
        }
      });
    } catch (e) {
      logger.e('shufflePlay error: $e');
      AppSnackbar.error('재생 중 오류가 발생했습니다.');
    }
  }

  // 공유하기
  void sharePlaylist() {
    if (trackArticle.value == null) return;

    try {
      final playlist = trackArticle.value!;

      // 앱링크 생성
      final appLink = 'https://officelounge.app/playlist/${playlist.id}';

      // 공유할 텍스트 구성
      final shareText = '''
🎵 ${playlist.title}

${playlist.description.isNotEmpty ? '${playlist.description}\n\n' : ''}🎶 ${playlist.track_count}곡 • ${getTotalDuration()}
👤 ${playlist.profile_name}

📱 OfficeLounge에서 들어보기
$appLink

#OfficeLounge #플레이리스트 #음악''';

      // share_plus 패키지 사용
      Share.share(shareText, subject: '${playlist.title} - OfficeLounge');

      AppSnackbar.info('플레이리스트를 공유합니다.');
    } catch (e) {
      logger.e('sharePlaylist error: $e');
      AppSnackbar.error('공유 중 오류가 발생했습니다.');
    }
  }

  // 플레이리스트 수정 페이지로 이동 (본인 플레이리스트인 경우)
  void editPlaylist() {
    if (trackArticle.value == null) return;

    Get.toNamed(
      '/office-music-edit',
      arguments: {'trackArticle': trackArticle.value!},
    );
  }

  // 플레이리스트 삭제
  Future<void> deletePlaylist() async {
    if (trackArticle.value == null || trackArticleId == null) return;

    try {
      final response = await HttpService().deleteTrackArticle(
        id: trackArticleId!,
      );

      if (response.success) {
        Get.back(result: true); // 삭제 완료를 알리기 위해 result 전달
        AppSnackbar.success('플레이리스트가 삭제되었습니다.');
      } else {
        AppSnackbar.error(response.error ?? '플레이리스트 삭제에 실패했습니다.');
      }
    } catch (e) {
      logger.e('deletePlaylist error: $e');
      AppSnackbar.error('플레이리스트 삭제 중 오류가 발생했습니다.');
    }
  }

  // 재생 시간 포맷팅
  String formatDuration(dynamic duration) {
    // duration이 int라면 초 단위로 처리
    if (duration is int) {
      final minutes = (duration / 60).floor();
      final seconds = duration % 60;
      return '${minutes}:${seconds.toString().padLeft(2, '0')}';
    }

    // duration이 String이고 "PT3M45S" 같은 형식이라면 파싱
    final durationStr = duration.toString();
    if (durationStr.startsWith('PT')) {
      final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
      final match = regex.firstMatch(durationStr);

      if (match != null) {
        final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
        final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
        final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;

        if (hours > 0) {
          return '${hours}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        } else {
          return '${minutes}:${seconds.toString().padLeft(2, '0')}';
        }
      }
    }

    return durationStr.isNotEmpty ? durationStr : '3:00';
  }

  // 총 재생 시간 계산
  String getTotalDuration() {
    if (trackArticle.value == null) return '0:00';

    final totalMinutes = (trackArticle.value!.total_duration / 60).floor();
    final hours = (totalMinutes / 60).floor();
    final minutes = totalMinutes % 60;

    if (hours > 0) {
      return '${hours}시간 ${minutes}분';
    } else {
      return '${minutes}분';
    }
  }

  // 작성자 여부 확인
  Future<void> _checkAuthorStatus() async {
    if (trackArticle.value == null) return;

    try {
      final profile = await App.getProfile();
      isAuthor.value = profile.uid == trackArticle.value!.profile_uid;
    } catch (e) {
      logger.e('isAuthor error: $e');
    }
  }
}
