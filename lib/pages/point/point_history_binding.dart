import 'package:get/get.dart';
import 'point_history_controller.dart';

class PointHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PointHistoryController>(PointHistoryController());
  }
}
