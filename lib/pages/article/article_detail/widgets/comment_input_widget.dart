import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../article_detail_controller.dart';

class CommentInputWidget extends GetView<ArticleDetailController> {
  const CommentInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Column(
          children: [
            if (controller.subComment.value != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF0064FF), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.reply, color: Color(0xFF0064FF), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${controller.subComment.value!.profile_name}님에게 답글",
                        style: const TextStyle(
                          color: Color(0xFF0064FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF0064FF),
                        size: 16,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => controller.clearSubComment(),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.commentController,
                    decoration: InputDecoration(
                      hintText: "comment_input_hint".tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF0064FF)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => controller.createComment(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed:
                      controller.commentController.text.trim().isEmpty
                          ? null
                          : controller.createComment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0064FF),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "comment_send".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
