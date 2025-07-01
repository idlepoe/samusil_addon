import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'artwork_controller.dart';
import 'widgets/artwork_grid_view.dart';
import 'widgets/artwork_fab.dart';

class ArtworkView extends GetView<ArtworkController> {
  const ArtworkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF191F28)),
        title: const Text(
          "🎨 서울시립미술관",
          style: TextStyle(
            color: Color(0xFF191F28),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(
            () => Row(
              children: [
                const Text(
                  '미보유 포함',
                  style: TextStyle(
                    color: Color(0xFF6B7684),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Checkbox(
                  value: controller.showUnowned.value,
                  onChanged:
                      (value) => controller.showUnowned.value = value ?? false,
                  activeColor: const Color(0xFF0064FF),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.artworks.isEmpty && controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  color: Color(0xFF0064FF),
                ),
                SizedBox(height: 16),
                Text(
                  '아트워크를 불러오고 있습니다...',
                  style: TextStyle(color: Color(0xFF6B7684), fontSize: 14),
                ),
              ],
            ),
          );
        }
        return ArtworkGridView();
      }),
      floatingActionButton: const ArtworkFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
