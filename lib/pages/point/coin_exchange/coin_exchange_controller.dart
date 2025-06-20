import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../models/coin.dart';
import '../../../models/coin_balance.dart';
import '../../../models/profile.dart';
import '../../../utils/app.dart';
import '../../../define/define.dart';
import '../../../utils/util.dart';

class CoinExchangeController extends GetxController {
  var logger = Logger();

  final RxList<Coin> coinList = <Coin>[].obs;
  final Rx<Profile> profile = Profile.init().obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final coins = await App.getCoinList(withoutNoTrade: true);
      final userProfile = await App.getProfile();
      
      // 거래량 기준으로 정렬 (내림차순)
      coins.sort((a, b) => (b.current_volume_24h ?? 0).compareTo(a.current_volume_24h ?? 0));
      
      coinList.value = coins;
      profile.value = userProfile;
    } catch (e) {
      logger.e('Error loading coin exchange data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadData();
  }

  // 보유 코인 수량 계산
  int getCoinQuantity(String coinId) {
    if (profile.value.coin_balance == null) return 0;

    return profile.value.coin_balance!
        .where((balance) => balance.id == coinId)
        .fold(0, (sum, balance) => sum + balance.quantity);
  }

  // 코인 구매
  Future<void> buyCoin(Coin coin, int quantity) async {
    try {
      isLoading.value = true;

      double? price =
          coin.price_history != null
              ? coin.price_history!.last.price +
                  (coin.price_history!.last.price * Define.COIN_BUY_FEE_PERCENT)
              : null;

      if (price == null) {
        Get.snackbar('오류', '거래 불가능한 코인입니다.');
        return;
      }

      CoinBalance coinBalance = CoinBalance(
        id: coin.id,
        name: coin.name,
        price: price,
        quantity: quantity,
        created_at: Utils.getDateTimeKey(),
      );

      profile.value = await App.buyCoin(profile.value.uid, coinBalance);
      Get.snackbar('성공', '코인을 구매했습니다.');
    } catch (e) {
      logger.e('Error buying coin: $e');
      Get.snackbar('오류', '코인 구매에 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  // 코인 판매
  Future<void> sellCoin(CoinBalance coinBalance, double currentPrice) async {
    try {
      isLoading.value = true;

      profile.value = await App.sellCoin(
        profile.value.uid,
        coinBalance,
        currentPrice,
      );

      Get.snackbar('성공', '코인을 판매했습니다.');
    } catch (e) {
      logger.e('Error selling coin: $e');
      Get.snackbar('오류', '코인 판매에 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }
}
