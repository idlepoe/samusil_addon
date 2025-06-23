import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';

import '../../../utils/util.dart';
import '../../wish/wish_controller.dart';

class DateWishCardWidget extends GetView<WishController> {
  const DateWishCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();

    return Obx(
      () => InkWell(
        onTap: () async {
          // Wish 페이지로 이동
          Get.toNamed('/wish');
        },
        child: Column(
          children: [
            // 날짜 헤더 섹션
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF0064FF), const Color(0xFF0052CC)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 날짜 정보
                  Row(
                    children: [
                      // 월 정보
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            today.month.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            "month".tr,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // 일 정보
                      Text(
                        today.day.toString(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 요일 정보
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          Utils.weekDayString(today.weekday),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // 소원 텍스트
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "wish".tr,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "소원을 빌어보세요",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 소원 카드 섹션
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  child: const Image(
                    height: 180,
                    width: double.infinity,
                    image: AssetImage("assets/wish_of_stone.jpg"),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                if (controller.wishList.length > 0)
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${"total_wish".tr} ${Utils.numberFormat(controller.wishList.length)}",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
              ],
            ),
            // 소원 목록 섹션
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
                      final isMyWish = wish.uid == controller.profile.value.uid;
                      
                      return ListTile(
                        leading: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: isMyWish 
                                ? const Color(0xFF00C851).withOpacity(0.1)
                                : const Color(0xFF0064FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              "${wish.index}",
                              style: TextStyle(
                                color: isMyWish ? const Color(0xFF00C851) : const Color(0xFF0064FF),
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
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00C851).withOpacity(0.1),
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
                          "${wish.nick_name}(${wish.streak}${"streak".tr})",
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
    );
  }
}
