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
        controller.boardInfo.value.title.tr,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
      actions: [],
    );
  }

  Widget _buildEmojiBar() {
    final emojis = ['😊', '👍', '❤️', '😂', '😮', '😢', '😡', '🎉'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children:
            emojis.map((emoji) {
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
            }).toList(),
      ),
    );
  }
}
