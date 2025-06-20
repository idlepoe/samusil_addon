import 'package:get/get.dart';
import 'package:samusil_addon/controllers/profile_controller.dart';
import 'dash_board_controller.dart';

class DashBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashBoardController>(DashBoardController());
    // 전역 컨트롤러 초기화
    Get.put<ProfileController>(ProfileController(), permanent: true);
  }
}
