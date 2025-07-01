import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../artwork_controller.dart';

class ArtworkFAB extends StatelessWidget {
  const ArtworkFAB({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ArtworkController>();

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0064FF), // Toss 브랜드 블루
              Color(0xFF3182F6), // 밝은 블루
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0064FF).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: controller.isLoading.value ? null : controller.drawGacha,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child:
                    controller.isLoading.value
                        ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                            strokeCap: StrokeCap.round,
                          ),
                        )
                        : const Icon(
                          Icons.casino,
                          color: Colors.white,
                          size: 24,
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
