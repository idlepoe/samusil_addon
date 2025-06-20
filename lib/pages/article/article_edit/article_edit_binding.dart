import 'package:get/get.dart';
import '../../../define/arrays.dart';
import 'article_edit_controller.dart';

class ArticleEditBinding extends Bindings {
  @override
  void dependencies() {
    // 라우트 파라미터에서 boardName 받기
    final boardName = Get.parameters['boardName'] ?? '';
    final articleId = Get.parameters['articleId'];

    if (boardName.isNotEmpty) {
      final boardInfo = Arrays.getBoardInfo(boardName);
      Get.lazyPut<ArticleEditController>(
        () => ArticleEditController(articleKey: articleId),
      );
    } else {
      Get.lazyPut<ArticleEditController>(
        () => ArticleEditController(articleKey: articleId),
      );
    }
  }
}
