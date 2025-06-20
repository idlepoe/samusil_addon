import 'package:crypto_icons_flutter/crypto_icons_flutter.dart';
import 'package:crypto_icons_flutter/cyprot_icon_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sprintf/sprintf.dart';
import 'package:tiny_charts/tiny_charts.dart';

import '../../../components/appButton.dart';
import '../../../define/define.dart';
import '../../../models/coin.dart';
import '../../../models/coin_balance.dart';
import '../../../utils/util.dart';
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

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 설명 카드
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
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
                        "coin_exchange_description".tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF191F28),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sprintf("coin_buy_description".tr, [
                          Define.COIN_BUY_FEE_PERCENT.toInt().toString(),
                        ]),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 코인 목록
                ...controller.coinList
                    .map((coin) => _buildCoinCard(coin))
                    .toList(),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Obx(() => _buildBottomBar()),
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
            CryptoIcons.loadAsset(coin.symbol, 24, CryptoIconStyle.color),
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
            color: Colors.grey.withOpacity(0.05),
            child: Column(
              children: [
                if (coin.current_volume_24h != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '24시간 거래량',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        _formatVolume(coin.current_volume_24h!),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                ],
                // 구매 섹션
                if (buyPrice != null) ...[
                  _buildTradeSection(
                    title: "구매",
                    price: buyPrice,
                    quantity: ownedQuantity,
                    isBuy: true,
                    coin: coin,
                  ),
                  const SizedBox(height: 12),
                ],

                // 판매 섹션
                if (ownedQuantity > 0 && sellPrice != null) ...[
                  _buildTradeSection(
                    title: "판매",
                    price: sellPrice,
                    quantity: ownedQuantity,
                    isBuy: false,
                    coin: coin,
                  ),
                ],

                if (ownedQuantity == 0 && buyPrice == null)
                  const Text(
                    "거래 불가능",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeSection({
    required String title,
    required double price,
    required int quantity,
    required bool isBuy,
    required Coin coin,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isBuy ? const Color(0xFFE3F2FD) : const Color(0xFFE8F5E8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isBuy ? const Color(0xFF2196F3) : const Color(0xFF4CAF50),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isBuy ? const Color(0xFF2196F3) : const Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "가격: ${price.toStringAsPrecision(7)}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (isBuy)
                      Text(
                        "수수료: ${Define.COIN_BUY_FEE_PERCENT.toInt()}%",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
              if (isBuy) ...[
                const SizedBox(width: 8),
                AppButton(
                  Get.context!,
                  "구매",
                  pBtnWidth: 0.3,
                  backgroundColor: const Color(0xFF2196F3),
                  onTap: () => _showQuantityDialog(coin, true, price),
                ),
              ] else ...[
                const SizedBox(width: 8),
                AppButton(
                  Get.context!,
                  "판매",
                  pBtnWidth: 0.3,
                  backgroundColor: const Color(0xFF4CAF50),
                  onTap: () => _showSellDialog(coin),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showQuantityDialog(Coin coin, bool isBuy, double price) {
    int selectedQuantity = 1;
    double maxQuantity =
        isBuy
            ? (controller.profile.value.point / price).floor().toDouble()
            : controller.getCoinQuantity(coin.id).toDouble();

    Get.dialog(
      AlertDialog(
        title: Text("${coin.name} ${isBuy ? '구매' : '판매'}"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("수량을 선택하세요 (최대: ${maxQuantity.toInt()})"),
                const SizedBox(height: 16),
                Slider(
                  value: selectedQuantity.toDouble(),
                  min: 1,
                  max: maxQuantity,
                  divisions: (maxQuantity - 1).toInt(),
                  label: selectedQuantity.toString(),
                  onChanged: (value) {
                    setState(() {
                      selectedQuantity = value.toInt();
                    });
                  },
                ),
                Text("선택된 수량: $selectedQuantity"),
                Text(
                  "총 금액: ${(price * selectedQuantity).toStringAsPrecision(7)}",
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("취소")),
          TextButton(
            onPressed: () {
              Get.back();
              if (isBuy) {
                controller.buyCoin(coin, selectedQuantity);
              }
            },
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  void _showSellDialog(Coin coin) {
    int ownedQuantity = controller.getCoinQuantity(coin.id);
    if (ownedQuantity == 0) return;

    // 보유 코인 중 가장 오래된 것부터 판매
    List<CoinBalance> ownedCoins =
        controller.profile.value.coin_balance!
            .where((balance) => balance.id == coin.id)
            .toList();

    Get.dialog(
      AlertDialog(
        title: Text("${coin.name} 판매"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: ownedCoins.length,
            itemBuilder: (context, index) {
              final coinBalance = ownedCoins[index];
              final currentPrice = coin.price_history!.last.price;
              final profit =
                  (currentPrice * coinBalance.quantity) -
                  (coinBalance.price * coinBalance.quantity);
              final profitPercentage =
                  ((currentPrice - coinBalance.price) /
                      ((currentPrice + coinBalance.price) / 2)) *
                  100;

              return ListTile(
                leading: CryptoIcons.loadAsset(
                  coin.symbol,
                  20,
                  CryptoIconStyle.color,
                ),
                title: Text("구매가: ${coinBalance.price.toStringAsPrecision(7)}"),
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
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("취소")),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    int totalCoinQuantity = 0;
    if (controller.profile.value.coin_balance != null) {
      for (CoinBalance balance in controller.profile.value.coin_balance!) {
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
                CryptoIcons.loadAsset('BTC', 20, CryptoIconStyle.color),
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
                  "${Utils.numberFormat(controller.profile.value.point.toInt())}P",
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
