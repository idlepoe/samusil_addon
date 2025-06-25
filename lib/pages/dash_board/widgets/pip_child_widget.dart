import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dash_board_controller.dart';

class PipChildWidget extends GetView<DashBoardController> {
  const PipChildWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final track = controller.currentTrack.value;
      final trackArticle = controller.currentTrackArticle.value;

      return Container(
        decoration:
            track?.thumbnail.isNotEmpty == true
                ? BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(track!.thumbnail),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7),
                      BlendMode.darken,
                    ),
                  ),
                )
                : const BoxDecoration(color: Colors.black),
        child: Stack(
          children: [
            // 메인 콘텐츠 영역 - 중앙 텍스트
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          track?.title ?? '제목 없음',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Flexible(
                        child: Text(
                          track?.description ?? '설명 없음',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 하단 진행률 바 영역
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 28,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 시간 표시
                    Container(
                      height: 16,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.formatTime(
                              controller.currentPosition.value,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            controller.formatTime(
                              controller.totalDuration.value,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 진행률 바
                    Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final progressWidth =
                              constraints.maxWidth *
                              controller.progressPercentage.value.clamp(
                                0.0,
                                1.0,
                              );
                          return Stack(
                            children: [
                              // 진행된 부분 (왼쪽에서 오른쪽으로 채워짐)
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                width: progressWidth,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.cyan, Colors.blue],
                                    ),
                                    borderRadius: BorderRadius.circular(1.5),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),

            // 우상단 트랙 정보
            if (trackArticle != null)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (trackArticle.tracks.length <= 10)
                            ...List.generate(trackArticle.tracks.length, (
                              index,
                            ) {
                              final isCurrentTrack =
                                  index == controller.currentTrackIndex.value;
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 1.5,
                                ),
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      isCurrentTrack
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.4),
                                ),
                              );
                            })
                          else
                            ...List.generate(10, (index) {
                              final segmentSize =
                                  trackArticle.tracks.length / 10;
                              final currentSegment =
                                  (controller.currentTrackIndex.value /
                                          segmentSize)
                                      .floor();
                              final isCurrentSegment = index == currentSegment;

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 1.5,
                                ),
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      isCurrentSegment
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.4),
                                ),
                              );
                            }),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${controller.currentTrackIndex.value + 1} / ${trackArticle.tracks.length}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
