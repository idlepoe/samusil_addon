import 'package:get/get.dart';
import 'article_edit_controller.dart';

class ArticleEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticleEditController>(() => ArticleEditController());
  }
}
