import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../artwork_controller.dart';
import 'artwork_card.dart';

class ArtworkGridView extends StatelessWidget {
  ArtworkGridView({super.key});

  final ArtworkController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.fetchInitialData,
      child: Obx(() {
        if (controller.filteredArtworks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: Color(0xFFB0B8C1),
                ),
                SizedBox(height: 16),
                Text(
                  '아무것도 없습니다.',
                  style: TextStyle(
                    color: Color(0xFF8B95A1),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
        return MasonryGridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemCount: controller.filteredArtworks.length,
          itemBuilder: (context, index) {
            final artwork = controller.filteredArtworks[index];
            final isOwned = controller.isOwned(artwork.id);
            return ArtworkCard(artwork: artwork, isOwned: isOwned);
          },
        );
      }),
    );
  }
}
