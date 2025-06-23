import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../models/track_article.dart';
import '../../../utils/http_service.dart';
import '../../../components/appSnackbar.dart';
import '../../../main.dart';

class OfficeMusicDetailController extends GetxController {
  final trackArticle = Rx<TrackArticle?>(null);
  final isLoading = false.obs;
  final isLiked = false.obs;
  final currentPlayingIndex = Rx<int?>(null);

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
      } else {
        AppSnackbar.error(response.error ?? '플레이리스트를 불러오는데 실패했습니다.');
        Get.back();
      }
    } catch (e) {
      logger.e('loadTrackArticleDetail error: $e');
      AppSnackbar.error('플레이리스트를 불러오는데 실패했습니다.');
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  // 좋아요 토글
  void toggleLike() {
    if (trackArticle.value == null) return;

    isLiked.value = !isLiked.value;

    // TODO: 실제 좋아요 API 호출
    if (isLiked.value) {
      trackArticle.value = trackArticle.value!.copyWith(
        count_like: trackArticle.value!.count_like + 1,
      );
      AppSnackbar.success('좋아요를 눌렀습니다.');
    } else {
      trackArticle.value = trackArticle.value!.copyWith(
        count_like: trackArticle.value!.count_like - 1,
      );
      AppSnackbar.info('좋아요를 취소했습니다.');
    }
  }

  // 트랙 재생 (YouTube 앱으로 이동)
  void playTrack(int index) {
    if (trackArticle.value == null ||
        index >= trackArticle.value!.tracks.length)
      return;

    currentPlayingIndex.value = index;
    final track = trackArticle.value!.tracks[index];

    // YouTube 링크로 이동
    final youtubeUrl = 'https://www.youtube.com/watch?v=${track.videoId}';

    // TODO: URL launcher로 YouTube 앱 실행
    AppSnackbar.info('${track.title} 재생');
  }

  // 전체 재생
  void playAll() {
    if (trackArticle.value == null || trackArticle.value!.tracks.isEmpty)
      return;

    playTrack(0);
    AppSnackbar.success('전체 재생을 시작합니다.');
  }

  // 셔플 재생
  void shufflePlay() {
    if (trackArticle.value == null || trackArticle.value!.tracks.isEmpty)
      return;

    final tracks = trackArticle.value!.tracks;
    final randomIndex =
        (tracks.length * (DateTime.now().millisecondsSinceEpoch % 100) / 100)
            .floor();

    playTrack(randomIndex);
    AppSnackbar.success('셔플 재생을 시작합니다.');
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
        AppSnackbar.success('플레이리스트가 삭제되었습니다.');
        Get.back(result: true); // 삭제 완료를 알리기 위해 result 전달
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
}
