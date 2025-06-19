import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:samusil_addon/pages/00_dash_board_page.dart';
import 'package:samusil_addon/utils/http_service.dart';
import 'package:samusil_addon/utils/app.dart';
import 'package:samusil_addon/utils/router.dart';

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
      home: const DashBoardPage(),
      builder:
          (context, child) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
          ),
    );
  }
}
