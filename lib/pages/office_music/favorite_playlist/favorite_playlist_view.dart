import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/appCircularProgress.dart';
import '../../../models/track_article.dart';
import 'favorite_playlist_controller.dart';

class FavoritePlaylistView extends GetView<FavoritePlaylistController> {
  const FavoritePlaylistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '즐겨찾기',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AppCircularProgress());
        }

        if (controller.favoritePlaylists.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: const Color(0xFF3182F6),
          onRefresh: controller.onRefresh,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.favoritePlaylists.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final playlist = controller.favoritePlaylists[index];
              return _buildPlaylistItem(playlist);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F6),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.bookmark_border,
              size: 40,
              color: Color(0xFF8B95A1),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '즐겨찾기한 플레이리스트가 없습니다',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '마음에 드는 플레이리스트를 즐겨찾기에 추가해보세요',
            style: TextStyle(fontSize: 14, color: Color(0xFF8B95A1)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistItem(TrackArticle playlist) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => controller.goToPlaylistDetail(playlist),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 플레이리스트 썸네일
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
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF3182F6),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.music_note,
                                size: 24,
                                color: Color(0xFF8B95A1),
                              );
                            },
                          )
                          : const Icon(
                            Icons.music_note,
                            size: 24,
                            color: Color(0xFF8B95A1),
                          ),
                ),
              ),

              const SizedBox(width: 16),

              // 플레이리스트 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${playlist.track_count}곡 • ${controller.formatTotalDuration(playlist.total_duration)} • ${playlist.profile_name}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8B95A1),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.visibility,
                          size: 12,
                          color: Color(0xFF8B95A1),
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
                        const Icon(
                          Icons.favorite,
                          size: 12,
                          color: Color(0xFF8B95A1),
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
                          controller.formatRelativeTime(playlist.created_at),
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

              const SizedBox(width: 12),

              // 즐겨찾기 제거 버튼
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showRemoveDialog(playlist),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.bookmark,
                      size: 20,
                      color: Color(0xFF3182F6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRemoveDialog(TrackArticle playlist) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          '즐겨찾기 제거',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Text(
          '"${playlist.title}"을(를) 즐겨찾기에서 제거하시겠습니까?',
          style: const TextStyle(fontSize: 14, color: Color(0xFF4E5968)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('취소', style: TextStyle(color: Color(0xFF8B95A1))),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.removeFavorite(playlist);
            },
            child: const Text(
              '제거',
              style: TextStyle(
                color: Color(0xFF3182F6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
