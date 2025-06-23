import 'package:get/get.dart';
import 'horse_race_history_controller.dart';

class HorseRaceHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HorseRaceHistoryController>(() => HorseRaceHistoryController());
  }
}
