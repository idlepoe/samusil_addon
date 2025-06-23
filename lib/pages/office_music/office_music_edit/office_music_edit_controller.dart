import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/appSnackbar.dart';
import '../../../main.dart';
import '../../../models/youtube/track.dart';
import '../../../models/track_article.dart';
import '../../../utils/http_service.dart';

class OfficeMusicEditController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final isPressed = false.obs;
  final tracks = <Track>[].obs;

  // 수정 모드 관련 변수
  final isEditMode = false.obs;
  TrackArticle? editingTrackArticle;

  @override
  void onInit() {
    super.onInit();
    logger.d('OfficeMusicEditController initialized');

    // Arguments에서 trackArticle 존재 여부로 수정 모드 판단
    final arguments = Get.arguments;
    if (arguments != null && arguments['trackArticle'] != null) {
      isEditMode.value = true;
      editingTrackArticle = arguments['trackArticle'] as TrackArticle;
      _loadEditData();
      logger.d('Edit mode detected: ${editingTrackArticle!.title}');
    } else {
      logger.d('Create mode detected');
    }
  }

  // 수정할 데이터 로드
  void _loadEditData() {
    if (editingTrackArticle != null) {
      titleController.text = editingTrackArticle!.title;
      descriptionController.text = editingTrackArticle!.description;
      tracks.value = List<Track>.from(editingTrackArticle!.tracks);
      logger.d('Edit mode loaded: ${editingTrackArticle!.title}');
    }
  }

  Future<void> savePlaylist() async {
    if (isPressed.value) return;

    try {
      // 제목 검증
      if (titleController.text.trim().isEmpty) {
        AppSnackbar.error('플레이리스트 제목을 입력해주세요.');
        return;
      }

      // 트랙 목록 검증
      if (tracks.isEmpty) {
        AppSnackbar.error('최소 1개 이상의 음악을 추가해주세요.');
        return;
      }

      isPressed.value = true;

      if (isEditMode.value && editingTrackArticle != null) {
        // 수정 모드
        final response = await HttpService().updateTrackArticle(
          id: editingTrackArticle!.id,
          title: titleController.text.trim(),
          tracks: tracks.toList(),
          description: descriptionController.text.trim(),
        );

        if (response.success) {
          Get.back(result: {'refresh': true});
          AppSnackbar.success('플레이리스트가 수정되었습니다.');
        } else {
          AppSnackbar.error(response.error ?? '플레이리스트 수정에 실패했습니다.');
        }
      } else {
        // 생성 모드
        final response = await HttpService().createTrackArticle(
          title: titleController.text.trim(),
          tracks: tracks.toList(),
          description: descriptionController.text.trim(),
        );

        if (response.success) {
          Get.back(result: {'refresh': true});
          AppSnackbar.success('플레이리스트가 생성되었습니다.');
        } else {
          AppSnackbar.error(response.error ?? '플레이리스트 생성에 실패했습니다.');
        }
      }
    } catch (e) {
      logger.e("savePlaylist error: $e");
      AppSnackbar.error(
        isEditMode.value
            ? '플레이리스트 수정 중 오류가 발생했습니다.'
            : '플레이리스트 생성 중 오류가 발생했습니다.',
      );
    } finally {
      isPressed.value = false;
    }
  }

  // 하위 호환성을 위한 메서드
  Future<void> createPlaylist() async {
    await savePlaylist();
  }

  // 음악 추가 버튼 클릭
  Future<void> addMusic() async {
    final result = await Get.toNamed(
      "/youtube-search",
      arguments: {'selectedTracks': tracks.toList()},
    );

    if (result != null && result is List<Track>) {
      tracks.value = result;
      AppSnackbar.success('${result.length}개의 음악이 추가되었습니다.');
    }
  }

  // 음악 목록에서 특정 음악 삭제
  void removeTrack(int index) {
    if (index >= 0 && index < tracks.length) {
      final removedTrack = tracks[index];
      tracks.removeAt(index);
      AppSnackbar.info('${removedTrack.title}이 삭제되었습니다.');
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
