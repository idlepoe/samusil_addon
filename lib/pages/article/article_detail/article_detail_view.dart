import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../define/define.dart';
import 'article_detail_controller.dart';
import 'widgets/article_header_widget.dart';
import 'widgets/article_content_widget.dart';
import 'widgets/action_buttons_widget.dart';
import 'widgets/delete_button_widget.dart';
import 'widgets/comment_section_widget.dart';
import 'widgets/comment_input_widget.dart';

class ArticleDetailView extends GetView<ArticleDetailController> {
  const ArticleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomSheet: const CommentInputWidget(),
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
          controller.boardInfo.value.title.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: controller.shareArticle,
          icon: const Icon(Icons.share, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0064FF)),
              ),
              SizedBox(height: 16),
              Text(
                '게시글을 불러오는 중...',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: ClampingScrollPhysics(),
        ),
        child: Column(
          children: [
            const ArticleHeaderWidget(),
            const ArticleContentWidget(),
            const ActionButtonsWidget(),
            if (controller.canDelete) const DeleteButtonWidget(),
            const CommentSectionWidget(),
            const SizedBox(height: Define.BOTTOM_SHEET_HEIGHT - 15),
          ],
        ),
      );
    });
  }
}
