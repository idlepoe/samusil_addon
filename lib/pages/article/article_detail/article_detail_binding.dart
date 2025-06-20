import 'package:get/get.dart';
import 'article_detail_controller.dart';

class ArticleDetailBinding extends Bindings {
  @override
  void dependencies() {
    // 라우트 파라미터에서 articleKey를 가져와서 컨트롤러에 전달
    Get.lazyPut<ArticleDetailController>(
      () => ArticleDetailController(),
      fenix: true, // 페이지가 닫힐 때 컨트롤러를 유지하지 않음
    );
  }
}
