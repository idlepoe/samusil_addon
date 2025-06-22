import 'package:get/get.dart';
import 'package:samusil_addon/controllers/horse_race_controller.dart';

class HorseRaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HorseRaceController>(HorseRaceController());
  }
} 