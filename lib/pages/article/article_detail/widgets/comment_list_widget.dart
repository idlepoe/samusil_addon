import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';
import 'package:samusil_addon/models/main_comment.dart';
import 'package:samusil_addon/components/profile_avatar_widget.dart';
import 'package:samusil_addon/components/profile_badge_widget.dart';

import '../../../../utils/util.dart';
import '../article_detail_controller.dart';

class CommentListWidget extends GetView<ArticleDetailController> {
  const CommentListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: List.generate(controller.comments.length, (index) {
          final comment = controller.comments[index];
          return _buildCommentItem(comment, index);
        }),
      ),
    );
  }

  Widget _buildCommentItem(MainComment comment, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 이미지
          ProfileAvatarWidget(
            photoUrl: comment.profile_photo_url,
            name: comment.profile_name,
            size: 40,
          ),
          const SizedBox(width: 12),
          // 댓글 내용
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 유저 정보 및 더보기 버튼
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      comment.profile_name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ProfileBadgeWidget(
                      point: comment.profile_point ?? 0,
                      fontSize: 10,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      Utils.toConvertFireDateToCommentTime(
                        DateFormat('yyyyMMddHHmm')
                            .format(comment.created_at ?? DateTime.now()),
                      ),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    _buildMoreButton(comment),
                  ],
                ),
                const SizedBox(height: 4),
                // 댓글 텍스트
                Text(
                  comment.contents,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 12),
                // 좋아요 및 답글
                Row(
                  children: [
                    Icon(LineIcons.heart, size: 20, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('0', style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => controller.setSubComment(comment),
                      child: Row(
                        children: [
                          Icon(LineIcons.arrowLeft,
                              size: 20, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('답글 달기',
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreButton(MainComment comment) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'report') {
          // 신고 로직
        } else if (value == 'block') {
          // 차단 로직
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'report',
          child: Row(
            children: [
              Icon(Icons.report_gmailerrorred, size: 20),
              SizedBox(width: 8),
              Text('신고'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'block',
          child: Row(
            children: [
              Icon(Icons.block, size: 20),
              SizedBox(width: 8),
              Text('차단'),
            ],
          ),
        ),
      ],
      child: const Icon(Icons.more_horiz, color: Colors.grey),
    );
  }
}
