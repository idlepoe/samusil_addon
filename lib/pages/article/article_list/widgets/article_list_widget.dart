import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/article.dart';
import 'article_item_widget.dart';

class ArticleListWidget extends StatelessWidget {
  final List<Article> articles;
  final bool Function(Article) hasPicture;
  final bool Function(Article) hasNoContents;

  const ArticleListWidget({
    super.key,
    required this.articles,
    required this.hasPicture,
    required this.hasNoContents,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return ArticleItemWidget(article: article);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(height: 1, color: Colors.grey[200]);
      },
    );
  }
}
