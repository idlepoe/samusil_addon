import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../models/article.dart';
import '../../../../utils/util.dart';

class ArticleMetaWidget extends StatelessWidget {
  final Article article;

  const ArticleMetaWidget({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "${article.profile_name} • ${"count_view".tr} ${article.count_view} • ${"recommend".tr} ${article.count_like}",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        Text(
          Utils.toConvertFireDateToCommentTimeToday(
            DateFormat('yyyyMMddHHmm').format(article.created_at),
          ),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
