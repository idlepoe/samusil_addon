import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../components/appCircularProgress.dart';
import '../../models/point_history.dart';
import '../../controllers/profile_controller.dart';
import 'point_history_controller.dart';

class PointHistoryView extends GetView<PointHistoryController> {
  const PointHistoryView({super.key});

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
          '포인트 내역',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // 포인트 요약 카드
          _buildPointSummaryCard(),
          // 구분선
          Container(height: 8, color: const Color(0xFFF8F9FA)),
          // 포인트 내역 리스트
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.pointHistory.isEmpty) {
                return const Center(child: AppCircularProgress.large());
              }

              if (controller.pointHistory.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '포인트 내역이 없어요',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '활동하시면 포인트 내역이 쌓여요',
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
                        controller.pointHistory.length +
                        (controller.hasMore.value ? 1 : 0),
                    separatorBuilder:
                        (context, index) => Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey[100],
                          indent: 72,
                        ),
                    itemBuilder: (context, index) {
                      if (index == controller.pointHistory.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: AppCircularProgress(),
                          ),
                        );
                      }

                      final pointItem = controller.pointHistory[index];
                      return _buildPointItem(pointItem);
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPointSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1)),
      ),
      child: Obx(() {
        final profileController = ProfileController.to;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '보유 포인트',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profileController.currentPointRounded}P',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0064FF),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0064FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '이번 달 +${controller.thisMonthPoints.round().toString()}P',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0064FF),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPointItem(PointHistory pointItem) {
    final typeInfo = controller.getPointTypeInfo(pointItem.action_type);
    final isPositive = typeInfo['isPositive'] as bool;
    final iconName = typeInfo['icon'] as String;
    final iconColor = Color(typeInfo['color'] as int);

    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아이콘
            _buildPointIcon(iconName, iconColor),
            const SizedBox(width: 16),
            // 내용
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTranslatedPointType(pointItem.action_type),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (pointItem.description.isNotEmpty)
                    Text(
                      pointItem.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(pointItem.created_at),
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // 포인트 표시
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${pointItem.points_earned >= 0 ? '+' : ''}${pointItem.points_earned}P',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        pointItem.points_earned >= 0
                            ? const Color(0xFF51CF66)
                            : const Color(0xFFFF6B6B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointIcon(String iconName, Color iconColor) {
    IconData iconData;

    switch (iconName) {
      case 'edit':
        iconData = Icons.edit;
        break;
      case 'comment':
        iconData = Icons.chat_bubble;
        break;
      case 'favorite':
        iconData = Icons.favorite;
        break;
      case 'thumb_up':
        iconData = Icons.thumb_up;
        break;
      case 'star':
        iconData = Icons.star;
        break;
      case 'trophy':
        iconData = Icons.emoji_events;
        break;
      case 'sports_soccer':
        iconData = Icons.sports_soccer;
        break;
      case 'calendar':
        iconData = Icons.calendar_today;
        break;
      default:
        iconData = Icons.monetization_on;
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

  String _getTranslatedPointType(String type) {
    switch (type) {
      case '게시글 작성':
        return '게시글 작성';
      case '댓글 작성':
        return '댓글 작성';
      case '좋아요 받음':
        return '좋아요 받음';
      case '좋아요':
        return '좋아요';
      case '소원 작성':
        return '소원 작성';
      case '코인 경마 우승':
        return '코인 경마 우승';
      case '코인 경마 베팅':
        return '코인 경마 베팅';
      case '출석 보너스':
        return '출석 보너스';
      default:
        return type;
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return DateFormat('MM/dd').format(dateTime);
    }
  }
}
