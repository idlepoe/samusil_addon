import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:samusil_addon/models/coin_balance.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';

import '../../components/appButton.dart';
import '../../define/define.dart';
import '../../models/coin.dart';
import '../../models/profile.dart';
import '../../utils/app.dart';
import '../../utils/util.dart';

class CoinSellPage extends StatefulWidget {
  const CoinSellPage({super.key});

  @override
  State<CoinSellPage> createState() => _CoinSellPageState();
}

class _CoinSellPageState extends State<CoinSellPage>
    with AutomaticKeepAliveClientMixin {
  var logger = Logger();

  Profile _profile = Profile.init();
  List<Coin> _coinList = [];
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _coinList = await App.getCoinList();
    _profile = await App.getProfile();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CoinBalance> unique = [];
    for (int i = 0; i < _profile.coin_balance.length; i++) {
      CoinBalance? isExist = unique.firstWhereOrNull((element) =>
          element.id == _profile.coin_balance[i].id &&
          element.price == _profile.coin_balance[i].price);
      if (isExist == null) {
        _profile = _profile.copyWith(
          coin_balance: _profile.coin_balance.asMap().map((index, balance) {
            if (index == i) {
              return MapEntry(index, balance.copyWith(
                sub_list: [balance],
                total: balance.quantity,
              ));
            }
            return MapEntry(index, balance);
          }).values.toList(),
        );
        
        CoinBalance value = _profile.coin_balance[i].copyWith(
          sub_list: [_profile.coin_balance[i]],
          total: _profile.coin_balance[i].quantity,
        );
        unique.add(value);
      } else {
        int position = unique.indexOf(isExist);
        unique[position] = unique[position].copyWith(
          total: unique[position].total! + _profile.coin_balance[i].quantity,
          sub_list: [...unique[position].sub_list!, _profile.coin_balance[i]],
        );
      }
    }

    for (int i = 0; i < unique.length; i++) {
      Coin? currentCoinInfo =
          _coinList.firstWhereOrNull((element) => element.id == unique[i].id);
      if (currentCoinInfo != null) {
        unique[i] = unique[i].copyWith(
          current_price: currentCoinInfo.price_history!.last.price,
          profit: (currentCoinInfo.price_history!.last.price * unique[i].quantity) -
              (unique[i].price * unique[i].quantity),
        );
      }
      for (int j = 0; j < unique[i].sub_list!.length; j++) {
        unique[i].sub_list![j] = unique[i].sub_list![j].copyWith(
          profit: (currentCoinInfo!.price_history!.last.price *
              unique[i].sub_list![j].quantity) -
              (unique[i].sub_list![j].price * unique[i].sub_list![j].quantity),
        );
      }
    }

    int coinQuantity = 0;

    for (CoinBalance row in _profile.coin_balance ?? []) {
      coinQuantity += row.quantity;
    }

    RefreshController refreshController =
        RefreshController(initialRefresh: false);

    void _onRefresh() async {
      logger.i("_onRefresh");
      init();
      refreshController.refreshCompleted();
    }

    return Scaffold(
      body: SmartRefresher(
        controller: refreshController,
        header: ClassicHeader(
          idleText: "header_idle_text".tr,
          releaseText: "header_release_text".tr,
          refreshingText: "header_loading_text".tr,
          completeText: "header_complete_text".tr,
        ),
        enablePullDown: true,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "coin_sell_description".tr,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 12,
                  ),
                  maxLines: 3,
                ),
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              ),
              Define.APP_DIVIDER,
              Column(
                children: List.generate(unique.length, (index) {
                  return ExpansionTile(
                    leading: Icon(
                        _getCryptoIcon(unique[index].id.split("-")[0]),
                        color: Utils.randomColor()),
                    title: Text(
                        "${unique[index].name} (${Utils.numberFormat(unique[index].total!)})"),
                    subtitle: Text(
                        unique[index].current_price!.toStringAsPrecision(7),
                        style: const TextStyle(color: Colors.grey)),
                    trailing: Text(
                        "${(unique[index].total! * unique[index].current_price!).toStringAsPrecision(2)} (${(unique[index].profit! > 0 || unique[index].profit! == 0) ? "+" : "-"}${(((unique[index].price - unique[index].current_price!) / ((unique[index].price + unique[index].current_price!) / 2)) * 100).abs().toStringAsPrecision(3)}%)",
                        style: TextStyle(
                            color: unique[index].profit! > 0
                                ? Colors.green
                                : unique[index].profit! == 0
                                    ? Colors.orange
                                    : Colors.red,
                            fontWeight: FontWeight.bold)),
                    children: List.generate(unique[index].sub_list!.length,
                        (subIndex) {
                      bool isPlus = false;
                      Color btnColor = Colors.orange;
                      if (unique[index].sub_list![subIndex].profit! > 0) {
                        isPlus = true;
                        btnColor = Colors.green;
                      } else if (unique[index].sub_list![subIndex].profit ==
                          0) {
                        isPlus = true;
                        btnColor = Colors.orange;
                      } else if (unique[index].sub_list![subIndex].profit! <
                          0) {
                        btnColor = Colors.red;
                      }
                      return ListTile(
                        leading: Icon(
                            _getCryptoIcon(unique[index].id.split("-")[0]),
                            color: Colors.grey),
                        title: Text(unique[index]
                            .sub_list![subIndex]
                            .price
                            .toStringAsPrecision(7)),
                        subtitle: Text(
                            Utils.toConvertFireDateToCommentTime(
                                unique[index].sub_list![subIndex].created_at,
                                bYear: true),
                            style: const TextStyle(color: Colors.grey)),
                        trailing: AppButton(context,
                            "${(unique[index].sub_list![subIndex].quantity * unique[index].current_price!).toStringAsPrecision(2)} (${isPlus ? "+" : "-"}${(((unique[index].sub_list![subIndex].price - unique[index].current_price!) / ((unique[index].sub_list![subIndex].price + unique[index].current_price!) / 2)) * 100).toStringAsPrecision(3)}%)",
                            pBtnWidth: 0.3,
                            backgroundColor: btnColor, onTap: () async {
                          setState(() {
                            _isPressed = true;
                          });
                          logger.i(unique[index]);
                          logger.i(unique[index].sub_list![subIndex]);
                          logger.i(unique[index].current_price!);
                          _profile = await App.sellCoin(
                              _profile.key,
                              unique[index].sub_list![subIndex],
                              unique[index].current_price!);
                          setState(() {
                            _isPressed = false;
                          });
                        }, disable: _isPressed),
                      );
                    }),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(CryptoFontIcons.BTC, color: Colors.amber),
                  const SizedBox(width: 5),
                  Text(Utils.numberFormat(coinQuantity),
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.monetization_on,
                      color: Colors.lightBlueAccent),
                  const SizedBox(width: 5),
                  Text("${_profile.point.toStringAsFixed(0)}P",
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

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
