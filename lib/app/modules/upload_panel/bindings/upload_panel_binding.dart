import 'package:get/get.dart';

import '../controllers/upload_panel_controller.dart';

class UploadPanelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadPanelController>(
      () => UploadPanelController(),
    );
  }
}
