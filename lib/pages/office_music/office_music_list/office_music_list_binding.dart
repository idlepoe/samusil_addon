import 'package:get/get.dart';
import 'office_music_list_controller.dart';

class OfficeMusicListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OfficeMusicListController());
  }
}
