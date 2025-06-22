import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../article_detail_controller.dart';

class ActionButtonsWidget extends GetView<ArticleDetailController> {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            _buildLikeButton(),
            const SizedBox(width: 16),
            _buildActionIcon(
              LineIcons.comment,
              controller.article.value.count_comments.toString(),
            ),
            const Spacer(),
            Text(
              "조회 ${controller.article.value.count_view}",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikeButton() {
    return GestureDetector(
      onTap: controller.toggleLike,
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child:
                controller.isLiked.value
                    ? TweenAnimationBuilder<double>(
                      key: const ValueKey('filled_heart'),
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.8 + (value * 0.2),
                          child: Icon(
                            Icons.favorite,
                            size: 20,
                            color: Colors.red.withOpacity(value),
                          ),
                        );
                      },
                    )
                    : Icon(
                      key: const ValueKey('empty_heart'),
                      LineIcons.heart,
                      size: 20,
                      color: Colors.grey[600],
                    ),
          ),
          const SizedBox(width: 6),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: controller.isLiked.value ? Colors.red : Colors.grey[600],
              fontSize: 14,
            ),
            child: Text(controller.article.value.count_like.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(count, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }
}
