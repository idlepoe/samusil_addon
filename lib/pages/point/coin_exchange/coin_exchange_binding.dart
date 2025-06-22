import 'package:get/get.dart';
import 'coin_exchange_controller.dart';
import '../../../controllers/profile_controller.dart';

class CoinExchangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoinExchangeController>(() => CoinExchangeController());
    // ProfileController가 없으면 등록
    if (!Get.isRegistered<ProfileController>()) {
      Get.put<ProfileController>(ProfileController(), permanent: true);
    }
  }
}
