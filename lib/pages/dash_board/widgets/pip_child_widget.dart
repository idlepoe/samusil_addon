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
            Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          track?.title ?? '제목 없음',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          track?.description ?? '설명 없음',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.formatTime(
                              controller.currentPosition.value,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            controller.formatTime(
                              controller.totalDuration.value,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft, // 왼쪽에서 시작
                          widthFactor: controller.progressPercentage.value
                              .clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.cyan, Colors.blue],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (trackArticle != null)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    // color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                                width: 5,
                                height: 5,
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
                                width: 5,
                                height: 5,
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
                      const SizedBox(height: 4),
                      Text(
                        '${controller.currentTrackIndex.value + 1} / ${trackArticle.tracks.length}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 8,
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
