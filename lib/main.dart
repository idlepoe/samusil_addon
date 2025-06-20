import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:samusil_addon/pages/dash_board/dash_board_view.dart';
import 'package:samusil_addon/pages/article/article_list/article_list_view.dart';
import 'package:samusil_addon/pages/article/article_edit/article_edit_view.dart';
import 'package:samusil_addon/pages/article/article_detail/article_detail_view.dart';
import 'package:samusil_addon/pages/article/article_search/article_search_view.dart';
import 'package:samusil_addon/pages/option/01_option_page.dart';
import 'package:samusil_addon/pages/option/02_privacy_policy_page.dart';
import 'package:samusil_addon/pages/point/02_point_information_page.dart';
import 'package:samusil_addon/pages/wish/wish_view.dart';
import 'package:samusil_addon/utils/get_routes.dart';
import 'package:samusil_addon/utils/http_service.dart';
import 'package:samusil_addon/utils/app.dart';
import 'package:samusil_addon/controllers/profile_controller.dart';

import 'define/define.dart';
import 'firebase_options.dart';
import 'locale/messages.dart';

// 전역 logger 인스턴스
final logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // HttpService 초기화 (baseUrl은 나중에 설정)
  HttpService().initialize();

  // Cloud Functions baseUrl 설정
  App.setCloudFunctionsBaseUrl(Define.CLOUD_FUNCTIONS_BASE_URL);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "app_name".tr,
      locale: Get.deviceLocale,
      translations: Messages(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: GetRoutes.routes,
    );
  }
}
