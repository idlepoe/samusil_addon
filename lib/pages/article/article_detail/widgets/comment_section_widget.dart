import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../article_detail_controller.dart';
import 'comment_list_widget.dart';

class CommentSectionWidget extends GetView<ArticleDetailController> {
  const CommentSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(
        () => Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200, width: 1),
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    "${"comment".tr} ${controller.article.value.count_comments}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const CommentListWidget(),
          ],
        ),
      ),
    );
  }
}
