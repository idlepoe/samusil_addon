import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/appCircularProgress.dart';
import '../../../define/define.dart';
import 'article_detail_controller.dart';
import 'widgets/article_header_widget.dart';
import 'widgets/article_content_widget.dart';
import 'widgets/action_buttons_widget.dart';
import 'widgets/comment_section_widget.dart';
import 'widgets/comment_input_widget.dart';

class ArticleDetailView extends GetView<ArticleDetailController> {
  const ArticleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AppCircularProgress.large());
        }
        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ArticleHeaderWidget(),
                          const SizedBox(height: 16),
                          const ArticleContentWidget(),
                          const SizedBox(height: 24),
                          const ActionButtonsWidget(),
                        ],
                      ),
                    ),
                  ),
                  const CommentSectionWidget(),
                ],
              ),
            ),
            _buildEmojiBar(),
            const CommentInputWidget(),
          ],
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FA),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
        onPressed: () => Get.back(),
      ),
      title: Text(
        controller.boardInfo.value.title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
      actions: [_buildMoreMenuButton()],
    );
  }

  Widget _buildMoreMenuButton() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.black87),
      onSelected: (value) => _handleMenuAction(value),
      itemBuilder: (BuildContext context) {
        final List<PopupMenuItem<String>> items = [];

        // 공통 메뉴 (공유)
        items.add(_buildPopupMenuItem('share', '공유하기', Icons.share_outlined));

        // 작성자가 아닌 경우 신고하기 메뉴 추가
        if (!controller.isAuthor) {
          items.add(
            _buildPopupMenuItem(
              'report',
              '신고하기',
              Icons.report_outlined,
              isDestructive: true,
            ),
          );
        }

        // 작성자인 경우에만 수정, 삭제 메뉴 추가
        if (controller.isAuthor) {
          items.add(_buildPopupMenuItem('edit', '수정하기', Icons.edit_outlined));
          items.add(
            _buildPopupMenuItem(
              'delete',
              '삭제하기',
              Icons.delete_outline,
              isDestructive: true,
            ),
          );
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
        controller.shareArticle();
        break;
      case 'report':
        _showReportConfirmDialog();
        break;
      case 'edit':
        controller.editArticle();
        break;
      case 'delete':
        _showDeleteConfirmDialog();
        break;
    }
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: Get.context!,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              '게시글 삭제',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            content: const Text(
              '정말로 이 게시글을 삭제하시겠습니까?\n삭제된 게시글은 복구할 수 없습니다.',
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
                  controller.deleteArticle();
                },
                child: const Text('삭제', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _showReportConfirmDialog() {
    showDialog(
      context: Get.context!,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              '게시글 신고',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            content: const Text(
              '이 게시글이 부적절한 내용을 포함하고 있다고 신고하시겠습니까?\n신고는 취소할 수 없습니다.',
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
                  controller.reportArticle();
                },
                child: const Text('신고', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  Widget _buildEmojiBar() {
    final emojis = [
      '😊',
      '👍',
      '❤️',
      '😂',
      '😮',
      '😢',
      '😡',
      '🎉',
      '🔥',
      '💯',
      '✨',
      '🚀',
      '💪',
      '👏',
      '🙌',
      '💖',
    ];

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: emojis.length,
        itemBuilder: (context, index) {
          final emoji = emojis[index];
          return GestureDetector(
            onTap: () => controller.addEmojiToComment(emoji),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
          );
        },
      ),
    );
  }
}
