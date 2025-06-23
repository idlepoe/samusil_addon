import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../components/appCircularProgress.dart';
import '../../../models/track_article.dart';
import '../dash_board_controller.dart';

class FavoritePlaylistsWidget extends StatelessWidget {
  final DashBoardController controller;
  final logger = Logger();

  FavoritePlaylistsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingFavoritePlaylists.value) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: AppCircularProgress()),
          ),
        );
      }

      if (controller.favoritePlaylists.isEmpty) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: Colors.grey[600],
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '즐겨찾기한 플레이리스트가 없습니다',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '마음에 드는 플레이리스트를 즐겨찾기해보세요!',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 섹션 헤더
            InkWell(
              onTap: () {
                Get.toNamed('/favorite-playlist');
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE91E63), // 핑크색
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "즐겨찾기",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191F28),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "더보기",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
            // 플레이리스트 목록
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              child: Column(
                children:
                    controller.favoritePlaylists
                        .map((playlist) => _buildPlaylistItem(playlist))
                        .toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPlaylistItem(TrackArticle playlist) {
    return InkWell(
      onTap: () {
        Get.toNamed('/track-article-detail', arguments: {'id': playlist.id});
      },
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            // 간단한 음악 아이콘
            Icon(Icons.music_note, color: const Color(0xFFE91E63), size: 18),
            const SizedBox(width: 8),
            // 플레이리스트 정보
            Expanded(
              child: Text(
                playlist.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF191F28),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // 곡 수
            Text(
              '${playlist.tracks.length}곡',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
            const SizedBox(width: 8),
            // 간단한 재생 버튼
            InkWell(
              onTap: () {
                controller.playPlaylist(playlist);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Color(0xFFE91E63),
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
