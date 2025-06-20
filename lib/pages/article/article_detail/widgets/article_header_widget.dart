import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:samusil_addon/utils/app.dart';

import '../../../../utils/util.dart';
import '../article_detail_controller.dart';

class ArticleHeaderWidget extends GetView<ArticleDetailController> {
  const ArticleHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            child: App.buildCoinIcon(
              controller.article.value.profile_name,
              size: 44,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.article.value.profile_name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Utils.toConvertFireDateToCommentTimeToday(
                    DateFormat(
                      'yyyyMMddHHmm',
                    ).format(controller.article.value.created_at),
                  ),
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
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
                items.add(const PopupMenuDivider());
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
      ),
    );
  }

  Widget _buildBadge() {
    final profile = controller.profile.value;
    final totalCoinValue = profile.coin_balance.fold<double>(
      0,
      (sum, balance) => sum + (balance.quantity * balance.price),
    );

    String text;
    Color backgroundColor;
    Color textColor;

    if (totalCoinValue > 1000000) {
      text = '고래';
      backgroundColor = Colors.blue.shade100;
      textColor = Colors.blue.shade800;
    } else if (profile.point > 10000) {
      text = '부자';
      backgroundColor = Colors.amber.shade100;
      textColor = Colors.amber.shade800;
    } else {
      text = '새싹';
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
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
        // controller.blockUser();
        Get.snackbar('알림', '차단 기능은 준비중입니다.');
        break;
      case 'report':
        // controller.reportArticle();
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
}
