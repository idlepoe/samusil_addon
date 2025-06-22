import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import '../../models/notification_history.dart';
import '../../controllers/profile_controller.dart';
import '../../components/appSnackbar.dart';
import '../../define/define.dart';

class NotificationHistoryController extends GetxController {
  final logger = Logger();

  final RxList<NotificationHistory> notifications = <NotificationHistory>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasMore = true.obs;

  DocumentSnapshot? lastDocument;
  final int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  /// 알림 히스토리 로드
  Future<void> loadNotifications({bool isRefresh = false}) async {
    if (isRefresh) {
      notifications.clear();
      lastDocument = null;
      hasMore.value = true;
    }

    if (!hasMore.value) return;

    try {
      isLoading.value = true;

      final uid = ProfileController.to.uid;
      if (uid.isEmpty) {
        logger.w('사용자 UID가 없습니다.');
        return;
      }

      Query query = FirebaseFirestore.instance
          .collection(Define.FIRESTORE_COLLECTION_PROFILE)
          .doc(uid)
          .collection('notification_history')
          .orderBy('created_at', descending: true)
          .limit(pageSize);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        hasMore.value = false;
        return;
      }

      final newNotifications =
          snapshot.docs
              .map(
                (doc) => NotificationHistory.fromJson({
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>,
                }),
              )
              .toList();

      notifications.addAll(newNotifications);
      lastDocument = snapshot.docs.last;

      if (snapshot.docs.length < pageSize) {
        hasMore.value = false;
      }
    } catch (e) {
      logger.e('알림 히스토리 로드 오류: $e');
      AppSnackbar.error('load_notification_error'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  /// 새로고침
  Future<void> onRefresh() async {
    await loadNotifications(isRefresh: true);
  }

  /// 더 불러오기
  Future<void> loadMore() async {
    if (!isLoading.value && hasMore.value) {
      await loadNotifications();
    }
  }

  /// 알림 읽음 처리
  Future<void> markAsRead(String notificationId) async {
    try {
      final uid = ProfileController.to.uid;
      if (uid.isEmpty) return;

      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(uid)
          .collection('notification_history')
          .doc(notificationId)
          .update({'read': true});

      // 로컬 상태 업데이트
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(read: true);
        notifications.refresh();
      }
    } catch (e) {
      logger.e('알림 읽음 처리 오류: $e');
    }
  }

  /// 모든 알림 읽음 처리
  Future<void> markAllAsRead() async {
    try {
      final uid = ProfileController.to.uid;
      if (uid.isEmpty) return;

      final batch = FirebaseFirestore.instance.batch();

      for (final notification in notifications.where((n) => !n.read)) {
        final docRef = FirebaseFirestore.instance
            .collection('profiles')
            .doc(uid)
            .collection('notification_history')
            .doc(notification.id);

        batch.update(docRef, {'read': true});
      }

      await batch.commit();

      // 로컬 상태 업데이트
      for (int i = 0; i < notifications.length; i++) {
        if (!notifications[i].read) {
          notifications[i] = notifications[i].copyWith(read: true);
        }
      }
      notifications.refresh();

      AppSnackbar.success('모든 알림을 읽음 처리했습니다.');
    } catch (e) {
      logger.e('모든 알림 읽음 처리 오류: $e');
      AppSnackbar.error('알림 읽음 처리 중 오류가 발생했습니다.');
    }
  }
}
