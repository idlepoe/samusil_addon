import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
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
          Row(
            children: const [
              Text('최신순', style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_downward, size: 16),
            ],
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
            final ArticleEditBinding binding = ArticleEditBinding();
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
                CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      Utils.isValidNilEmptyStr(
                            profileController.profileImageUrl,
                          )
                          ? NetworkImage(profileController.profileImageUrl)
                          : const AssetImage('assets/anon_icon.jpg')
                              as ImageProvider,
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
