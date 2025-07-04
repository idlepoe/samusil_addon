import 'package:get/get.dart';
import 'article_list_controller.dart';

class ArticleListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticleListController>(() => ArticleListController());
  }
}
