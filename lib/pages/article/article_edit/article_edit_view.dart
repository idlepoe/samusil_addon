import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../../define/define.dart';
import '../../../models/board_info.dart';
import '../../../components/appButton.dart';
import '../../../components/appCircularProgress.dart';
import 'article_edit_controller.dart';
import '../article_list/article_list_controller.dart';
import '../../dash_board/dash_board_controller.dart';

class ArticleEditView extends GetView<ArticleEditController> {
  final String? id;
  final BoardInfo boardInfo;

  const ArticleEditView(this.boardInfo, {super.key, this.id});

  @override
  Widget build(BuildContext context) {
    // boardInfo를 컨트롤러에 직접 설정
    if (boardInfo != null) {
      controller.init(boardInfo);
    }

    // 일반 페이지로만 동작
    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드가 올라올 때 레이아웃 조정
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildBody(context)),
            _buildToolbar(), // body 안으로 이동
          ],
        ),
      ),
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
        id != null ? '글 수정' : '글쓰기',
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
                controller.isPressed.value
                    ? null
                    : () => controller.writeArticle(),
            child: Text(
              id != null ? '수정' : '완료',
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
              AppCircularProgress.large(color: Color(0xFF0064FF)),
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
          const SizedBox(height: 10),
          Expanded(child: _buildContentSection()), // Expanded로 감싸서 남은 공간 모두 사용
        ],
      );
    });
  }

  Widget _buildTitleSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Material(
        color: Colors.transparent,
        child: TextField(
          controller: controller.titleController,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          decoration: const InputDecoration(
            hintText: '(선택) 제목을 입력해주세요',
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
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: const Color(0xFFF0F0F0));
  }

  Widget _buildContentSection() {
    return Obx(
      () => ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.contentList.length,
        buildDefaultDragHandles: false,
        onReorder:
            controller.isReorderMode.value
                ? controller.reorderContent
                : (oldIndex, newIndex) {},
        itemBuilder: (context, index) {
          final content = controller.contentList[index];
          return _buildContentItem(content, index);
        },
        // 키보드가 표시되었을 때 스크롤 가능하도록 설정
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      ),
    );
  }

  Widget _buildContentItem(Contents content, int index) {
    Widget contentWidget = Container(
      key: ValueKey(index),
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          content.isPicture
              ? _buildImageContent(content, index)
              : _buildTextContent(content, index),
          // 삭제 버튼 (순서 변경 모드가 아닐 때만 표시)
          if (!controller.isReorderMode.value)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => controller.removeContent(index),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          // 드래그 핸들 (순서 변경 모드일 때만 표시)
          if (controller.isReorderMode.value)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF0064FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.drag_handle,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );

    // 순서 변경 모드일 때만 ReorderableDragStartListener로 감싸기
    if (controller.isReorderMode.value) {
      return ReorderableDragStartListener(
        key: ValueKey(index),
        index: index,
        child: contentWidget,
      );
    } else {
      return contentWidget;
    }
  }

  Widget _buildTextContent(Contents content, int index) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: TextField(
          controller: content.textEditingController,
          focusNode: content.focusNode,
          enabled: !controller.isReorderMode.value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            height: 1.5,
          ),
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: '내용을 입력하세요...',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent(Contents content, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image(
        image: content.picture!,
        width: double.infinity,
        fit: BoxFit.fitWidth, // fit width로 변경하여 화면 너비에 맞추고 비율 유지
      ),
    );
  }

  Widget _buildToolbar() {
    return Builder(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final keyboardHeight = mediaQuery.viewInsets.bottom;

        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom:
                16 +
                (keyboardHeight > 0
                    ? 0
                    : mediaQuery.padding.bottom), // 키보드가 있으면 SafeArea 패딩 제거
          ),
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
      },
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
    return Obx(
      () => GestureDetector(
        onTap: controller.toggleReorderMode,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                controller.isReorderMode.value
                    ? const Color(0xFF0064FF)
                    : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.drag_handle,
            color: controller.isReorderMode.value ? Colors.white : Colors.grey,
            size: 20,
          ),
        ),
      ),
    );
  }
}
