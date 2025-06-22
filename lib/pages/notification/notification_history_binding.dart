import 'package:get/get.dart';
import 'notification_history_controller.dart';

class NotificationHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationHistoryController>(
      () => NotificationHistoryController(),
    );
  }
}
