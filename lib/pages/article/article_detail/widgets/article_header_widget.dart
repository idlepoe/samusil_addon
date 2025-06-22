import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:samusil_addon/utils/app.dart';
import 'package:samusil_addon/components/profile_badge_widget.dart';
import 'package:samusil_addon/components/profile_avatar_widget.dart';

import '../../../../utils/util.dart';
import '../article_detail_controller.dart';

class ArticleHeaderWidget extends GetView<ArticleDetailController> {
  const ArticleHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 프로필 이미지
        ProfileAvatarWidget(
          photoUrl: controller.article.value.profile_photo_url,
          name: controller.article.value.profile_name,
          size: 48,
        ),
        const SizedBox(width: 12),
        // 유저 정보
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    controller.article.value.profile_name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  ProfileBadgeWidget(
                    point: controller.article.value.profile_point ?? 0,
                    fontSize: 12,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                _buildDateText(),
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
        // 더보기 버튼
        PopupMenuButton<String>(
          icon: Icon(Icons.more_horiz, color: Colors.grey[600]),
          onSelected: (value) => _handleMenuAction(value),
          itemBuilder: (BuildContext context) {
            final List<PopupMenuItem<String>> items = [];
            items.add(
              _buildPopupMenuItem('share', '공유하기', Icons.share_outlined),
            );
            items.add(
              _buildPopupMenuItem('report', '신고하기', Icons.report_outlined),
            );

            if (controller.isAuthor) {
              items.add(
                _buildPopupMenuItem('edit', '수정하기', Icons.edit_outlined),
              );
              items.add(
                _buildPopupMenuItem(
                  'delete',
                  '삭제하기',
                  Icons.delete_outline,
                  isDestructive: true,
                ),
              );
            } else {
              items.add(_buildPopupMenuItem('block', '차단하기', Icons.block));
            }
            return items;
          },
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String value,
    String text,
    IconData icon, {
    bool isDestructive = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isDestructive ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'share':
        controller.shareArticle();
        break;
      case 'block':
        Get.snackbar('알림', '차단 기능은 준비중입니다.');
        break;
      case 'report':
        Get.snackbar('알림', '신고 기능은 준비중입니다.');
        break;
      case 'edit':
        controller.editArticle();
        break;
      case 'delete':
        controller.deleteArticle();
        break;
    }
  }

  String _buildDateText() {
    final createdAt = controller.article.value.created_at;
    final updatedAt = controller.article.value.updated_at;
    final dateFormat = DateFormat('yyyyMMddHHmm');
    if (updatedAt != null && !createdAt.isAtSameMomentAs(updatedAt)) {
      return "${Utils.toConvertFireDateToCommentTime(dateFormat.format(updatedAt))} (수정됨)";
    } else {
      return Utils.toConvertFireDateToCommentTime(dateFormat.format(createdAt));
    }
  }
}
