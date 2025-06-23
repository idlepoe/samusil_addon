import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../dash_board_controller.dart';

class MusicPlayerWidget extends GetView<DashBoardController> {
  const MusicPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // YouTube 플레이어 (화면 밖으로 숨김)
        Positioned(
          left: -1000, // 화면 왼쪽 밖으로 이동
          top: -1000, // 화면 위쪽 밖으로 이동
          child: SizedBox(
            width: 1,
            height: 1,
            child: Obx(() {
              print(
                'YouTube 플레이어 위젯 리빌드 - playerKey: ${controller.playerKey.value}',
              );

              if (controller.youtubeController == null) {
                print('YouTube 컨트롤러가 null입니다');
                return const SizedBox.shrink();
              }

              return YoutubePlayer(
                key: ValueKey('player_${controller.playerKey.value}'),
                controller: controller.youtubeController!,
              );
            }),
          ),
        ),

        // 미니 플레이어 UI (재생 중일 때만 표시)
        Obx(() {
          // 재생 중이 아니면 표시하지 않음
          if (!controller.isPlaying.value && !controller.isPaused.value) {
            return const SizedBox.shrink();
          }

          return Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // 썸네일
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFF2F4F6),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Obx(
                      () =>
                          controller.currentTrack.value != null &&
                                  controller
                                      .currentTrack
                                      .value!
                                      .thumbnail
                                      .isNotEmpty
                              ? Image.network(
                                controller.currentTrack.value!.thumbnail,
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
                ),

                // 트랙 정보
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          controller.currentTrack.value?.title ??
                              '재생할 음악을 선택해주세요',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Obx(
                        () => Text(
                          controller.currentTrack.value?.description ??
                              '음악을 재생하면 정보가 표시됩니다',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8B95A1),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // 컨트롤 버튼들
                Row(
                  children: [
                    Obx(
                      () => IconButton(
                        onPressed:
                            controller.currentTrackArticle.value != null &&
                                    controller
                                            .currentTrackArticle
                                            .value!
                                            .tracks
                                            .length >
                                        1
                                ? controller.playPrevious
                                : null,
                        icon: const Icon(Icons.skip_previous, size: 24),
                        color:
                            controller.currentTrackArticle.value != null &&
                                    controller
                                            .currentTrackArticle
                                            .value!
                                            .tracks
                                            .length >
                                        1
                                ? const Color(0xFF4E5968)
                                : const Color(0xFFCCCCCC),
                      ),
                    ),
                    Obx(
                      () => IconButton(
                        onPressed: controller.togglePlayPause,
                        icon: Icon(
                          controller.isPlaying.value
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 28,
                        ),
                        color: const Color(0xFF3182F6),
                      ),
                    ),
                    Obx(
                      () => IconButton(
                        onPressed:
                            controller.currentTrackArticle.value != null &&
                                    controller
                                            .currentTrackArticle
                                            .value!
                                            .tracks
                                            .length >
                                        1
                                ? controller.playNext
                                : null,
                        icon: const Icon(Icons.skip_next, size: 24),
                        color:
                            controller.currentTrackArticle.value != null &&
                                    controller
                                            .currentTrackArticle
                                            .value!
                                            .tracks
                                            .length >
                                        1
                                ? const Color(0xFF4E5968)
                                : const Color(0xFFCCCCCC),
                      ),
                    ),
                    IconButton(
                      onPressed: controller.closePlayer,
                      icon: const Icon(Icons.close, size: 20),
                      color: const Color(0xFF8B95A1),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
