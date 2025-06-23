import 'package:get/get.dart';
import 'youtube_search_controller.dart';

class YouTubeSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YouTubeSearchController>(() => YouTubeSearchController());
  }
}
