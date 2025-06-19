import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';

import '../../../models/wish.dart';
import '../../../utils/util.dart';
import '../dash_board_controller.dart';

class WishCardWidget extends StatelessWidget {
  final DashBoardController controller;
  final List<Wish> wishList;
  final int wishCount;

  const WishCardWidget({
    super.key,
    required this.controller,
    required this.wishList,
    required this.wishCount,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await controller.showKeyboardInput();
      },
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const Image(
                  height: 180,
                  width: double.infinity,
                  image: AssetImage("assets/wish_of_stone.jpg"),
                  fit: BoxFit.fitWidth,
                ),
                if (wishCount > 0)
                  Text(
                    "${"total_wish".tr} ${Utils.numberFormat(wishCount)}",
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
              ],
            ),
            if (wishList.isNotEmpty)
              SizedBox(
                height: 60,
                child: ScrollLoopAutoScroll(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: List.generate(wishList.length, (index) {
                      return ListTile(
                        leading: Text("${wishList[index].index} ${"place".tr}"),
                        title: Text(wishList[index].comments),
                        subtitle: Text(
                          "${wishList[index].nick_name}(${wishList[index].streak}${"streak".tr})",
                        ),
                      );
                    }),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
