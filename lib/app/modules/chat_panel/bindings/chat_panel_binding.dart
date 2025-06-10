import 'package:get/get.dart';

import '../controllers/chat_panel_controller.dart';

class ChatPanelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatPanelController>(
      () => ChatPanelController(),
    );
  }
}
