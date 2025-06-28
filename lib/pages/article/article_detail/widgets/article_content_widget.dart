import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:office_lounge/components/article_image_widget.dart';
import 'package:office_lounge/components/appSnackbar.dart';
import 'package:office_lounge/pages/image_viewer/image_viewer_page.dart';
import 'package:office_lounge/pages/dash_board/dash_board_controller.dart';
import 'package:logger/logger.dart';

import '../article_detail_controller.dart';

class ArticleContentWidget extends GetView<ArticleDetailController> {
  static final logger = Logger();

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
      child: SelectionArea(
        child: Text(
          controller.article.value.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    final heroTag = "article_image_${controller.article.value.id}_$index";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Hero(
        tag: heroTag,
        child: ArticleImageWidget(
          imageUrl: content.contents,
          onTap: () => _navigateToImageViewer(content.contents, heroTag),
          onLongPress: () => _showImageOptions(content.contents, heroTag),
        ),
      ),
    );
  }

  Widget _buildTextContent(content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: SelectionArea(
        child: Linkify(
          text: content.contents,
          options: const LinkifyOptions(humanize: false),
          style: const TextStyle(fontSize: 16),
          onOpen: (link) async {
            if (_isYoutubeLink(link.url)) {
              _showYoutubePlayer(link.url);
            } else {
              await launchUrlString(
                link.url,
                mode: LaunchMode.externalApplication,
              );
            }
          },
        ),
      ),
    );
  }

  bool _isYoutubeLink(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  void _showYoutubePlayer(String url) {
    final videoId = YoutubePlayerController.convertUrlToId(url);
    if (videoId == null) {
      logger.e('Invalid YouTube URL: $url');
      return;
    }

    logger.i('Opening YouTube player for video ID: $videoId');

    // 대시보드 컨트롤러 가져오기
    final dashboardController = Get.find<DashBoardController>();
    final wasPlaying = dashboardController.isPlaying.value;

    if (wasPlaying) {
      dashboardController.togglePlayPause();
      logger.i('Paused dashboard player');
    }

    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showVideoAnnotations: false,
        showFullscreenButton: true,
        loop: false,
        enableCaption: true,
      ),
    );

    logger.i('Created YouTube controller');

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: YoutubePlayer(
                    controller: controller,
                    aspectRatio: 16 / 9,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        logger.i('Closing YouTube player dialog');
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    ).then((_) {
      logger.i('YouTube player dialog closed');
      controller.close();
      if (wasPlaying) {
        logger.i('Resuming dashboard player');
        dashboardController.togglePlayPause();
      }
    });
  }

  void _navigateToImageViewer(String imageUrl, String heroTag) {
    Get.to(
      () => ImageViewerPage(imageUrl: imageUrl, heroTag: heroTag),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _showImageOptions(String imageUrl, String heroTag) {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 핸들 바
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // 이미지 보기 옵션
                ListTile(
                  leading: const Icon(Icons.zoom_in, color: Color(0xFF0064FF)),
                  title: const Text(
                    '이미지 보기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToImageViewer(imageUrl, heroTag);
                  },
                ),

                // 이미지 다운로드 옵션
                ListTile(
                  leading: const Icon(Icons.download, color: Color(0xFF0064FF)),
                  title: const Text(
                    '이미지 다운로드',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    controller.saveImage(imageUrl);
                  },
                ),

                const SizedBox(height: 10),
              ],
            ),
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
