import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:samusil_addon/components/profile_avatar_widget.dart';
import 'package:samusil_addon/controllers/profile_controller.dart';
import 'package:samusil_addon/utils/util.dart';

import '../../../components/appBarAction.dart';
import '../../../components/bottomButton.dart';
import '../../../define/define.dart';
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
      bottomSheet: _buildWriteCommentSheet(context),
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
      actions: [],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(),
        const Divider(height: 1, color: Color(0xFFF0F0F0)),
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: Obx(
              () => ArticleListWidget(
                articles: controller.displayArticles,
                hasPicture: controller.hasPicture,
                hasNoContents: controller.hasNoContents,
              ),
            ),
          ),
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
                    controller.getSortTypeText(controller.currentSortType.value),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 20),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: 내 프로필 페이지로 이동
            },
            child: const Text('내 프로필', style: TextStyle(color: Colors.grey)),
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...SortType.values.map((sortType) => ListTile(
              title: Text(controller.getSortTypeText(sortType)),
              trailing: Obx(
                () => controller.currentSortType.value == sortType
                    ? const Icon(Icons.check, color: Color(0xFF0064FF))
                    : const SizedBox.shrink(),
              ),
              onTap: () {
                controller.changeSortType(sortType);
                Get.back();
              },
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
    );
  }

  Widget _buildWriteCommentSheet(BuildContext context) {
    final profileController = ProfileController.to;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // ArticleEditBinding의 의존성을 수동으로 주입
            final ArticleEditBinding binding = ArticleEditBinding(
              boardInfo: controller.boardInfo.value,
              articleId: null,
            );
            binding.dependencies();

            Get.bottomSheet(
              SafeArea(
                child: Container(
                  height: Get.height * 0.8,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    child: ArticleEditView(controller.boardInfo.value),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              enableDrag: true,
              isDismissible: true,
            ).whenComplete(() {
              // BottomSheet가 닫힐 때 컨트롤러 삭제
              Get.delete<ArticleEditController>();
            });
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(24),
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
                  child: Text(
                    '지금 무슨 생각을 하고 있나요?',
                    style: TextStyle(color: Colors.grey[600]),
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
