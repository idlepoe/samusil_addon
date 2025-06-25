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
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0064FF), // Toss 브랜드 블루
              Color(0xFF3182F6), // 밝은 블루
              Color(0xFF1B73E8), // 구글 블루 톤
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0064FF).withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 썸네일과 제목 영역 (dot indicator와 겹침)
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  50,
                ), // 하단은 진행률 바 공간 확보
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 썸네일 영역
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                            track?.thumbnail.isNotEmpty == true
                                ? Image.network(
                                  track!.thumbnail,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.music_note,
                                        color: Color(0xFF0064FF),
                                        size: 24,
                                      ),
                                    );
                                  },
                                )
                                : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.music_note,
                                    color: Color(0xFF0064FF),
                                    size: 24,
                                  ),
                                ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // 텍스트 정보 영역
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track?.title ?? '제목 없음',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            track?.description ?? '설명 없음',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 하단 진행률 바 영역 (Toss 스타일)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 시간 표시 및 dot indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            controller.formatTime(
                              controller.currentPosition.value,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        // 중앙 dot indicator
                        if (trackArticle != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (trackArticle.tracks.length <= 10)
                                  ...List.generate(trackArticle.tracks.length, (
                                    index,
                                  ) {
                                    final isCurrentTrack =
                                        index ==
                                        controller.currentTrackIndex.value;
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 1,
                                      ),
                                      width: 3,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            isCurrentTrack
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.5),
                                        boxShadow:
                                            isCurrentTrack
                                                ? [
                                                  BoxShadow(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    blurRadius: 2,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ]
                                                : null,
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
                                    final isCurrentSegment =
                                        index == currentSegment;

                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 1,
                                      ),
                                      width: 3,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            isCurrentSegment
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.5),
                                        boxShadow:
                                            isCurrentSegment
                                                ? [
                                                  BoxShadow(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    blurRadius: 2,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ]
                                                : null,
                                      ),
                                    );
                                  }),
                              ],
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            controller.formatTime(
                              controller.totalDuration.value,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Toss 스타일 진행률 바
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
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
                              // 진행된 부분 (Toss 스타일 그라데이션)
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                width: progressWidth,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.white, Color(0xFFF0F4FF)],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.5),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
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
