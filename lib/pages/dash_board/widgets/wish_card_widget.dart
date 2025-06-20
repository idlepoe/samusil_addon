import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';

import '../../../utils/util.dart';
import '../../wish/wish_controller.dart';

class WishCardWidget extends GetView<WishController> {
  const WishCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () async {
          // Wish 페이지로 이동
          Get.toNamed('/wish');
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
                  if (controller.wishList.length > 0)
                    Text(
                      "${"total_wish".tr} ${Utils.numberFormat(controller.wishList.length)}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                ],
              ),
              if (controller.wishList.isNotEmpty)
                SizedBox(
                  height: 60,
                  child: ScrollLoopAutoScroll(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: List.generate(controller.wishList.length, (
                        index,
                      ) {
                        final wish = controller.wishList[index];
                        return ListTile(
                          leading: Text("${wish.index} ${"place".tr}"),
                          title: Text(wish.comments),
                          subtitle: Text(
                            "${wish.nick_name}(${wish.streak}${"streak".tr})",
                          ),
                        );
                      }),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
