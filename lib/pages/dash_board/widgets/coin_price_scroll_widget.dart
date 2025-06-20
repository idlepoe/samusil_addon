import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:logger/logger.dart';

import '../../../models/coin.dart';
import '../../../utils/app.dart';
import '../../../main.dart';
import '../../point/03_point_exchange_tab_page.dart';

class CoinPriceScrollWidget extends StatelessWidget {
  const CoinPriceScrollWidget({super.key});

  Future<List<Coin>> _loadCoinList() async {
    final logger = Logger();
    try {
      return await App.getCoinList(withoutNoTrade: true);
    } catch (e) {
      logger.e("Error loading coinList: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Coin>>(
      future: _loadCoinList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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

        if (snapshot.hasError) {
          return SizedBox(
            height: 40,
            child: Center(
              child: Text(
                '코인 정보를 불러올 수 없습니다',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
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

        final coinList = snapshot.data!;

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
              duration: const Duration(seconds: 1000),
              duplicateChild: 2,
              scrollDirection: Axis.horizontal,
              child: InkWell(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (BuildContext context) =>
                              const PointExchangeTabPage(),
                    ),
                  );
                },
                child: Row(
                  children: List.generate(coinList.length, (index) {
                    final coin = coinList[index];
                    final diffPercentage = coin.diffPercentage ?? 0.0;
                    final color = coin.color ?? 0.0;

                    return Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: Row(
                        children: [
                          Icon(
                            _getCryptoIcon(coin.id.split("-")[0]),
                            color: Color(color.toInt()),
                            size: 16,
                          ),
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
      },
    );
  }

  IconData _getCryptoIcon(String symbol) {
    switch (symbol.toLowerCase()) {
      case 'btc':
        return CryptoFontIcons.BTC;
      case 'eth':
        return CryptoFontIcons.ETH;
      case 'usdt':
        return CryptoFontIcons.USDT;
      case 'doge':
        return CryptoFontIcons.DOGE;
      default:
        return CryptoFontIcons.BTC;
    }
  }
}
