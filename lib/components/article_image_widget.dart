import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showLoadingIndicator;
  final int? additionalImageCount;

  const ArticleImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
    this.onLongPress,
    this.showLoadingIndicator = true,
    this.additionalImageCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: width ?? double.infinity,
              height: height,
              placeholder: showLoadingIndicator
                  ? (context, url) => Container(
                      width: width ?? double.infinity,
                      height: height ?? 200,
                      color: const Color(0xFFF8F9FA),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF0064FF),
                          ),
                        ),
                      ),
                    )
                  : null,
              errorWidget: (context, url, error) => Container(
                width: width ?? double.infinity,
                height: height ?? 200,
                color: const Color(0xFFF8F9FA),
                child: const Center(
                  child: Icon(Icons.error, color: Colors.grey),
                ),
              ),
            ),
          ),
          if (additionalImageCount != null && additionalImageCount! > 0)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+$additionalImageCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
} 