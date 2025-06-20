import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../../define/define.dart';
import '../../../models/board_info.dart';
import 'article_edit_controller.dart';

class ArticleEditView extends GetView<ArticleEditController> {
  final String? articleKey;
  final BoardInfo? boardInfo;

  const ArticleEditView({super.key, this.articleKey, this.boardInfo});

  @override
  Widget build(BuildContext context) {
    // 컨트롤러에 파라미터 전달
    final controller = ArticleEditController(articleKey: articleKey);
    Get.lazyPut(() => controller);

    // boardInfo를 컨트롤러에 직접 설정
    if (boardInfo != null) {
      controller.init(boardInfo!);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
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
      title: Text(
        '글쓰기',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        Obx(
          () => TextButton(
            onPressed:
                controller.isPressed.value ? null : controller.writeArticle,
            child: Text(
              '완료',
              style: TextStyle(
                color:
                    controller.isPressed.value
                        ? Colors.grey
                        : const Color(0xFF0064FF),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (controller.isPressed.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0064FF)),
              ),
              SizedBox(height: 16),
              Text(
                '글을 작성하고 있습니다...',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          _buildTitleSection(),
          _buildDivider(),
          Expanded(child: _buildContentSection()),
          _buildToolbar(),
        ],
      );
    });
  }

  Widget _buildTitleSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: controller.titleController,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        decoration: const InputDecoration(
          hintText: '제목을 입력하세요',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [LengthLimitingTextInputFormatter(50)],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: const Color(0xFFF0F0F0));
  }

  Widget _buildContentSection() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: controller.contentList.length,
      onReorder: controller.reorderContent,
      itemBuilder: (context, index) {
        final content = controller.contentList[index];
        return _buildContentItem(content, index);
      },
    );
  }

  Widget _buildContentItem(Contents content, int index) {
    return Container(
      key: ValueKey(index),
      margin: const EdgeInsets.only(bottom: 16),
      child:
          content.isPicture
              ? _buildImageContent(content, index)
              : _buildTextContent(content, index),
    );
  }

  Widget _buildTextContent(Contents content, int index) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: content.textEditingController,
        focusNode: content.focusNode,
        style: const TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          hintText: '내용을 입력하세요...',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildImageContent(Contents content, int index) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(image: content.picture!, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => controller.removeContent(index),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFF0F0F0), width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildToolbarButton(
            icon: LineIcons.font,
            label: '텍스트',
            onTap: controller.addTextContent,
          ),
          const SizedBox(width: 16),
          _buildToolbarButton(
            icon: LineIcons.image,
            label: '이미지',
            onTap: controller.addImageContent,
          ),
          const Spacer(),
          _buildReorderButton(),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: const Color(0xFF0064FF)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF0064FF),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReorderButton() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.drag_handle, color: Colors.grey, size: 20),
    );
  }
}
