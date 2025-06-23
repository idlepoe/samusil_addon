import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/appSnackbar.dart';
import '../../pages/dash_board/dash_board_controller.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  List<String> blockedUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBlockedUsers();
  }

  Future<void> loadBlockedUsers() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      blockedUsers = prefs.getStringList('blocked_users') ?? [];
    } catch (e) {
      AppSnackbar.error('차단 목록을 불러오는 중 오류가 발생했습니다.');
    }
    setState(() => isLoading = false);
  }

  Future<void> unblockUser(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      blockedUsers.remove(uid);
      await prefs.setStringList('blocked_users', blockedUsers);
      setState(() {});

      // 대시보드가 있는 경우 새로고침
      if (Get.isRegistered<DashBoardController>()) {
        final dashboardController = Get.find<DashBoardController>();
        await dashboardController.refreshDashboard();
      }

      AppSnackbar.success('사용자 차단이 해제되었습니다.');
    } catch (e) {
      AppSnackbar.error('차단 해제 중 오류가 발생했습니다.');
    }
  }

  void _showUnblockConfirmDialog(String uid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            '차단 해제',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191F28),
            ),
          ),
          content: Text(
            '이 사용자의 차단을 해제하시겠습니까?\n\nUID: $uid',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                unblockUser(uid);
              },
              child: const Text(
                '해제',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "차단한 사용자",
          style: TextStyle(
            color: Color(0xFF191F28),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF191F28)),
        elevation: 0,
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF0064FF)),
              )
              : blockedUsers.isEmpty
              ? _buildEmptyState()
              : _buildBlockedUsersList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(Icons.block, size: 40, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 24),
            const Text(
              "차단한 사용자가 없습니다",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF191F28),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "차단한 사용자가 있으면 여기에 표시됩니다",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockedUsersList() {
    return Column(
      children: [
        // 헤더 정보
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0064FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFF0064FF),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "차단한 사용자의 게시글과 댓글이 숨겨집니다",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0064FF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 차단된 사용자 목록
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: blockedUsers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final uid = blockedUsers[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.person_off,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    "사용자 UID",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF191F28),
                    ),
                  ),
                  subtitle: Text(
                    uid,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () => _showUnblockConfirmDialog(uid),
                      child: const Text(
                        "차단 해제",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
