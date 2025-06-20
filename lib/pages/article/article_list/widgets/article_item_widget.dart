import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:samusil_addon/utils/app.dart';
import 'package:samusil_addon/utils/util.dart';

import '../../../../models/article.dart';

class ArticleItemWidget extends StatelessWidget {
  final Article article;

  const ArticleItemWidget({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    String articleText = article.title;
    final firstTextContent = article.contents.firstWhereOrNull(
      (c) => !c.isPicture,
    );
    if (firstTextContent != null) {
      articleText += '\n${firstTextContent.contents}';
    }

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
              // Content
              Text(articleText, maxLines: 5, overflow: TextOverflow.ellipsis),
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
        CircleAvatar(
          radius: 20,
          child: App.buildCoinIcon(article.profile_name, size: 40),
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
                  _buildBadge("인플루언서"),
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
        // Follow Button
        TextButton(
          onPressed: () {},
          child: const Text(
            '팔로우',
            style: TextStyle(
              color: Color(0xFF0064FF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.amber[800],
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        _buildActionIcon(LineIcons.heart, article.count_like.toString()),
        const SizedBox(width: 16),
        _buildActionIcon(LineIcons.comment, article.count_comments.toString()),
        const SizedBox(width: 16),
        _buildActionIcon(LineIcons.retweet, '0'), // Assuming no retweet count
        const Spacer(),
        Icon(Icons.more_horiz, color: Colors.grey[600]),
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
