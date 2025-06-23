import 'package:get/get.dart';
import 'office_music_edit_controller.dart';

class OfficeMusicEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OfficeMusicEditController());
  }
}
