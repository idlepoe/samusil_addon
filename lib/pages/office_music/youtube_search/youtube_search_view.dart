import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../../models/youtube/track.dart';
import 'youtube_search_controller.dart';

class YouTubeSearchView extends GetView<YouTubeSearchController> {
  const YouTubeSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '음악 검색',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            if (controller.selectedTracks.isEmpty) {
              return const SizedBox.shrink();
            }

            return controller.isLoading.value
                ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF0064FF),
                      ),
                    ),
                  ),
                )
                : TextButton(
                  onPressed: controller.confirmSelection,
                  child: Text(
                    '완료 (${controller.selectedTracks.length})',
                    style: const TextStyle(
                      color: Color(0xFF0064FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
          }),
        ],
      ),
      body: Column(
        children: [_buildSearchBar(), Expanded(child: _buildSearchResults())],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF0064FF).withOpacity(0.1),
                ),
              ),
              child: TextField(
                controller: controller.searchController,
                decoration: const InputDecoration(
                  hintText: '검색할 음악을 입력하세요',
                  prefixIcon: Icon(LineIcons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (query) => controller.searchYouTube(query),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0064FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed:
                  () => controller.searchYouTube(
                    controller.searchController.text,
                  ),
              icon: const Icon(LineIcons.search, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Obx(() {
      if (controller.isLoading.value) {
        // 선택된 트랙이 있으면 duration 가져오는 중, 없으면 검색 중
        final isProcessingDuration = controller.selectedTracks.isNotEmpty;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0064FF)),
              ),
              const SizedBox(height: 16),
              Text(isProcessingDuration ? '음악 정보를 가져오는 중...' : '음악을 검색하는 중...'),
              if (isProcessingDuration) ...[
                const SizedBox(height: 8),
                Text(
                  '영상 길이를 확인하고 있습니다',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ],
          ),
        );
      }

      if (controller.searchResults.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF0064FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  LineIcons.music,
                  size: 40,
                  color: Color(0xFF0064FF),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '검색 결과가 없습니다',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '다른 검색어로 시도해보세요',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.searchResults.length,
        itemBuilder: (context, index) {
          final track = controller.searchResults[index];

          return Obx(() {
            final isSelected = controller.isTrackSelected(track);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFF0064FF) : Colors.grey[200]!,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image:
                        track.thumbnail.isNotEmpty
                            ? DecorationImage(
                              image: NetworkImage(track.thumbnail),
                              fit: BoxFit.cover,
                            )
                            : null,
                    color: track.thumbnail.isEmpty ? Colors.grey[300] : null,
                  ),
                  child:
                      track.thumbnail.isEmpty
                          ? const Icon(LineIcons.music, color: Colors.grey)
                          : null,
                ),
                title: Text(
                  track.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle:
                    track.description.isNotEmpty
                        ? Text(
                          track.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                        : null,
                trailing: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isSelected
                            ? const Color(0xFF0064FF)
                            : Colors.transparent,
                    border: Border.all(
                      color:
                          isSelected
                              ? const Color(0xFF0064FF)
                              : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child:
                      isSelected
                          ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          )
                          : null,
                ),
                onTap: () => controller.toggleTrackSelection(track),
              ),
            );
          });
        },
      );
    });
  }
}
