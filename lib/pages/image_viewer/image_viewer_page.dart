import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:office_lounge/utils/util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageViewerPage extends StatefulWidget {
  final String imageUrl;
  final String? heroTag;

  const ImageViewerPage({super.key, required this.imageUrl, this.heroTag});

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  final TransformationController _transformationController =
      TransformationController();
  bool _isDownloading = false;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  Future<void> _downloadImage() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      // Utils의 saveNetworkImage 함수 사용 (bottom sheet와 동일한 로직)
      bool result = await Utils.saveNetworkImage([widget.imageUrl]);
      if (result) {
        Fluttertoast.showToast(msg: "이미지 저장 성공");
      } else {
        Fluttertoast.showToast(msg: "이미지 저장 실패");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "이미지 저장 실패");
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
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
                    _resetZoom();
                  },
                ),

                // 이미지 다운로드 옵션
                ListTile(
                  leading:
                      _isDownloading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(
                            Icons.download,
                            color: Color(0xFF0064FF),
                          ),
                  title: Text(
                    _isDownloading ? '다운로드 중...' : '이미지 다운로드',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _isDownloading ? Colors.grey : Colors.black,
                    ),
                  ),
                  onTap:
                      _isDownloading
                          ? null
                          : () {
                            Navigator.pop(context);
                            _downloadImage();
                          },
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('이미지 보기', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: _showImageOptions,
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: GestureDetector(
        onLongPress: _showImageOptions,
        child: Center(
          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,
            maxScale: 5.0,
            child:
                widget.heroTag != null
                    ? Hero(
                      tag: widget.heroTag!,
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.contain,
                        placeholder:
                            (context, url) => const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => const Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                      ),
                    )
                    : CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.contain,
                      placeholder:
                          (context, url) => const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                    ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 확대/축소 리셋 버튼
          FloatingActionButton(
            heroTag: "reset_zoom",
            mini: true,
            backgroundColor: Colors.white.withOpacity(0.9),
            onPressed: _resetZoom,
            child: const Icon(Icons.center_focus_strong, color: Colors.black),
          ),
          const SizedBox(height: 10),
          // 다운로드 버튼
          FloatingActionButton(
            heroTag: "download",
            backgroundColor: const Color(0xFF0064FF),
            onPressed: _isDownloading ? null : _downloadImage,
            child:
                _isDownloading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Icon(Icons.download, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
