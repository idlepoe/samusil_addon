import 'package:get/get.dart';
import '../../../define/arrays.dart';
import '../../../models/board_info.dart';
import 'article_edit_controller.dart';

class ArticleEditBinding extends Bindings {
  final BoardInfo? boardInfo;
  final String? articleId;

  ArticleEditBinding({this.boardInfo, this.articleId});

  @override
  void dependencies() {
    Get.lazyPut<ArticleEditController>(
      () => ArticleEditController(articleKey: articleId),
    );
  }
}
