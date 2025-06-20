import 'package:get/get.dart';

import 'wish_controller.dart';

class WishBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WishController>(() => WishController());
  }
}
