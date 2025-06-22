import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:office_lounge/utils/app.dart';
import 'package:office_lounge/utils/util.dart';
import 'package:office_lounge/components/profile_badge_widget.dart';
import 'package:office_lounge/components/profile_avatar_widget.dart';
import 'package:office_lounge/components/article_image_widget.dart';
import 'package:office_lounge/components/article_menu_widget.dart';

import '../../../../models/article.dart';

class ArticleItemWidget extends StatelessWidget {
  final Article article;

  const ArticleItemWidget({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    // contents 배열의 순서대로 최대 2건을 가져옴
    final displayContents = article.contents.take(2).toList();

    // 전체 이미지 개수 계산 (추가 이미지 개수 표시용)
    final totalImageCount = article.contents.where((c) => c.isPicture).length;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Get.toNamed('/detail/${article.id}');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 12),
              // Title
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Contents (순서대로 1번, 2번 표시)
              ...displayContents.asMap().entries.map((entry) {
                final index = entry.key;
                final content = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    if (content.isPicture)
                      // 이미지 콘텐츠
                      ArticleImageWidget(
                        imageUrl: content.contents,
                        width: double.infinity,
                        height: 200,
                        borderRadius: BorderRadius.circular(8),
                        showLoadingIndicator: false,
                        additionalImageCount:
                            index == 0 && totalImageCount > 1
                                ? totalImageCount - 1
                                : null,
                      )
                    else
                      // 텍스트 콘텐츠
                      Text(
                        content.contents,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                  ],
                );
              }).toList(),
              const SizedBox(height: 12),
              // Actions
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Profile Image
        ProfileAvatarWidget(
          photoUrl: article.profile_photo_url,
          name: article.profile_name,
          size: 40,
        ),
        const SizedBox(width: 8),
        // Name and Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    article.profile_name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ProfileBadgeWidget(point: article.profile_point ?? 0),
                ],
              ),
              Text(
                Utils.toConvertFireDateToCommentTimeToday(
                  DateFormat('yyyyMMddHHmm').format(article.created_at),
                ),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        // More Options Button
        SizedBox(
          width: 40,
          height: 40,
          child: ArticleMenuWidget(
            article: article,
            isAuthor: false, // 목록에서는 일반적으로 작성자 여부를 확인하지 않음
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        _buildActionIcon(LineIcons.heart, article.count_like.toString()),
        const SizedBox(width: 16),
        _buildActionIcon(LineIcons.comment, article.count_comments.toString()),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(count, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }
}
