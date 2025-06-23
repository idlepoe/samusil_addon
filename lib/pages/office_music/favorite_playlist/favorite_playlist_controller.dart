import 'package:get/get.dart';
import '../../../models/track_article.dart';
import '../../../components/appSnackbar.dart';
import '../../../main.dart';
import '../office_music_detail/office_music_detail_controller.dart';

class FavoritePlaylistController extends GetxController {
  final favoritePlaylists = <TrackArticle>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavoritePlaylists();
  }

  // 즐겨찾기 플레이리스트 목록 로드
  Future<void> loadFavoritePlaylists() async {
    isLoading.value = true;

    try {
      final playlists = await OfficeMusicDetailController.getFavoritePlaylist();
      favoritePlaylists.value = playlists;
      logger.i('Loaded ${playlists.length} favorite playlists');
    } catch (e) {
      logger.e('loadFavoritePlaylists error: $e');
      AppSnackbar.error('즐겨찾기 목록을 불러오는데 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  // 즐겨찾기에서 제거
  Future<void> removeFavorite(TrackArticle playlist) async {
    try {
      final success = await OfficeMusicDetailController.removeFavoritePlaylist(
        playlist.id,
      );

      if (success) {
        favoritePlaylists.removeWhere((item) => item.id == playlist.id);
        AppSnackbar.success('즐겨찾기에서 제거되었습니다.');
      } else {
        AppSnackbar.error('즐겨찾기 제거에 실패했습니다.');
      }
    } catch (e) {
      logger.e('removeFavorite error: $e');
      AppSnackbar.error('즐겨찾기 제거 중 오류가 발생했습니다.');
    }
  }

  // 플레이리스트 상세 페이지로 이동
  void goToPlaylistDetail(TrackArticle playlist) {
    Get.toNamed('/track-article-detail', arguments: {'id': playlist.id});
  }

  // 새로고침
  Future<void> onRefresh() async {
    await loadFavoritePlaylists();
  }

  // 총 재생 시간 포맷팅
  String formatTotalDuration(int totalDuration) {
    final totalMinutes = (totalDuration / 60).floor();
    final hours = (totalMinutes / 60).floor();
    final minutes = totalMinutes % 60;

    if (hours > 0) {
      return '${hours}시간 ${minutes}분';
    } else {
      return '${minutes}분';
    }
  }

  // 상대적 시간 포맷팅
  String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
    }
  }
}
