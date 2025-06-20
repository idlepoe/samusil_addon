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
        // More Options Button
        SizedBox(
          width: 40,
          height: 40,
          child: PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz, color: Colors.grey[600]),
            onSelected: (value) {
              _handleMenuAction(value);
            },
            itemBuilder:
                (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share, size: 18),
                        SizedBox(width: 8),
                        Text('공유'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'block',
                    child: Row(
                      children: [
                        Icon(Icons.block, size: 18),
                        SizedBox(width: 8),
                        Text('차단'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'report',
                    child: Row(
                      children: [
                        Icon(Icons.report, size: 18),
                        SizedBox(width: 8),
                        Text('신고'),
                      ],
                    ),
                  ),
                ],
          ),
        ),
      ],
    );
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'share':
        _shareArticle();
        break;
      case 'block':
        _blockUser();
        break;
      case 'report':
        _reportArticle();
        break;
    }
  }

  void _shareArticle() {
    // 공유 기능 구현
    Get.snackbar(
      '공유',
      '게시글을 공유합니다.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _blockUser() {
    // 차단 기능 구현
    Get.snackbar(
      '차단',
      '사용자를 차단합니다.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void _reportArticle() {
    // 신고 기능 구현
    Get.snackbar(
      '신고',
      '게시글을 신고합니다.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
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
