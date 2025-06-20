import 'package:get/get.dart';
import 'article_search_controller.dart';

class ArticleSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticleSearchController>(() => ArticleSearchController());
  }
}
