import 'package:get/get.dart';
import 'favorite_playlist_controller.dart';

class FavoritePlaylistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritePlaylistController>(() => FavoritePlaylistController());
  }
}
