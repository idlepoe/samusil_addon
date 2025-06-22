import 'package:get/get.dart';
import 'package:office_lounge/controllers/horse_race_controller.dart';

class HorseRaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HorseRaceController>(HorseRaceController());
  }
}
