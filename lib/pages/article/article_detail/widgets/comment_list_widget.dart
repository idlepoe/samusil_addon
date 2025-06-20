import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';

import '../../../../utils/util.dart';
import '../article_detail_controller.dart';

class CommentListWidget extends GetView<ArticleDetailController> {
  const CommentListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: List.generate(controller.comments.length, (index) {
        final comment = controller.comments[index];
        return _buildCommentItem(comment, index);
      }),
    ));
  }

  Widget _buildCommentItem(comment, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    comment.profile_name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              if (controller.canDeleteComment(comment))
                IconButton(
                  icon: const Icon(LineIcons.trash, size: 16, color: Colors.red),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _showCommentDeleteDialog(comment),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.contents,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Utils.toConvertFireDateToCommentTime(
                  DateFormat('yyyyMMddHHmm').format(comment.created_at),
                  bYear: true,
                ),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              TextButton(
                onPressed: () => controller.setSubComment(comment),
                child: Text(
                  "답글",
                  style: const TextStyle(
                    color: Color(0xFF0064FF),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCommentDeleteDialog(comment) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text("comment_delete_confirm".tr),
        content: Text("comment_delete_confirm_description".tr),
        actions: [
          CupertinoDialogAction(
            onPressed: () async {
              Get.back();
              await controller.deleteComment(comment);
            },
            isDestructiveAction: true,
            child: Text("yes".tr),
          ),
          CupertinoDialogAction(
            onPressed: () => Get.back(),
            child: Text("no".tr),
          ),
        ],
      ),
    );
  }
} 