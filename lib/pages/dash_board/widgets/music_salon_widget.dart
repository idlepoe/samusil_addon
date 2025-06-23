import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/track_article.dart';
import '../../../utils/util.dart';
import '../dash_board_controller.dart';

class MusicSalonWidget extends GetView<DashBoardController> {
  const MusicSalonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3182F6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '🎵 뮤직살롱',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF191F28),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed('/office-music-list');
              },
              child: const Text(
                '더보기',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B95A1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 플레이리스트 카드들
        Obx(() {
          print(
            'MusicSalon 상태 - loading: ${controller.isLoadingMusicSalon.value}, playlists: ${controller.musicSalonPlaylists.length}',
          );

          if (controller.musicSalonPlaylists.isNotEmpty) {
            print('첫 번째 플레이리스트: ${controller.musicSalonPlaylists.first.title}');
            print(
              '플레이리스트 트랙 수: ${controller.musicSalonPlaylists.first.tracks.length}',
            );
          }

          if (controller.isLoadingMusicSalon.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(color: Color(0xFF3182F6)),
              ),
            );
          }

          if (controller.musicSalonPlaylists.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E8EB)),
              ),
              child: const Center(
                child: Text(
                  '아직 등록된 플레이리스트가 없습니다',
                  style: TextStyle(color: Color(0xFF8B95A1), fontSize: 14),
                ),
              ),
            );
          }

          return Column(
            children:
                controller.musicSalonPlaylists
                    .take(3)
                    .map((playlist) => _buildPlaylistCard(playlist))
                    .toList(),
          );
        }),
      ],
    );
  }

  Widget _buildPlaylistCard(TrackArticle playlist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E8EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed('/track-article-detail', arguments: {'id': playlist.id});
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 썸네일
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFF2F4F6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      playlist.tracks.isNotEmpty &&
                              playlist.tracks.first.thumbnail.isNotEmpty
                          ? Image.network(
                            playlist.tracks.first.thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.music_note,
                                color: Color(0xFF8B95A1),
                                size: 24,
                              );
                            },
                          )
                          : const Icon(
                            Icons.music_note,
                            color: Color(0xFF8B95A1),
                            size: 24,
                          ),
                ),
              ),
              const SizedBox(width: 12),

              // 플레이리스트 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목
                    Text(
                      playlist.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191F28),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // 메타 정보
                    Text(
                      '${playlist.track_count}곡 • ${_formatDuration(playlist.total_duration)} • ${playlist.profile_name}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B95A1),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // 통계 정보
                    Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 14,
                          color: const Color(0xFF8B95A1),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${playlist.count_view}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8B95A1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.favorite,
                          size: 14,
                          color: const Color(0xFF8B95A1),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${playlist.count_like}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8B95A1),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(playlist.created_at),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8B95A1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 재생 버튼
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF3182F6),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: IconButton(
                  onPressed: () async {
                    try {
                      print('재생 버튼 클릭됨: ${playlist.title}');
                      print(
                        '재생 전 상태 - isPlayerVisible: ${controller.isPlayerVisible.value}, currentTrack: ${controller.currentTrack.value?.title}',
                      );

                      await controller.playPlaylist(playlist, startIndex: 0);

                      // 약간의 지연 후 상태 확인
                      await Future.delayed(const Duration(milliseconds: 500));
                      print(
                        '재생 후 상태 - isPlayerVisible: ${controller.isPlayerVisible.value}, currentTrack: ${controller.currentTrack.value?.title}',
                      );
                      print(
                        'youtubeController: ${controller.youtubeController != null}',
                      );

                      // 이미 대시보드에 있으므로 네비게이션하지 않음
                    } catch (e) {
                      print('재생 오류: $e');
                    }
                  },
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds / 60).floor();
    final hours = (minutes / 60).floor();

    if (hours > 0) {
      return '${hours}시간 ${minutes % 60}분';
    } else {
      return '${minutes}분';
    }
  }

  String _formatDate(DateTime dateTime) {
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
      return '${dateTime.month}/${dateTime.day}';
    }
  }
}
