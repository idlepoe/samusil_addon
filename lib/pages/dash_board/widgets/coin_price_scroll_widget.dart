import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:logger/logger.dart';

import '../../../models/coin.dart';
import '../../../utils/app.dart';
import '../../../main.dart';
import '../dash_board_controller.dart';

class CoinPriceScrollWidget extends StatelessWidget {
  const CoinPriceScrollWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<DashBoardController>();
      
      if (controller.isLoadingCoins.value) {
        return const SizedBox(
          height: 40,
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      }

      if (controller.coinList.isEmpty) {
        return SizedBox(
          height: 40,
          child: Center(
            child: Text(
              '코인 정보가 없습니다',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }

      // 거래량 기준으로 정렬 (내림차순)
      final sortedCoinList = List<Coin>.from(controller.coinList);
      sortedCoinList.sort(
        (a, b) =>
            (b.current_volume_24h ?? 0).compareTo(a.current_volume_24h ?? 0),
      );

      return Container(
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
        child: Container(
          height: 40,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ScrollLoopAutoScroll(
            duration: const Duration(seconds: 30),
            duplicateChild: 2,
            scrollDirection: Axis.horizontal,
            child: InkWell(
              onTap: () async {
                Get.toNamed('/coin_exchange');
              },
              child: Row(
                children: List.generate(sortedCoinList.length, (index) {
                  final coin = sortedCoinList[index];
                  final diffPercentage = coin.diffPercentage ?? 0.0;
                  final color = coin.color ?? 0.0;

                  return Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: Row(
                      children: [
                        App.buildCoinIcon(coin.symbol, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          coin.symbol,
                          style: const TextStyle(
                            color: Color(0xFF191F28),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (diffPercentage != 0.0) ...[
                          const SizedBox(width: 4),
                          Text(
                            "(${diffPercentage > 0 ? "+" : ""}${diffPercentage.toStringAsPrecision(1)}%)",
                            style: TextStyle(
                              color:
                                  diffPercentage > 0
                                      ? const Color(0xFF00C851)
                                      : const Color(0xFFFF5252),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      );
    });
  }
}
