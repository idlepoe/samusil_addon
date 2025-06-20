import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/article.dart';

class ArticleTitleWidget extends StatelessWidget {
  final Article article;
  final bool hasPicture;
  final bool hasNoContents;

  const ArticleTitleWidget({
    super.key,
    required this.article,
    required this.hasPicture,
    required this.hasNoContents,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasPicture) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF0064FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('🖼', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            article.title + (hasNoContents ? " (${"no_contents".tr})" : ""),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (article.count_comments > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF0064FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${article.count_comments}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
