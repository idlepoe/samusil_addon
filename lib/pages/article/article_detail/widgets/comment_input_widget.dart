import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samusil_addon/components/profile_avatar_widget.dart';
import 'package:samusil_addon/components/appButton.dart';
import 'package:samusil_addon/components/appCircularProgress.dart';

import '../article_detail_controller.dart';

class CommentInputWidget extends GetView<ArticleDetailController> {
  const CommentInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Column(
          children: [
            if (controller.subComment.value != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F8FF),
                  borderRadius: BorderRadius.circular(12),
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
                    GestureDetector(
                      onTap: () => controller.clearSubComment(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0064FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFF0064FF),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                ProfileAvatarWidget(
                  photoUrl: controller.profile.value.photo_url,
                  name: controller.profile.value.name,
                  size: 36,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: controller.commentController,
                      focusNode: controller.commentFocusNode,
                      decoration: InputDecoration(
                        hintText: "comment_input_hint".tr,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted:
                          controller.isCommentLoading.value
                              ? null
                              : (_) => controller.createComment(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap:
                      controller.isCommentLoading.value
                          ? null
                          : controller.createComment,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          controller.isCommentLoading.value
                              ? Colors.grey.shade300
                              : controller.isCommentEmpty.value
                              ? Colors.grey.shade300
                              : const Color(0xFF0064FF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child:
                        controller.isCommentLoading.value
                            ? const AppButtonProgress(
                              size: 20,
                              color: Colors.white,
                            )
                            : Icon(
                              Icons.send_rounded,
                              color:
                                  controller.isCommentEmpty.value
                                      ? Colors.grey.shade500
                                      : Colors.white,
                              size: 20,
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
