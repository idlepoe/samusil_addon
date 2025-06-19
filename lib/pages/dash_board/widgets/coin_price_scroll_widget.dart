import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';

import '../../../models/coin.dart';
import '../../point/03_point_exchange_tab_page.dart';

class CoinPriceScrollWidget extends StatelessWidget {
  final List<Coin> coinList;

  const CoinPriceScrollWidget({super.key, required this.coinList});

  @override
  Widget build(BuildContext context) {
    if (coinList.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 30,
      width: double.infinity,
      child: ScrollLoopAutoScroll(
        duplicateChild: 2,
        scrollDirection: Axis.horizontal,
        child: InkWell(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const PointExchangeTabPage(),
              ),
            );
          },
          child: Row(
            children: List.generate(coinList.length, (index) {
              return Wrap(
                children: [
                  Icon(
                    _getCryptoIcon(coinList[index].id.split("-")[0]),
                    color: Color(coinList[index].color!.toInt()),
                    size: 15,
                  ),
                  const SizedBox(width: 3),
                  RichText(
                    text: TextSpan(
                      text: coinList[index].symbol,
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text:
                              (coinList[index].diffPercentage == null
                                  ? ""
                                  : "(${coinList[index].diffPercentage! > 0 ? "+" : ""}${coinList[index].diffPercentage!.toStringAsPrecision(1)}%)"),
                          style: TextStyle(
                            color:
                                coinList[index].diffPercentage! > 0
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              );
            }),
          ),
        ),
      ),
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
