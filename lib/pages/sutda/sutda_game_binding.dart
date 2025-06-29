import 'package:get/get.dart';
import 'sutda_game_controller.dart';

class SutdaGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SutdaGameController>(() => SutdaGameController());
  }
}
