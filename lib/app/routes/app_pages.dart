import 'package:get/get.dart';

import '../modules/chat_panel/bindings/chat_panel_binding.dart';
import '../modules/chat_panel/views/chat_panel_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/upload_panel/bindings/upload_panel_binding.dart';
import '../modules/upload_panel/views/upload_panel_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.UPLOAD_PANEL,
      page: () => const UploadPanelView(),
      binding: UploadPanelBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_PANEL,
      page: () => const ChatPanelView(),
      binding: ChatPanelBinding(),
    ),
  ];
}
