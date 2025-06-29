import 'package:get/get.dart';
import '../../controllers/online_sutda_controller.dart';

class OnlineSutdaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnlineSutdaController>(() => OnlineSutdaController());
  }
}
