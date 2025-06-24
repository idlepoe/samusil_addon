import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/appCircularProgress.dart';
import '../../../components/appSnackbar.dart';
import '../../../components/report_bottom_sheet.dart';
import '../../../components/block_bottom_sheet.dart';
import '../../../models/youtube/track.dart';
import '../../../models/article.dart';
import 'office_music_detail_controller.dart';

class OfficeMusicDetailView extends GetView<OfficeMusicDetailController> {
  const OfficeMusicDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AppCircularProgress.large());
        }

        final trackArticle = controller.trackArticle.value;
        if (trackArticle == null) {
          return const Center(child: Text('플레이리스트를 찾을 수 없습니다.'));
        }

        return CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Get.back(),
              ),
              actions: [_buildMoreMenuButton()],
            ),

            // Header Section
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Playlist Thumbnail
                    Container(
                      width: double.infinity,
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFFF2F4F6),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child:
                            trackArticle.tracks.isNotEmpty &&
                                    trackArticle
                                        .tracks
                                        .first
                                        .thumbnail
                                        .isNotEmpty
                                ? Image.network(
                                  trackArticle.tracks.first.thumbnail,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.queue_music,
                                      size: 80,
                                      color: Color(0xFF8B95A1),
                                    );
                                  },
                                )
                                : const Icon(
                                  Icons.queue_music,
                                  size: 80,
                                  color: Color(0xFF8B95A1),
                                ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title
                    Text(
                      trackArticle.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Row(
                      children: [
                        Text(
                          '${trackArticle.track_count}곡 • ${controller.getTotalDuration()} • ${trackArticle.profile_name}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF8B95A1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        // 좋아요 수와 조회수 표시
                        Row(
                          children: [
                            Obx(
                              () => AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  controller.isLiked.value
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  key: ValueKey(controller.isLiked.value),
                                  size: 16,
                                  color:
                                      controller.isLiked.value
                                          ? Colors.red
                                          : Colors.red.withOpacity(0.7),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Obx(
                              () => AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      controller.isLiked.value
                                          ? Colors.red
                                          : const Color(0xFF8B95A1),
                                  fontWeight: FontWeight.w500,
                                ),
                                child: Text(
                                  '${controller.trackArticle.value?.count_like ?? 0}',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.visibility,
                              size: 16,
                              color: Color(0xFF8B95A1),
                            ),
                            const SizedBox(width: 4),
                            Obx(
                              () => Text(
                                '${controller.trackArticle.value?.count_view ?? 0}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF8B95A1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    if (trackArticle.description.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        trackArticle.description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF4E5968),
                          height: 1.5,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Play Action Buttons (전체 재생, 셔플)
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.play_arrow,
                            label: '전체 재생',
                            isPrimary: true,
                            onTap: controller.playAll,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.shuffle,
                            label: '셔플',
                            onTap: controller.shufflePlay,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Secondary Action Buttons (좋아요, 북마크, 공유)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(() => _buildAnimatedLikeButton()),
                        const SizedBox(width: 16),
                        Obx(
                          () => _buildIconButton(
                            icon:
                                controller.isFavorited.value
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                            color:
                                controller.isFavorited.value
                                    ? const Color(0xFF3182F6)
                                    : const Color(0xFF8B95A1),
                            onTap: controller.toggleFavorite,
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildIconButton(
                          icon: Icons.share,
                          color: const Color(0xFF8B95A1),
                          onTap: controller.sharePlaylist,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Track List Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                      child: Text(
                        '곡 목록',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    // Track List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: trackArticle.tracks.length,
                      itemBuilder: (context, index) {
                        final track = trackArticle.tracks[index];
                        final isPlaying =
                            controller.currentPlayingIndex.value == index;

                        return _buildTrackItem(
                          track: track,
                          index: index,
                          isPlaying: isPlaying,
                          onTap: () => controller.playTrack(index),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Material(
      color: isPrimary ? const Color(0xFF3182F6) : const Color(0xFFF2F4F6),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isPrimary ? Colors.white : const Color(0xFF4E5968),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? Colors.white : const Color(0xFF4E5968),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFF2F4F6),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 52,
          height: 52,
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }

  Widget _buildTrackItem({
    required Track track,
    required int index,
    required bool isPlaying,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              // Track Number or Playing Icon
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                child:
                    isPlaying
                        ? const Icon(
                          Icons.graphic_eq,
                          size: 20,
                          color: Color(0xFF3182F6),
                        )
                        : Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8B95A1),
                          ),
                        ),
              ),

              const SizedBox(width: 12),

              // Thumbnail
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFF2F4F6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      track.thumbnail.isNotEmpty
                          ? Image.network(
                            track.thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.music_note,
                                size: 20,
                                color: Color(0xFF8B95A1),
                              );
                            },
                          )
                          : const Icon(
                            Icons.music_note,
                            size: 20,
                            color: Color(0xFF8B95A1),
                          ),
                ),
              ),

              const SizedBox(width: 16),

              // Track Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color:
                            isPlaying
                                ? const Color(0xFF3182F6)
                                : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (track.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        track.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8B95A1),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Duration
              Text(
                controller.formatDuration(track.duration),
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8B95A1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 애니메이션 좋아요 버튼
  Widget _buildAnimatedLikeButton() {
    return Material(
      color: const Color(0xFFF2F4F6),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: controller.toggleLike,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 52,
          height: 52,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child:
                controller.isLiked.value
                    ? TweenAnimationBuilder<double>(
                      key: const ValueKey('filled_heart'),
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.8 + (value * 0.2),
                          child: Icon(
                            Icons.favorite,
                            size: 20,
                            color: Colors.red.withOpacity(value),
                          ),
                        );
                      },
                    )
                    : const Icon(
                      key: ValueKey('empty_heart'),
                      Icons.favorite_border,
                      size: 20,
                      color: Color(0xFF8B95A1),
                    ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              '플레이리스트 삭제',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            content: const Text(
              '정말로 이 플레이리스트를 삭제하시겠습니까?\n삭제된 플레이리스트는 복구할 수 없습니다.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  '취소',
                  style: TextStyle(color: Color(0xFF8B95A1)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  controller.deletePlaylist();
                },
                child: const Text('삭제', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  Widget _buildMoreMenuButton() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.black87),
      onSelected: (value) => _handleMenuAction(value),
      itemBuilder: (BuildContext context) {
        final List<PopupMenuItem<String>> items = [];

        // 공유하기는 항상 표시
        items.add(_buildPopupMenuItem('share', '공유하기', Icons.share_outlined));

        // 작성자인 경우
        if (controller.isAuthor.value) {
          items.add(_buildPopupMenuItem('edit', '수정하기', Icons.edit_outlined));
          items.add(
            _buildPopupMenuItem(
              'delete',
              '삭제하기',
              Icons.delete_outline,
              isDestructive: true,
            ),
          );
        } else {
          // 작성자가 아닌 경우에만 신고하기, 차단하기 메뉴 추가
          items.add(
            _buildPopupMenuItem('report', '신고하기', Icons.report_outlined),
          );
          items.add(_buildPopupMenuItem('block', '차단하기', Icons.block));
        }

        return items;
      },
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String value,
    String text,
    IconData icon, {
    bool isDestructive = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isDestructive ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'share':
        controller.sharePlaylist();
        break;
      case 'edit':
        controller.editPlaylist();
        break;
      case 'delete':
        _showDeleteConfirmDialog(Get.context!);
        break;
      case 'report':
        _reportTrackArticle();
        break;
      case 'block':
        _blockUser();
        break;
    }
  }

  void _reportTrackArticle() async {
    try {
      final trackArticle = controller.trackArticle.value;
      if (trackArticle == null) return;

      // SharedPreferences에서 신고한 게시물 확인
      final prefs = await SharedPreferences.getInstance();
      final reportedArticles =
          prefs.getStringList('reported_track_articles') ?? [];

      if (reportedArticles.contains(trackArticle.id)) {
        AppSnackbar.warning('이미 신고한 플레이리스트입니다.');
        return;
      }

      // TrackArticle을 Article로 변환하여 ReportBottomSheet에서 사용
      final article = Article(
        id: trackArticle.id,
        board_name: 'track_article',
        profile_uid: trackArticle.profile_uid,
        profile_name: trackArticle.profile_name,
        profile_photo_url: trackArticle.profile_photo_url ?? '',
        profile_point: trackArticle.profile_point,
        count_view: trackArticle.count_view,
        count_like: trackArticle.count_like,
        count_unlike: 0,
        count_comments: 0,
        title: trackArticle.title,
        contents: [],
        created_at: trackArticle.created_at,
        updated_at: trackArticle.updated_at,
        is_notice: false,
        thumbnail: '',
      );

      // 신고 bottom sheet 표시
      Get.bottomSheet(
        ReportBottomSheet(article: article),
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
      );
    } catch (e) {
      AppSnackbar.error('신고 처리 중 오류가 발생했습니다.');
    }
  }

  void _blockUser() async {
    try {
      final trackArticle = controller.trackArticle.value;
      if (trackArticle == null) return;

      // SharedPreferences에서 차단된 사용자 확인
      final prefs = await SharedPreferences.getInstance();
      final blockedUsers = prefs.getStringList('blocked_users') ?? [];

      if (blockedUsers.contains(trackArticle.profile_uid)) {
        AppSnackbar.warning('이미 차단된 사용자입니다.');
        return;
      }

      // TrackArticle을 Article로 변환하여 BlockBottomSheet에서 사용
      final article = Article(
        id: trackArticle.id,
        board_name: 'track_article',
        profile_uid: trackArticle.profile_uid,
        profile_name: trackArticle.profile_name,
        profile_photo_url: trackArticle.profile_photo_url ?? '',
        profile_point: trackArticle.profile_point,
        count_view: trackArticle.count_view,
        count_like: trackArticle.count_like,
        count_unlike: 0,
        count_comments: 0,
        title: trackArticle.title,
        contents: [],
        created_at: trackArticle.created_at,
        updated_at: trackArticle.updated_at,
        is_notice: false,
        thumbnail: '',
      );

      // 차단 확인 bottom sheet 표시
      Get.bottomSheet(
        BlockBottomSheet(article: article),
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
      );
    } catch (e) {
      AppSnackbar.error('차단 처리 중 오류가 발생했습니다.');
    }
  }
}
