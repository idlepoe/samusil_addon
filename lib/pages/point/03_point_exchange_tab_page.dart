import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:samusil_addon/pages/point/04_coin_buy_page.dart';

import '../../define/define.dart';
import '05_coin_sell_page.dart';

class PointExchangeTabPage extends StatefulWidget {
  const PointExchangeTabPage({super.key});

  @override
  State<PointExchangeTabPage> createState() => _PointExchangeTabPageState();
}

class _PointExchangeTabPageState extends State<PointExchangeTabPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();


  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("point_market".tr,
            style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR)),
        backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
        iconTheme: const IconThemeData(
          color: Define.APP_BAR_TITLE_TEXT_COLOR,
        ),
        elevation: 0,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [CoinBuyPage(), CoinSellPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(LineIcons.shoppingCart),
              label: "buy".tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(LineIcons.shippingFast),
              label: "sell".tr,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
          }),
    );
  }
}
