import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:samusil_addon/components/article_image_widget.dart';

import '../article_detail_controller.dart';

class ArticleContentWidget extends GetView<ArticleDetailController> {
  const ArticleContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          _buildTitle(),
          const SizedBox(height: 8),
          // Contents
          ...List.generate(controller.article.value.contents.length, (index) {
            final content = controller.article.value.contents[index];
            return _buildContentItem(content, index);
          }),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        controller.article.value.title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ArticleImageWidget(
        imageUrl: content.contents,
        onTap: () => _showImageDialog(content.contents),
        onLongPress: () => controller.saveImage(content.contents),
      ),
    );
  }

  Widget _buildTextContent(content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Html(
        data: content.contents,
        style: {
          "body": Style(
            fontSize: FontSize(16),
            color: Colors.black87,
            lineHeight: LineHeight(1.6),
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
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
