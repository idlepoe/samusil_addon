import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';
import 'package:office_lounge/models/main_comment.dart';
import 'package:office_lounge/components/profile_avatar_widget.dart';
import 'package:office_lounge/components/profile_badge_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../utils/util.dart';
import '../../../../define/define.dart';
import '../../../../components/appSnackbar.dart';
import '../../../../controllers/profile_controller.dart';
import '../article_detail_controller.dart';

class CommentListWidget extends GetView<ArticleDetailController> {
  const CommentListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _getBlockedUsers(),
      builder: (context, snapshot) {
        final blockedUsers = snapshot.data ?? [];

        return Obx(
          () => Column(
            children: _buildCommentTree(controller.comments, blockedUsers),
          ),
        );
      },
    );
  }

  List<Widget> _buildCommentTree(
    List<MainComment> comments,
    List<String> blockedUsers,
  ) {
    List<Widget> widgets = [];

    // 부모 댓글들 (is_sub가 false인 댓글들)
    final parentComments =
        comments.where((comment) => !comment.is_sub).toList();

    for (final parentComment in parentComments) {
      final isBlocked = blockedUsers.contains(parentComment.profile_uid);

      // 부모 댓글 추가
      widgets.add(_buildCommentItem(parentComment, isBlocked, false));

      // 해당 부모 댓글의 대댓글들 찾기
      final subComments =
          comments
              .where(
                (comment) =>
                    comment.is_sub && comment.parents_key == parentComment.id,
              )
              .toList();

      // 대댓글들 추가
      for (final subComment in subComments) {
        final isSubBlocked = blockedUsers.contains(subComment.profile_uid);
        widgets.add(_buildCommentItem(subComment, isSubBlocked, true));
      }
    }

    return widgets;
  }

  Future<List<String>> _getBlockedUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList('blocked_users') ?? [];
    } catch (e) {
      return [];
    }
  }

  Widget _buildCommentItem(
    MainComment comment,
    bool isBlocked,
    bool isSubComment,
  ) {
    return Container(
      padding: EdgeInsets.only(
        left: isSubComment ? 56 : 16, // 대댓글은 들여쓰기
        right: 16,
        top: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        color: isSubComment ? Colors.grey.shade50 : Colors.white, // 대댓글 배경색 구분
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 이미지 (대댓글은 작게)
          ProfileAvatarWidget(
            photoUrl: isBlocked ? '' : comment.profile_photo_url,
            name: isBlocked ? '차단된 사용자' : comment.profile_name,
            size: isSubComment ? 32 : 40,
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
                    if (isSubComment) ...[
                      Icon(
                        Icons.subdirectory_arrow_right,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      isBlocked ? '차단된 사용자' : comment.profile_name,
                      style: TextStyle(
                        fontSize: isSubComment ? 13 : 14,
                        fontWeight: FontWeight.bold,
                        color: isBlocked ? Colors.grey : null,
                      ),
                    ),
                    if (!isBlocked)
                      ProfileBadgeWidget(
                        point: comment.profile_point ?? 0,
                        fontSize: isSubComment ? 8 : 10,
                      ),
                    const SizedBox(width: 8),
                    Text(
                      Utils.toConvertFireDateToCommentTime(
                        DateFormat(
                          'yyyyMMddHHmm',
                        ).format(comment.created_at ?? DateTime.now()),
                      ),
                      style: TextStyle(
                        fontSize: isSubComment ? 11 : 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    if (!isBlocked) _buildMoreButton(comment),
                  ],
                ),
                const SizedBox(height: 4),
                // 댓글 텍스트
                Text(
                  isBlocked ? '차단된 사용자의 댓글입니다.' : comment.contents,
                  style: TextStyle(
                    fontSize: isSubComment ? 14 : 15,
                    height: 1.5,
                    color: isBlocked ? Colors.grey : null,
                    fontStyle: isBlocked ? FontStyle.italic : null,
                  ),
                ),
                const SizedBox(height: 12),
                // 답글 달기 (대댓글에는 표시 안함, 차단된 사용자는 숨김)
                if (!isBlocked && !isSubComment)
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.setSubComment(comment),
                        child: Row(
                          children: [
                            Icon(
                              Icons.reply,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '답글 달기',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
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
      onSelected: (value) async {
        if (value == 'report') {
          await _reportComment(comment);
        } else if (value == 'block') {
          await _blockUser(comment);
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
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

  Future<void> _reportComment(MainComment comment) async {
    try {
      // 게시글 ID를 가져와서 올바른 경로로 댓글 신고
      final articleId = controller.articleId.value;
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(articleId)
          .collection('comments')
          .doc(comment.id)
          .update({'count_report': FieldValue.increment(1)});

      AppSnackbar.success('댓글이 신고되었습니다.');
    } catch (e) {
      AppSnackbar.error('댓글 신고 중 오류가 발생했습니다.');
    }
  }

  Future<void> _blockUser(MainComment comment) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final blockedUsers = prefs.getStringList('blocked_users') ?? [];

      if (!blockedUsers.contains(comment.profile_uid)) {
        blockedUsers.add(comment.profile_uid);
        await prefs.setStringList('blocked_users', blockedUsers);

        // UI 새로고침
        Get.forceAppUpdate();

        AppSnackbar.success('${comment.profile_name}님이 차단되었습니다.');
      } else {
        AppSnackbar.warning('이미 차단된 사용자입니다.');
      }
    } catch (e) {
      AppSnackbar.error('사용자 차단 중 오류가 발생했습니다.');
    }
  }
}
