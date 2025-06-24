import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../fishing_game_controller.dart';
import '../../../models/fish.dart';

/// 물고기 판매 다이얼로그
class FishSellDialog extends GetView<FishingGameController> {
  final Fish fish;
  final int maxCount;

  const FishSellDialog({super.key, required this.fish, required this.maxCount});

  @override
  Widget build(BuildContext context) {
    final TextEditingController sellCountController = TextEditingController(
      text: '1',
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 제목
            Text(
              '${fish.name} 판매',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 물고기 정보
            Row(
              children: [
                Text(fish.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '보유 수량: ${maxCount}마리',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '판매가: ${fish.reward}P/마리',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 판매 수량 입력
            Row(
              children: [
                const Text(
                  '판매 수량:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: sellCountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      suffixText: '마리',
                    ),
                    onChanged: (value) {
                      final count = int.tryParse(value) ?? 0;
                      if (count > maxCount) {
                        sellCountController.text = maxCount.toString();
                        sellCountController
                            .selection = TextSelection.fromPosition(
                          TextPosition(offset: sellCountController.text.length),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 예상 수익 표시
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: ValueListenableBuilder(
                valueListenable: sellCountController,
                builder: (context, value, child) {
                  final count = int.tryParse(value.text) ?? 0;
                  final totalPrice = count * fish.reward;
                  return Text(
                    '예상 수익: ${totalPrice}P',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 버튼들
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final sellCount =
                          int.tryParse(sellCountController.text) ?? 0;
                      if (sellCount <= 0 || sellCount > maxCount) {
                        Get.snackbar(
                          '오류',
                          '올바른 수량을 입력해주세요.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      Navigator.of(context).pop();
                      controller.sellFish(fish, sellCount);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '판매',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
