import 'package:get/get.dart';
import 'package:office_lounge/controllers/profile_controller.dart';
import 'dash_board_controller.dart';
import 'package:logger/logger.dart';

class DashBoardBinding extends Bindings {
  final logger = Logger();

  @override
  void dependencies() {
    Get.put<DashBoardController>(DashBoardController());

    // ProfileController 등록 (자동 초기화 방지)
    if (!Get.isRegistered<ProfileController>()) {
      Get.put<ProfileController>(ProfileController(), permanent: true);
    }
  }
}
