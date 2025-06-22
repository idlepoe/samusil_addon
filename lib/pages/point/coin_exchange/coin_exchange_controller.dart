import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../../../models/coin.dart';
import '../../../models/coin_balance.dart';
import '../../../utils/app.dart';
import '../../../define/define.dart';
import '../../../utils/util.dart';
import '../../../controllers/profile_controller.dart';

class CoinWithHistory {
  final Coin coin;
  final List<double> lastTwoPrices;
  final DateTime? lastUpdated;
  CoinWithHistory({
    required this.coin, 
    required this.lastTwoPrices,
    this.lastUpdated,
  });
}

class CoinExchangeController extends GetxController {
  var logger = Logger();

  final RxList<CoinWithHistory> coinList = <CoinWithHistory>[].obs;
  final RxBool isLoading = false.obs;
  StreamSubscription? _coinStream;
  List<StreamSubscription> _priceSubscriptions = [];

  @override
  void onInit() {
    super.onInit();
    subscribeCoinList();
  }

  @override
  void onClose() {
    _coinStream?.cancel();
    for (var sub in _priceSubscriptions) {
      sub.cancel();
    }
    super.onClose();
  }

  void subscribeCoinList() {
    isLoading.value = true;
    _coinStream?.cancel();
    _coinStream = FirebaseFirestore.instance
        .collection('coin')
        .snapshots()
        .listen((snapshot) async {
          List<CoinWithHistory> tempList = [];
          // 기존 priceHistory 구독 해제
          for (var sub in _priceSubscriptions) {
            await sub.cancel();
          }
          _priceSubscriptions.clear();
          for (var doc in snapshot.docs) {
            final coin = Coin.fromJson(doc.data());
            // 각 코인의 price_history subcollection에서 최신 2개 가격 구독
            var sub = FirebaseFirestore.instance
                .collection('coin')
                .doc(coin.id)
                .collection('price_history')
                .orderBy('timestamp', descending: true)
                .limit(2)
                .snapshots()
                .listen((priceSnap) {
                  List<double> lastTwoPrices =
                      priceSnap.docs
                          .map((d) => (d.data()['price'] as num).toDouble())
                          .toList();
                  
                  // 마지막 갱신 시간 가져오기
                  DateTime? lastUpdated;
                  if (priceSnap.docs.isNotEmpty) {
                    final timestamp = priceSnap.docs.first.data()['timestamp'];
                    if (timestamp is Timestamp) {
                      lastUpdated = timestamp.toDate();
                    }
                  }
                  
                  // 기존에 있던 코인 정보 갱신
                  int idx = tempList.indexWhere((c) => c.coin.id == coin.id);
                  if (idx >= 0) {
                    tempList[idx] = CoinWithHistory(
                      coin: coin,
                      lastTwoPrices: lastTwoPrices,
                      lastUpdated: lastUpdated,
                    );
                  } else {
                    tempList.add(
                      CoinWithHistory(
                        coin: coin, 
                        lastTwoPrices: lastTwoPrices,
                        lastUpdated: lastUpdated,
                      ),
                    );
                  }
                  coinList.value = List.from(tempList);
                });
            _priceSubscriptions.add(sub);
          }
          isLoading.value = false;
        });
  }

  Future<void> refreshData() async {
    subscribeCoinList();
    await ProfileController.to.refreshProfile();
  }

  // 보유 코인 수량 계산
  int getCoinQuantity(String coinId) {
    final profile = ProfileController.to.profile.value;
    if (profile.coin_balance == null) return 0;
    return profile.coin_balance!
        .where((balance) => balance.id == coinId)
        .fold(0, (sum, balance) => sum + balance.quantity);
  }

  // 특정 코인의 보유 내역 반환
  List<CoinBalance> getCoinBalances(String coinId) {
    final profile = ProfileController.to.profile.value;
    if (profile.coin_balance == null) return [];
    return profile.coin_balance!
        .where((balance) => balance.id == coinId)
        .toList();
  }

  // 코인 구매
  Future<void> buyCoin(Coin coin, double quantity, double price) async {
    try {
      isLoading.value = true;

      CoinBalance coinBalance = CoinBalance(
        id: coin.id,
        name: coin.name,
        price: price,
        quantity: quantity.toInt(),
        created_at: Utils.getDateTimeKey(),
      );

      final profile = ProfileController.to.profile.value;
      final updatedProfile = await App.buyCoin(profile.uid, coinBalance);

      // ProfileController 업데이트
      ProfileController.to.profile.value = updatedProfile;

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

      final profile = ProfileController.to.profile.value;
      final updatedProfile = await App.sellCoin(
        profile.uid,
        coinBalance,
        currentPrice,
      );

      // ProfileController 업데이트
      ProfileController.to.profile.value = updatedProfile;

      Get.snackbar('성공', '코인을 판매했습니다.');
    } catch (e) {
      logger.e('Error selling coin: $e');
      Get.snackbar('오류', '코인 판매에 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  // 첫 번째 코인의 마지막 갱신 시간 가져오기
  DateTime? getFirstCoinLastUpdated() {
    if (coinList.isEmpty) return null;
    final sortedList = coinList.toList();
    sortedList.sort((a, b) => a.coin.rank.compareTo(b.coin.rank));
    return sortedList.first.lastUpdated;
  }
}
