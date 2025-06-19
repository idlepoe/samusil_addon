import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:samusil_addon/components/appButton.dart';
import 'package:samusil_addon/define/define.dart';
import 'package:samusil_addon/models/coin_balance.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:badges/badges.dart' as badges;
import 'package:sprintf/sprintf.dart';
import 'package:tiny_charts/tiny_charts.dart';

import '../../models/coin.dart';
import '../../models/profile.dart';
import '../../utils/app.dart';
import '../../utils/util.dart';

class CoinBuyPage extends StatefulWidget {
  const CoinBuyPage({super.key});

  @override
  State<CoinBuyPage> createState() => _CoinBuyPageState();
}

class _CoinBuyPageState extends State<CoinBuyPage>
    with AutomaticKeepAliveClientMixin {
  var logger = Logger();

  Profile _profile = Profile.init();
  List<Coin> _list = [];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int _listMaxLength = Define.DEFAULT_BOARD_GET_LENGTH;

  int _selected = -1;

  final List<double> _sliderList = [];

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await getCoinList();
    _profile = await App.getProfile();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getCoinList() async {
    if (FirebaseAuth.instance.currentUser == null) {
      await Future.delayed(const Duration(seconds: 2));
    }
    _list = await App.getCoinList(withoutNoTrade: true);
    for (Coin row in _list) {
      _sliderList.add(0);
    }
  }

  void _onRefresh() async {
    logger.i("_onRefresh");
    _listMaxLength = Define.DEFAULT_BOARD_GET_LENGTH;
    await init();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    logger.i("loading");
    _listMaxLength =
        _listMaxLength + Define.DEFAULT_BOARD_GET_LENGTH > _list.length
            ? _list.length
            : _listMaxLength + Define.DEFAULT_BOARD_GET_LENGTH;
    await Future.delayed(const Duration(seconds: 1));
    // loadAd();
    if (mounted) {
      setState(() {});
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

  double width60 = width * 0.6;
    int coinQuantity = 0;

    for (CoinBalance row in _profile.coin_balance ?? []) {
      coinQuantity += row.quantity;
    }

    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        header: ClassicHeader(
          idleText: "header_idle_text".tr,
          releaseText: "header_release_text".tr,
          refreshingText: "header_loading_text".tr,
          completeText: "header_complete_text".tr,
        ),
        enablePullDown: true,
        onRefresh: _onRefresh,
        footer: ClassicFooter(
          idleText: "footer_can_loading_text".tr,
          canLoadingText: "footer_can_loading_text".tr,
          loadingText: "footer_loading_text".tr,
        ),
        enablePullUp: _list.length > _listMaxLength,
        onLoading: _onLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  sprintf("coin_buy_description".tr,
                      [Define.COIN_BUY_FEE_PERCENT.toInt().toString()]),
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
                children: List.generate(
                    _list.length > _listMaxLength
                        ? _listMaxLength
                        : _list.length, (index) {
                  double? price = _list[index].price_history != null
                      ? _list[index].price_history!.last.price +
                          (_list[index].price_history!.last.price *
                              Define.COIN_BUY_FEE_PERCENT)
                      : null;
                  //
                  // List<double> diffList = [];
                  // double diffPercentage = 0;
                  // if (_list[index].price_history != null) {
                  //   double firstPrice = _list[index].price_history![0].price;
                  //   double lastPrice = _list[index]
                  //       .price_history![_list[index].price_history!.length - 1]
                  //       .price;
                  //   if (_list[index].price_history!.length > 1) {
                  //     for (Price row in _list[index].price_history!) {
                  //       diffList.add(firstPrice - row.price);
                  //     }
                  //   }
                  //   diffPercentage =
                  //       Utils.diffPercentage(firstPrice, lastPrice);
                  // }
                  return Column(
                    children: [
                      ExpansionTile(
                        key: Key('builder ${_selected.toString()}'),
                        initiallyExpanded: index == _selected,
                        leading: badges.Badge(
                          badgeStyle: const badges.BadgeStyle(
                            badgeColor: Colors.white,
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          position: badges.BadgePosition.bottomEnd(),
                          badgeContent: Text(_list[index].rank.toString(),
                              style: const TextStyle(fontSize: 8)),
                          child: Icon(
                              _getCryptoIcon(_list[index].id.split("-")[0]),
                              color: Color(_list[index].color!.toInt()),
                          ),
                        ),
                        title: Text(_list[index].name,
                            style: const TextStyle(color: Colors.black)),
                        subtitle: _list[index].diffList==null?null:TinyColumnChart(
                          data: _list[index].diffList!,
                          width: width60,
                          height: 10,
                          options: const TinyColumnChartOptions(
                            positiveColor: Color(0xFF27A083),
                            negativeColor: Color(0xFFE92F3C),
                            showAxis: true,
                          ),
                        ),
                        trailing: _list[index].price_history != null
                            ? Text("${price!.toStringAsPrecision(7)}(${_list[index].diffPercentage!.toStringAsPrecision(1)}%)")
                            : Chip(
                                label: Text("no_trade".tr),
                                backgroundColor: Colors.red,
                                labelStyle: const TextStyle(color: Colors.white)),
                        onExpansionChanged: (changed) {
                          if (changed) {
                            setState(() {
                              _selected = index;
                            });
                          } else {
                            setState(() {
                              _selected = -1;
                            });
                          }
                        },
                        children: [
                          SizedBox(
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Slider(
                                  value: _sliderList[index],
                                  max: !Utils.isValidNilEmptyDouble(price)
                                      ? 1
                                      : (_profile.point ~/ price!).toDouble(),
                                  divisions: 5,
                                  label: _sliderList[index].round().toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      _sliderList[index] = value;
                                    });
                                  },
                                ),
                                AppButton(
                                    context,
                                    "${_sliderList[index].round()}${_list[index].symbol} ${"buy".tr}",
                                    pBtnWidth: 0.3,
                                    disable: _sliderList[index] == 0,
                                    onTap: () async {
                                  setState(() {
                                    _isPressed = true;
                                  });
                                  CoinBalance coinBalance = CoinBalance(
                                    id: _list[index].id,
                                    name: _list[index].name,
                                    price: price!,
                                    quantity: _sliderList[index].round(),
                                    created_at: Utils.getDateTimeKey(),
                                  );
                                  _profile = await App.buyCoin(
                                      _profile.key, coinBalance);
                                  logger.i(_profile);
                                  setState(() {
                                    _selected = -1;
                                    _sliderList[index]=0;
                                    _isPressed = false;
                                  });
                                }),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
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
