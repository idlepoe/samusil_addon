import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../article_detail_controller.dart';

class ActionButtonsWidget extends GetView<ArticleDetailController> {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.thumb_up,
            label: "${"like".tr} ${controller.article.value.count_like}",
            onPressed: controller.isPressed.value || controller.isAlreadyVote.value
                ? null
                : controller.likeArticle,
            color: const Color(0xFF0064FF),
          ),
          _buildActionButton(
            icon: Icons.thumb_down,
            label: "${"unlike".tr} ${controller.article.value.count_unlike}",
            onPressed: controller.isPressed.value || controller.isAlreadyVote.value
                ? null
                : controller.unlikeArticle,
            color: Colors.grey,
          ),
        ],
      ),
    ));
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton.icon(
          icon: Icon(icon, color: onPressed == null ? Colors.grey : Colors.white),
          label: Text(
            label,
            style: TextStyle(
              color: onPressed == null ? Colors.grey : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: onPressed == null ? Colors.grey.shade200 : color,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
} 