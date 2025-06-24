import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';
import 'appSnackbar.dart';
import 'report_bottom_sheet.dart';
import 'block_bottom_sheet.dart';

class ArticleMenuWidget extends StatelessWidget {
  final Article article;
  final bool isAuthor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ArticleMenuWidget({
    super.key,
    required this.article,
    this.isAuthor = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, color: Colors.grey[600]),
      onSelected: (value) => _handleMenuAction(value),
      itemBuilder: (BuildContext context) {
        final List<PopupMenuItem<String>> items = [];

        // 공유하기는 항상 표시
        items.add(_buildPopupMenuItem('share', '공유하기', Icons.share_outlined));

        // 작성자인 경우
        if (isAuthor) {
          if (onEdit != null) {
            items.add(_buildPopupMenuItem('edit', '수정하기', Icons.edit_outlined));
          }
          if (onDelete != null) {
            items.add(
              _buildPopupMenuItem(
                'delete',
                '삭제하기',
                Icons.delete_outline,
                isDestructive: true,
              ),
            );
          }
        } else {
          // 작성자가 아닌 경우에만 신고하기, 차단하기 메뉴 추가
          items.add(
            _buildPopupMenuItem('report', '신고하기', Icons.report_outlined),
          );
          items.add(_buildPopupMenuItem('block', '차단하기', Icons.block));
        }

        return items;
      },
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
        _shareArticle();
        break;
      case 'block':
        _blockUser();
        break;
      case 'report':
        _reportArticle();
        break;
      case 'edit':
        if (onEdit != null) onEdit!();
        break;
      case 'delete':
        if (onDelete != null) onDelete!();
        break;
    }
  }

  void _shareArticle() {
    try {
      // 첫 번째 텍스트 콘텐츠 가져오기
      final firstTextContent =
          article.contents.where((content) => !content.isPicture).isNotEmpty
              ? article.contents
                  .where((content) => !content.isPicture)
                  .first
                  .contents
              : '';

      // 콘텐츠가 너무 길면 줄이기 (100자 제한)
      final shortContent =
          firstTextContent.length > 100
              ? '${firstTextContent.substring(0, 100)}...'
              : firstTextContent;

      // 앱링크 생성 (실제 도메인으로 변경 필요)
      final appLink = 'https://officelounge.app/article/${article.id}';

      // 공유할 텍스트 구성
      final shareText = '''
📝 ${article.title}

${shortContent.isNotEmpty ? '$shortContent\n\n' : ''}📱 OfficeLounge에서 확인하기
$appLink

#OfficeLounge #사무실라운지''';

      // 공유하기
      SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: '${article.title} - OfficeLounge',
        ),
      );

      AppSnackbar.info('게시글을 공유합니다.');
    } catch (e) {
      AppSnackbar.error('공유 중 오류가 발생했습니다.');
    }
  }

  void _blockUser() async {
    try {
      // SharedPreferences에서 차단된 사용자 확인
      final prefs = await SharedPreferences.getInstance();
      final blockedUsers = prefs.getStringList('blocked_users') ?? [];

      if (blockedUsers.contains(article.profile_uid)) {
        AppSnackbar.warning('이미 차단된 사용자입니다.');
        return;
      }

      // 차단 확인 bottom sheet 표시
      Get.bottomSheet(
        BlockBottomSheet(article: article),
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
      );
    } catch (e) {
      AppSnackbar.error('차단 처리 중 오류가 발생했습니다.');
    }
  }

  void _reportArticle() async {
    try {
      // SharedPreferences에서 신고한 게시물 확인
      final prefs = await SharedPreferences.getInstance();
      final reportedArticles = prefs.getStringList('reported_articles') ?? [];

      if (reportedArticles.contains(article.id)) {
        AppSnackbar.warning('이미 신고한 게시물입니다.');
        return;
      }

      // 신고 bottom sheet 표시
      Get.bottomSheet(
        ReportBottomSheet(article: article),
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
      );
    } catch (e) {
      AppSnackbar.error('신고 처리 중 오류가 발생했습니다.');
    }
  }
}
