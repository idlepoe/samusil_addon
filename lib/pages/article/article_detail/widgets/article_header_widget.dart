import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:office_lounge/utils/app.dart';
import 'package:office_lounge/components/profile_badge_widget.dart';
import 'package:office_lounge/components/profile_avatar_widget.dart';

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
      ],
    );
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
