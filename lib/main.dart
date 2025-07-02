import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:office_lounge/pages/splash/splash_view.dart';
import 'package:office_lounge/pages/splash/splash_binding.dart';
import 'package:office_lounge/pages/dash_board/dash_board_view.dart';
import 'package:office_lounge/pages/article/article_list/article_list_view.dart';
import 'package:office_lounge/pages/article/article_edit/article_edit_view.dart';
import 'package:office_lounge/pages/article/article_detail/article_detail_view.dart';
import 'package:office_lounge/pages/article/article_search/article_search_view.dart';
import 'package:office_lounge/pages/option/01_option_page.dart';
import 'package:office_lounge/pages/option/02_privacy_policy_page.dart';
import 'package:office_lounge/pages/wish/wish_view.dart';
import 'package:office_lounge/utils/get_routes.dart';
import 'package:office_lounge/utils/http_service.dart';
import 'package:office_lounge/utils/app.dart';
import 'package:office_lounge/utils/notification_service.dart';
import 'package:office_lounge/controllers/profile_controller.dart';
import 'package:office_lounge/utils/schedule_service.dart';

import 'define/define.dart';
import 'firebase_options.dart';

// 전역 logger 인스턴스 - 릴리즈에서도 로그 출력
final logger = Logger(
  filter: ProductionFilter(), // 릴리즈에서도 로그 출력
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
  output: ConsoleOutput(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 앱 시작 로그
  logger.i('앱 시작 - OfficeLounge');

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    logger.i('Firebase 초기화 완료');

    // 로케일 데이터 초기화
    await initializeDateFormatting('ko_KR', null);
    logger.i('로케일 데이터 초기화 완료');

    // 로컬 알림 서비스 초기화
    await NotificationService().initializeFCM();
    logger.i('알림 서비스 초기화 완료');

    // 일정관리 서비스 초기화
    await ScheduleService.initialize();
    logger.i('일정관리 서비스 초기화 완료');

    // HttpService 초기화 (baseUrl은 나중에 설정)
    HttpService().initialize();
    logger.i('HttpService 초기화 완료');

    // Cloud Functions baseUrl 설정
    App.setCloudFunctionsBaseUrl(Define.CLOUD_FUNCTIONS_BASE_URL);
    logger.i('Cloud Functions URL 설정 완료: ${Define.CLOUD_FUNCTIONS_BASE_URL}');
  } catch (e) {
    logger.e('앱 초기화 중 오류 발생: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Samusil Addon',
      locale: const Locale('ko', 'KR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF0064FF), // 토스 스타일 포인트 컬러
        scaffoldBackgroundColor: const Color(0xFFF4F6F8), // 토스 스타일 배경색
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF333D4B),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF333D4B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      initialRoute: '/splash',
      getPages: GetRoutes.routes,

      unknownRoute: GetPage(name: '/notfound', page: () => const SplashView()),
    );
  }
}
