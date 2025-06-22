import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sprintf/sprintf.dart';
import 'package:tiny_charts/tiny_charts.dart';

import '../../../components/appButton.dart';
import '../../../define/define.dart';
import '../../../models/coin.dart';
import '../../../models/coin_balance.dart';
import '../../../utils/util.dart';
import '../../../utils/app.dart';
import '../../../controllers/profile_controller.dart';
import 'coin_exchange_controller.dart';

class CoinExchangeView extends GetView<CoinExchangeController> {
  const CoinExchangeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "coin_exchange".tr,
          style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        ),
        backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
        iconTheme: const IconThemeData(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 포인트 정보
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "보유 포인트",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Text(
                        "${Utils.numberFormat(ProfileController.to.currentPointRounded)}P",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0064FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 마지막 갱신 시간 표시
              Obx(() {
                final lastUpdated = controller.getFirstCoinLastUpdated();
                if (lastUpdated == null) return const SizedBox.shrink();
                
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "마지막 갱신: ${Utils.formatDateTime(lastUpdated)}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),

              // Toss 스타일 코인 리스트 (stream 기반, rank 오름차순 정렬)
              ...(() {
                final sortedList = controller.coinList.toList();
                sortedList.sort((a, b) => a.coin.rank.compareTo(b.coin.rank));
                List<Widget> widgets = [];
                for (final coinWithHistory in sortedList) {
                  final coin = coinWithHistory.coin;
                  final lastTwoPrices = coinWithHistory.lastTwoPrices;
                  final lastPrice =
                      lastTwoPrices.isNotEmpty ? lastTwoPrices[0] : 0.0;
                  final prevPrice =
                      lastTwoPrices.length > 1 ? lastTwoPrices[1] : lastPrice;
                  final diff = lastPrice - prevPrice;
                  final diffPercent =
                      prevPrice != 0 ? (diff / prevPrice) * 100 : 0.0;
                  final isUp = diff > 0;
                  final isDown = diff < 0;
                  final diffColor =
                      isUp
                          ? const Color(0xFFE92F3C)
                          : isDown
                          ? const Color(0xFF1B5ED8)
                          : Colors.grey;
                  final diffSign = isUp ? '+' : '';

                  // 내 보유 내역
                  final myBalances = controller.getCoinBalances(coin.id);
                  double myTotalQty = 0;
                  double myTotalCost = 0;
                  for (final b in myBalances) {
                    myTotalQty += b.quantity;
                    myTotalCost += b.price * b.quantity;
                  }
                  final myAvgPrice =
                      myTotalQty > 0 ? myTotalCost / myTotalQty : 0.0;
                  final myProfit =
                      myTotalQty > 0
                          ? (lastPrice - myAvgPrice) * myTotalQty
                          : 0.0;
                  final myProfitPercent =
                      (myTotalQty > 0 && myAvgPrice > 0)
                          ? ((lastPrice - myAvgPrice) / myAvgPrice) * 100
                          : 0.0;
                  final myProfitColor =
                      myProfit > 0
                          ? const Color(0xFFE92F3C)
                          : myProfit < 0
                          ? const Color(0xFF1B5ED8)
                          : Colors.grey;
                  final myProfitSign = myProfit > 0 ? '+' : '';

                  widgets.add(
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 0,
                      ),
                      child: Row(
                        children: [
                          // 아이콘
                          App.buildCoinIcon(coin.symbol, size: 36),
                          const SizedBox(width: 12),
                          // 이름 및 가격
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  coin.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF191F28),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${lastPrice.toStringAsFixed(2)}원',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF191F28),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 내 손익 정보
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${myProfitSign}${myProfit.abs().toStringAsFixed(0)}원',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: myProfitColor,
                                ),
                              ),
                              Text(
                                '(${myProfitSign}${myProfitPercent.abs().toStringAsFixed(1)}%)',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: myProfitColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return widgets;
              })(),
            ],
          ),
        );
      }),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildCoinCard(Coin coin) {
    double width = Get.width;
    double width60 = width * 0.6;

    double? buyPrice =
        coin.price_history != null
            ? coin.price_history!.last.price +
                (coin.price_history!.last.price * Define.COIN_BUY_FEE_PERCENT)
            : null;

    double? sellPrice =
        coin.price_history != null ? coin.price_history!.last.price : null;

    int ownedQuantity = controller.getCoinQuantity(coin.id);
    final currentPrice = coin.price_history?.last.price ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              coin.rank.toString(),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        title: Row(
          children: [
            App.buildCoinIcon(coin.symbol, size: 24),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  coin.symbol,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${Utils.numberFormat(currentPrice.toInt())}원',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              if (ownedQuantity > 0)
                Text(
                  "보유: ${ownedQuantity}${coin.symbol}",
                  style: const TextStyle(
                    color: Color(0xFF00C851),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
        trailing: SizedBox(
          width: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (coin.diffPercentage != null)
                Text(
                  '24H: ${coin.diffPercentage!.toStringAsPrecision(2)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        coin.diffPercentage! >= 0
                            ? const Color(0xFF27A083)
                            : const Color(0xFFE92F3C),
                  ),
                ),
              const SizedBox(height: 4),
              if (coin.diffList != null)
                TinyColumnChart(
                  data: coin.diffList!,
                  width: 80,
                  height: 20,
                  options: const TinyColumnChartOptions(
                    positiveColor: Color(0xFF27A083),
                    negativeColor: Color(0xFFE92F3C),
                    showAxis: true,
                  ),
                ),
            ],
          ),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        Get.context!,
                        "구매",
                        pBtnWidth: 0.45,
                        backgroundColor: const Color(0xFF0064FF),
                        onTap: () {
                          if (buyPrice != null) {
                            _showBuyDialog(coin, buyPrice);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        Get.context!,
                        "판매",
                        pBtnWidth: 0.45,
                        backgroundColor: const Color(0xFFE92F3C),
                        onTap: () {
                          if (ownedQuantity > 0) {
                            _showSellDialog(coin, sellPrice ?? 0.0);
                          } else {
                            Get.snackbar(
                              '알림',
                              '보유한 ${coin.symbol}이 없습니다.',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "거래량: ${_formatVolume(coin.current_volume_24h ?? 0)}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      "시가총액: ${_formatVolume(coin.current_volume_24h ?? 0)}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBuyDialog(Coin coin, double price) {
    final TextEditingController quantityController = TextEditingController();
    final RxDouble totalCost = 0.0.obs;

    quantityController.addListener(() {
      try {
        double quantity = double.tryParse(quantityController.text) ?? 0;
        totalCost.value = quantity * price;
      } catch (e) {
        totalCost.value = 0;
      }
    });

    Get.dialog(
      AlertDialog(
        title: Text("${coin.name} 구매"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                App.buildCoinIcon(coin.symbol, size: 20),
                const SizedBox(width: 8),
                Text(coin.symbol),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "수량",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                "총 비용: ${Utils.numberFormat(totalCost.value.toInt())}P",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("취소")),
          ElevatedButton(
            onPressed: () {
              double quantity = double.tryParse(quantityController.text) ?? 0;
              if (quantity > 0) {
                Get.back();
                controller.buyCoin(coin, quantity, price);
              }
            },
            child: const Text("구매"),
          ),
        ],
      ),
    );
  }

  void _showSellDialog(Coin coin, double price) {
    Get.dialog(
      AlertDialog(
        title: Text("${coin.name} 판매"),
        content: SizedBox(
          width: double.maxFinite,
          child: FutureBuilder<List<CoinBalance>>(
            future: Future.value(controller.getCoinBalances(coin.id)),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("보유한 코인이 없습니다.");
              }

              final coinBalances = snapshot.data!;
              final currentPrice = coin.price_history?.last.price ?? 0.0;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: coinBalances.length,
                itemBuilder: (context, index) {
                  final coinBalance = coinBalances[index];
                  final profit =
                      (currentPrice - coinBalance.price) * coinBalance.quantity;
                  final profitPercentage =
                      (currentPrice - coinBalance.price) /
                      coinBalance.price *
                      100;

                  return ListTile(
                    leading: App.buildCoinIcon(coin.symbol, size: 20),
                    title: Text(
                      "구매가: ${coinBalance.price.toStringAsPrecision(7)}",
                    ),
                    subtitle: Text("수량: ${coinBalance.quantity}${coin.symbol}"),
                    trailing: AppButton(
                      Get.context!,
                      "${(coinBalance.quantity * currentPrice).toStringAsPrecision(2)} (${profitPercentage > 0 ? "+" : ""}${profitPercentage.toStringAsPrecision(1)}%)",
                      pBtnWidth: 0.4,
                      backgroundColor:
                          profit > 0
                              ? const Color(0xFF4CAF50)
                              : profit < 0
                              ? const Color(0xFFFF5252)
                              : const Color(0xFFFF9800),
                      onTap: () {
                        Get.back();
                        controller.sellCoin(coinBalance, currentPrice);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("취소")),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Obx(() {
      final profileController = ProfileController.to;
      int totalCoinQuantity = 0;
      if (profileController.coinBalance.isNotEmpty) {
        for (CoinBalance balance in profileController.coinBalance) {
          totalCoinQuantity += balance.quantity;
        }
      }

      return Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  App.buildCoinIcon('BTC', size: 20),
                  const SizedBox(width: 8),
                  Text(
                    Utils.numberFormat(totalCoinQuantity),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Colors.lightBlueAccent,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${Utils.numberFormat(profileController.currentPointRounded)}P",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  String _formatVolume(double volume) {
    if (volume >= 1_000_000_000) {
      return "${(volume / 1_000_000_000).toStringAsFixed(2)}B";
    } else if (volume >= 1_000_000) {
      return "${(volume / 1_000_000).toStringAsFixed(2)}M";
    } else if (volume >= 1_000) {
      return "${(volume / 1_000).toStringAsFixed(2)}K";
    } else {
      return volume.toString();
    }
  }
}
