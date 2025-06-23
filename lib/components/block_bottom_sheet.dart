import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';
import 'appSnackbar.dart';
import '../pages/dash_board/dash_board_controller.dart';

class BlockBottomSheet extends StatefulWidget {
  final Article article;

  const BlockBottomSheet({super.key, required this.article});

  @override
  State<BlockBottomSheet> createState() => _BlockBottomSheetState();
}

class _BlockBottomSheetState extends State<BlockBottomSheet> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 핸들 바
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 헤더
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '사용자 차단',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // 내용
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '이 사용자를 차단하시겠습니까?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              widget.article.profile_photo_url.isNotEmpty
                                  ? NetworkImage(
                                    widget.article.profile_photo_url,
                                  )
                                  : null,
                          child:
                              widget.article.profile_photo_url.isEmpty
                                  ? Text(
                                    widget.article.profile_name.isNotEmpty
                                        ? widget.article.profile_name[0]
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                  : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.article.profile_name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'UID: ${widget.article.profile_uid}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '차단하면:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _buildBlockEffectItem('• 이 사용자가 작성한 모든 게시글이 숨겨집니다'),
                  _buildBlockEffectItem('• 이 사용자의 댓글이 표시되지 않습니다'),
                  _buildBlockEffectItem('• 차단은 언제든지 해제할 수 있습니다'),
                  const Spacer(),
                ],
              ),
            ),
          ),
          // 하단 버튼
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _blockUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text(
                              '차단하기',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockEffectItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
      ),
    );
  }

  Future<void> _blockUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // SharedPreferences에서 차단된 사용자 목록 가져오기
      final prefs = await SharedPreferences.getInstance();
      final blockedUsers = prefs.getStringList('blocked_users') ?? [];

      // 이미 차단된 사용자인지 확인
      if (blockedUsers.contains(widget.article.profile_uid)) {
        AppSnackbar.warning('이미 차단된 사용자입니다.');
        return;
      }

      // 차단된 사용자 목록에 추가
      blockedUsers.add(widget.article.profile_uid);
      await prefs.setStringList('blocked_users', blockedUsers);

      Get.back();
      AppSnackbar.success('${widget.article.profile_name}님을 차단했습니다.');

      // 대시보드가 현재 화면인 경우 새로고침
      if (Get.currentRoute == '/') {
        final dashboardController = Get.find<DashBoardController>();
        await dashboardController.refreshDashboard();
      }
    } catch (e) {
      AppSnackbar.error('차단 처리 중 오류가 발생했습니다.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
