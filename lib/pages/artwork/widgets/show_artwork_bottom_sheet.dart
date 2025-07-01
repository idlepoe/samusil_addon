import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:office_lounge/components/appSnackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/profile_controller.dart';
import '../../../models/artwork.dart';
import '../artwork_controller.dart';

void showArtworkBottomSheet(
  BuildContext context,
  Artwork artwork,
  bool isOwned,
  int userPoints,
) {
  final controller = Get.find<ArtworkController>();
  final price = artwork.price;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 24,
              offset: Offset(0, -8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 닫기 버튼 (상단 정렬)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF6B7684)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (isOwned) ...[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: artwork.mainImage,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "🎨 ${artwork.nameKr}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF191F28),
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow("👤 작가", artwork.writer),
                _buildInfoRow("📆 제작년도", artwork.manufactureYear),
                _buildInfoRow("🖌️ 재료", artwork.standard),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildTossButton(
                        onPressed: () {
                          final encodedTitle = Uri.encodeComponent(
                            artwork.nameKr,
                          );
                          final encodedWriter = Uri.encodeComponent(
                            artwork.writer,
                          );
                          final url =
                              'https://sema.seoul.go.kr/kr/knowledge_research/collection/list?currentPage=1&kwdValue=$encodedTitle&wriName=$encodedWriter&artKname=$encodedTitle';
                          launchUrl(
                            Uri.parse(url),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        icon: Icons.open_in_new,
                        label: "작품 정보 더 보기",
                        backgroundColor: const Color(0xFFF2F4F6),
                        textColor: const Color(0xFF191F28),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTossButton(
                        onPressed: () async {
                          final profileController =
                              Get.find<ProfileController>();
                          final success = await profileController
                              .updateProfileImage(artwork.mainImage);
                          if (success) {
                            AppSnackbar.success('프로필 사진이 변경되었습니다!');
                          } else {
                            AppSnackbar.error('프로필 사진 변경에 실패했습니다.');
                          }
                        },
                        icon: Icons.account_circle,
                        label: "내 아바타로",
                        backgroundColor: const Color(0xFF0064FF),
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: artwork.mainImage,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      color: Colors.grey.withOpacity(0.6),
                      colorBlendMode: BlendMode.saturation,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "🎨 ${artwork.nameKr}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF191F28),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE5E8EB),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "💰 소장 가격",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7684),
                            ),
                          ),
                          Text(
                            "$price pt",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0064FF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "🙋‍♂️ 내 보유 포인트",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7684),
                            ),
                          ),
                          Text(
                            "$userPoints pt",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color:
                                  userPoints >= price
                                      ? const Color(0xFF00C851)
                                      : const Color(0xFFFF3B30),
                            ),
                          ),
                        ],
                      ),
                      if (userPoints < price) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF3B30).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '포인트가 부족해요 😢',
                            style: TextStyle(
                              color: Color(0xFFFF3B30),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (userPoints >= price)
                  SizedBox(
                    width: double.infinity,
                    child: _buildTossButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await controller.purchaseArtwork(artwork);
                      },
                      icon: Icons.shopping_cart,
                      label: "소장하기",
                      backgroundColor: const Color(0xFF0064FF),
                      textColor: Colors.white,
                    ),
                  ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7684),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191F28),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildTossButton({
  required VoidCallback onPressed,
  required IconData icon,
  required String label,
  required Color backgroundColor,
  required Color textColor,
}) {
  return Container(
    height: 48,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: backgroundColor.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: textColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
