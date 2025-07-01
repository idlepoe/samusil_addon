import 'package:get/get.dart';

import 'artwork_controller.dart';

class ArtworkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArtworkController>(() => ArtworkController());
  }
}
