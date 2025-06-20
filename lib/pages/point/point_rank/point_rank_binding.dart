import 'package:get/get.dart';
import 'point_rank_controller.dart';

class PointRankBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PointRankController>(() => PointRankController());
  }
}
