import 'package:get/get.dart';
import 'package:samusil_addon/app/modules/chat_panel/controllers/chat_panel_controller.dart';
import 'package:samusil_addon/app/modules/upload_panel/controllers/upload_panel_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UploadPanelController());
    Get.put(ChatPanelController());
  }
}
