import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppSnackbarType { info, warning, error }

class AppSnackbar {
  // 기본 snackbar 표시 메서드
  static void show({
    required String message,
    AppSnackbarType type = AppSnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final config = _getSnackbarConfig(type);

    Get.snackbar(
      '', // title을 비워두고 messageText로 처리
      '',
      titleText: const SizedBox.shrink(), // title 영역 제거
      messageText: _buildContent(message, config),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: config.backgroundColor,
      colorText: config.textColor,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 600),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
      mainButton:
          actionLabel != null
              ? TextButton(
                onPressed: onActionPressed,
                child: Text(
                  actionLabel,
                  style: TextStyle(
                    color: config.actionColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
              : null,
    );
  }

  // 정보 snackbar (파랑)
  static void info(
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      message: message,
      type: AppSnackbarType.info,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  // 경고 snackbar (주황)
  static void warning(
    String message, {
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      message: message,
      type: AppSnackbarType.warning,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  // 에러 snackbar (빨강)
  static void error(
    String message, {
    Duration duration = const Duration(seconds: 5),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      message: message,
      type: AppSnackbarType.error,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  // 성공 snackbar (초록) - 추가 타입
  static void success(
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: _buildContent(
        message,
        _SnackbarConfig(
          backgroundColor: const Color(0xFF00C851),
          textColor: Colors.white,
          iconColor: Colors.white,
          actionColor: Colors.white,
          icon: Icons.check_circle_outline,
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF00C851),
      colorText: Colors.white,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 600),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
      mainButton:
          actionLabel != null
              ? TextButton(
                onPressed: onActionPressed,
                child: Text(
                  actionLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
              : null,
    );
  }

  // 내부 메서드들
  static _SnackbarConfig _getSnackbarConfig(AppSnackbarType type) {
    switch (type) {
      case AppSnackbarType.info:
        return _SnackbarConfig(
          backgroundColor: const Color(0xFF0064FF), // Toss 파랑
          textColor: Colors.white,
          iconColor: Colors.white,
          actionColor: Colors.white,
          icon: Icons.info_outline,
        );
      case AppSnackbarType.warning:
        return _SnackbarConfig(
          backgroundColor: const Color(0xFFFF9500), // 주황
          textColor: Colors.white,
          iconColor: Colors.white,
          actionColor: Colors.white,
          icon: Icons.warning_outlined,
        );
      case AppSnackbarType.error:
        return _SnackbarConfig(
          backgroundColor: const Color(0xFFFF3B30), // 빨강
          textColor: Colors.white,
          iconColor: Colors.white,
          actionColor: Colors.white,
          icon: Icons.error_outline,
        );
    }
  }

  static Widget _buildContent(String message, _SnackbarConfig config) {
    return Row(
      children: [
        Icon(config.icon, color: config.iconColor, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: config.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

// 내부 설정 클래스
class _SnackbarConfig {
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color actionColor;
  final IconData icon;

  _SnackbarConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.actionColor,
    required this.icon,
  });
}

// 편의를 위한 확장 메서드
extension AppSnackbarExtension on GetInterface {
  void showInfo(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    AppSnackbar.info(
      message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  void showWarning(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    AppSnackbar.warning(
      message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  void showError(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    AppSnackbar.error(
      message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  void showSuccess(
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    AppSnackbar.success(
      message,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}
