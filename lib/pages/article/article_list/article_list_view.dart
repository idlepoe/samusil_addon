import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:office_lounge/components/profile_avatar_widget.dart';
import 'package:office_lounge/controllers/profile_controller.dart';
import 'package:office_lounge/utils/util.dart';
import 'package:intl/intl.dart';

import '../../../components/appBarAction.dart';
import '../../../components/appCircularProgress.dart';
import '../../../components/bottomButton.dart';
import '../../../define/define.dart';
import '../../../define/arrays.dart';
import '../../../define/enum.dart';
import '../../../models/article.dart';
import '../../../models/board_info.dart';
import '../../../utils/util.dart';
import 'article_list_controller.dart';
import 'widgets/article_list_widget.dart';
import 'widgets/description_section_widget.dart';
import 'widgets/floating_write_button.dart';
import '../article_edit/article_edit_binding.dart';
import '../article_edit/article_edit_view.dart';
import '../article_edit/article_edit_controller.dart';

class ArticleListView extends GetView<ArticleListController> {
  const ArticleListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomSheet:
          _shouldShowWriteButton() ? _buildWriteCommentSheet(context) : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Obx(
        () => Text(
          controller.boardInfo.value.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      centerTitle: true,
      actions: [],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(),
        const Divider(height: 1, color: Color(0xFFF0F0F0)),
        Expanded(
          child: Obx(() {
            // 데이터가 로드되지 않았으면 로딩 인디케이터 표시
            if (!controller.isDataLoaded.value) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppCircularProgress.large(color: Color(0xFF0064FF)),
                    SizedBox(height: 16),
                    Text(
                      '게시글을 불러오고 있습니다...',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              );
            }

            // 데이터가 로드되면 RefreshIndicator와 함께 리스트 표시
            return RefreshIndicator(
              onRefresh: controller.onRefresh,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: _shouldShowWriteButton() ? 100.0 : 0.0,
                ),
                child:
                    controller.displayArticles.isEmpty
                        ? _buildEmptyState()
                        : ArticleListWidget(
                          articles: controller.displayArticles,
                          hasPicture: controller.hasPicture,
                          hasNoContents: controller.hasNoContents,
                        ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              _showSortOptions();
            },
            child: Obx(
              () => Row(
                children: [
                  Text(
                    controller.getSortTypeText(
                      controller.currentSortType.value,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '정렬',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...SortType.values.map(
              (sortType) => ListTile(
                title: Text(controller.getSortTypeText(sortType)),
                trailing: Obx(
                  () =>
                      controller.currentSortType.value == sortType
                          ? const Icon(Icons.check, color: Color(0xFF0064FF))
                          : const SizedBox.shrink(),
                ),
                onTap: () {
                  controller.changeSortType(sortType);
                  Get.back();
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
    );
  }

  bool _shouldShowWriteButton() {
    // BoardInfo의 isCanWrite 속성에 따라 글쓰기 버튼 표시 여부 결정
    return controller.boardInfo.value.isCanWrite;
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        const SizedBox(height: 100),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                '아직 게시글이 없습니다',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '첫 번째 게시글을 작성해보세요!',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWriteCommentSheet(BuildContext context) {
    final profileController = ProfileController.to;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            controller.navigateToWrite();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF0064FF).withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                ProfileAvatarWidget(
                  photoUrl: profileController.profileImageUrl,
                  name: profileController.userName,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '새 글 작성하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '지금 무슨 생각을 하고 있나요?',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0064FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    '작성하기',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
