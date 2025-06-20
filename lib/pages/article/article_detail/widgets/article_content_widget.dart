import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../article_detail_controller.dart';

class ArticleContentWidget extends GetView<ArticleDetailController> {
  const ArticleContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: List.generate(controller.article.value.contents.length, (
          index,
        ) {
          final content = controller.article.value.contents[index];
          return _buildContentItem(content, index);
        }),
      ),
    );
  }

  Widget _buildContentItem(content, int index) {
    if (content.isPicture) {
      return _buildImageContent(content, index);
    } else {
      return _buildTextContent(content);
    }
  }

  Widget _buildImageContent(content, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onLongPress: () => controller.saveImage(content.contents),
        onTap: () => _showImageDialog(content.contents),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            width: double.infinity,
            imageUrl: content.contents,
            progressIndicatorBuilder:
                (context, url, downloadProgress) => Container(
                  height: 200,
                  color: const Color(0xFFF8F9FA),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF0064FF),
                      ),
                    ),
                  ),
                ),
            errorWidget:
                (context, url, error) => Container(
                  height: 200,
                  color: const Color(0xFFF8F9FA),
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.grey),
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(content) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Html(
        data: content.contents,
        style: {
          "body": Style(
            fontSize: FontSize(16),
            color: Colors.black,
            lineHeight: LineHeight(1.6),
          ),
        },
        onLinkTap: (url, __, ___) async {
          if (await canLaunchUrlString(url!)) {
            await launchUrlString(url);
          } else {
            Get.snackbar(
              '오류',
              '링크를 열 수 없습니다',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
      ),
    );
  }

  void _showImageDialog(String imageUrl) {
    Get.dialog(
      Stack(
        alignment: Alignment.center,
        children: [
          ExtendedImage.network(
            imageUrl,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (state) {
              return GestureConfig(
                minScale: 0.9,
                animationMinScale: 0.7,
                maxScale: 3.0,
                animationMaxScale: 3.5,
                speed: 1.0,
                inertialSpeed: 100.0,
                initialScale: 1.0,
                inPageView: false,
                initialAlignment: InitialAlignment.center,
              );
            },
          ),
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
