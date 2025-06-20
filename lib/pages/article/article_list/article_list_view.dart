import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';

import '../../../components/appBarAction.dart';
import '../../../components/bottomButton.dart';
import '../../../define/define.dart';
import '../../../models/article.dart';
import '../../../models/board_info.dart';
import '../../../utils/util.dart';
import 'article_list_controller.dart';

class ArticleListView extends GetView<ArticleListController> {
  const ArticleListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomSheet: _buildBottomSheet(context),
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
      actions: AppBarAction(context, controller.profile.value),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildDescriptionSection(),
              _buildDivider(),
              _buildArticleList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Obx(
        () => Text(
          controller.boardInfo.value.description.tr,
          style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: const Color(0xFFF0F0F0));
  }

  Widget _buildArticleList() {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.displayArticles.length,
        itemBuilder: (context, index) {
          final article = controller.displayArticles[index];
          return _buildArticleItem(article, index);
        },
      ),
    );
  }

  Widget _buildArticleItem(Article article, int index) {
    final hasPicture = controller.hasPicture(article);
    final hasNoContents = controller.hasNoContents(article);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            Get.toNamed("/detail/${article.id}");
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildArticleTitle(article, hasPicture, hasNoContents),
                const SizedBox(height: 8),
                _buildArticleMeta(article),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleTitle(
    Article article,
    bool hasPicture,
    bool hasNoContents,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasPicture) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF0064FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('🖼', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            article.title + (hasNoContents ? " (${"no_contents".tr})" : ""),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (article.count_comments > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF0064FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${article.count_comments}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildArticleMeta(Article article) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "${article.profile_name} • ${"count_view".tr} ${article.count_view} • ${"recommend".tr} ${article.count_like}",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        Text(
          Utils.toConvertFireDateToCommentTimeToday(
            DateFormat('yyyyMMddHHmm').format(article.created_at),
          ),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      height: Define.BOTTOM_SHEET_HEIGHT,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFF0F0F0), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomButton(
            icon: LineIcons.home,
            label: "dash_board".tr,
            onTap: controller.navigateToDashboard,
          ),
          _buildBottomButton(
            icon: Icons.search,
            label: "search".tr,
            onTap: controller.navigateToSearch,
          ),
          _buildBottomButton(
            icon: LineIcons.pen,
            label: "write".tr,
            onTap: controller.navigateToEdit,
            disabled: !controller.canWrite,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool disabled = false,
  }) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: disabled ? Colors.grey : const Color(0xFF0064FF),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: disabled ? Colors.grey : const Color(0xFF0064FF),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
