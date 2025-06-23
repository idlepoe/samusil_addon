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
                      "지금까지 모인 소원 ${Utils.numberFormat(controller.wishList.length)}개",
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
                        final isMyWish =
                            wish.uid == controller.profile.value.uid;

                        return ListTile(
                          leading: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color:
                                  isMyWish
                                      ? const Color(0xFF00C851).withOpacity(0.1)
                                      : const Color(
                                        0xFF0064FF,
                                      ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                "${wish.index}",
                                style: TextStyle(
                                  color:
                                      isMyWish
                                          ? const Color(0xFF00C851)
                                          : const Color(0xFF0064FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  wish.comments,
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isMyWish)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF00C851,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    "나",
                                    style: TextStyle(
                                      color: Color(0xFF00C851),
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text(
                            "${wish.nick_name}(${wish.streak}연속)",
                            style: const TextStyle(fontSize: 12),
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
