import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SimpleDialogButtonStyle { primary, secondary, destructive }

Future<void> showSimpleDialog({
  required String title,
  required String message,
  String confirmText = '확인',
  String cancelText = '취소',
  SimpleDialogButtonStyle confirmButtonStyle = SimpleDialogButtonStyle.primary,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) async {
  await Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF191F28),
              ),
            ),
            const SizedBox(height: 8),

            // 메시지
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF4E5968),
              ),
            ),
            const SizedBox(height: 24),

            // 버튼 영역
            Row(
              children: [
                // 취소 버튼
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                      onCancel?.call();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8B95A1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 확인 버튼
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                      onConfirm?.call();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: _getButtonColor(confirmButtonStyle),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _getButtonTextColor(confirmButtonStyle),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

Color _getButtonColor(SimpleDialogButtonStyle style) {
  switch (style) {
    case SimpleDialogButtonStyle.primary:
      return const Color(0xFF0064FF);
    case SimpleDialogButtonStyle.secondary:
      return const Color(0xFFF8F9FA);
    case SimpleDialogButtonStyle.destructive:
      return const Color(0xFFFF3B30);
  }
}

Color _getButtonTextColor(SimpleDialogButtonStyle style) {
  switch (style) {
    case SimpleDialogButtonStyle.primary:
      return Colors.white;
    case SimpleDialogButtonStyle.secondary:
      return const Color(0xFF191F28);
    case SimpleDialogButtonStyle.destructive:
      return Colors.white;
  }
}
