import 'package:get/get.dart';
import 'office_music_detail_controller.dart';

class OfficeMusicDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OfficeMusicDetailController());
  }
}
