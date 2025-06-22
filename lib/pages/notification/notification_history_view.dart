import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import '../../components/appCircularProgress.dart';
import '../../models/notification_history.dart';
import 'notification_history_controller.dart';

class NotificationHistoryView extends GetView<NotificationHistoryController> {
  const NotificationHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'notification'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: controller.markAllAsRead,
            child: Text(
              'settings'.tr,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: AppCircularProgress.large());
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 80,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 24),
                Text(
                  'no_notifications'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'notification_empty_message'.tr,
                  style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.onRefresh,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  controller.hasMore.value &&
                  !controller.isLoading.value) {
                controller.loadMore();
              }
              return false;
            },
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount:
                  controller.notifications.length +
                  (controller.hasMore.value ? 1 : 0),
              separatorBuilder:
                  (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey[100],
                    indent: 72,
                  ),
              itemBuilder: (context, index) {
                if (index == controller.notifications.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: AppCircularProgress(),
                    ),
                  );
                }

                final notification = controller.notifications[index];
                return _buildNotificationItem(notification);
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNotificationItem(NotificationHistory notification) {
    return Material(
      color: notification.read ? Colors.white : const Color(0xFFF8F9FA),
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 아이콘
              _buildNotificationIcon(notification.type),
              const SizedBox(width: 16),
              // 내용
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  notification.read
                                      ? FontWeight.w400
                                      : FontWeight.w600,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(notification.created_at),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // 읽지 않음 표시
              if (!notification.read) ...[
                const SizedBox(width: 8),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0064FF),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'like':
        iconData = Icons.favorite;
        iconColor = const Color(0xFFFF6B6B);
        break;
      case 'comment':
        iconData = Icons.chat_bubble;
        iconColor = const Color(0xFF4DABF7);
        break;
      case 'horse_race':
        iconData = Icons.emoji_events;
        iconColor = const Color(0xFFFFB84D);
        break;
      case 'system':
        iconData = Icons.settings;
        iconColor = const Color(0xFF9C9C9C);
        break;
      default:
        iconData = Icons.notifications;
        iconColor = const Color(0xFF9C9C9C);
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just_now'.tr;
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}${'minutes_ago'.tr}';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}${'hours_ago'.tr}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}${'days_ago'.tr}';
    } else {
      return DateFormat('MM/dd HH:mm').format(dateTime);
    }
  }

  void _handleNotificationTap(NotificationHistory notification) {
    // 읽지 않은 알림이면 읽음 처리
    if (!notification.read) {
      controller.markAsRead(notification.id);
    }

    // 알림 타입에 따라 해당 페이지로 이동
    if (notification.article_id.isNotEmpty) {
      Get.toNamed('/detail/${notification.article_id}');
    }
  }
}
