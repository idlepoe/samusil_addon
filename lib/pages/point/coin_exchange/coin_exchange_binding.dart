import 'package:get/get.dart';
import 'coin_exchange_controller.dart';

class CoinExchangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoinExchangeController>(() => CoinExchangeController());
  }
}
