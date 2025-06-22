import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:samusil_addon/pages/splash/splash_view.dart';
import 'package:samusil_addon/pages/splash/splash_binding.dart';
import 'package:samusil_addon/pages/dash_board/dash_board_view.dart';
import 'package:samusil_addon/pages/article/article_list/article_list_view.dart';
import 'package:samusil_addon/pages/article/article_edit/article_edit_view.dart';
import 'package:samusil_addon/pages/article/article_detail/article_detail_view.dart';
import 'package:samusil_addon/pages/article/article_search/article_search_view.dart';
import 'package:samusil_addon/pages/option/01_option_page.dart';
import 'package:samusil_addon/pages/option/02_privacy_policy_page.dart';
import 'package:samusil_addon/pages/wish/wish_view.dart';
import 'package:samusil_addon/utils/get_routes.dart';
import 'package:samusil_addon/utils/http_service.dart';
import 'package:samusil_addon/utils/app.dart';
import 'package:samusil_addon/utils/notification_service.dart';
import 'package:samusil_addon/controllers/profile_controller.dart';

import 'define/define.dart';
import 'firebase_options.dart';
import 'locale/messages.dart';

// 전역 logger 인스턴스
final logger = Logger();

// FCM 백그라운드 메시지 핸들러
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 백그라운드에서 로컬 알림 표시
  final notificationService = NotificationService();
  await notificationService.initialize();

  await notificationService.showNotification(
    title: message.notification?.title ?? '새 알림',
    body: message.notification?.body ?? '',
    payload: message.data.toString(),
  );

  logger.i('백그라운드 메시지 수신: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 로컬 알림 서비스 초기화
  await NotificationService().initialize();

  // FCM 초기화
  await _initializeFirebaseMessaging();

  // HttpService 초기화 (baseUrl은 나중에 설정)
  HttpService().initialize();

  // Cloud Functions baseUrl 설정
  App.setCloudFunctionsBaseUrl(Define.CLOUD_FUNCTIONS_BASE_URL);

  runApp(const MyApp());
}

/// Firebase Messaging 초기화
Future<void> _initializeFirebaseMessaging() async {
  try {
    // 백그라운드 메시지 핸들러 등록
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 알림 권한 요청
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

    logger.i('FCM 권한 상태: ${settings.authorizationStatus}');

    // 포그라운드 메시지 핸들러
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      logger.i('포그라운드 메시지 수신: ${message.messageId}');

      // 포그라운드에서 로컬 알림 표시
      await NotificationService().showNotification(
        title: message.notification?.title ?? '새 알림',
        body: message.notification?.body ?? '',
        payload: message.data.toString(),
      );
    });

    // 알림 클릭 핸들러
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.i('알림 클릭: ${message.messageId}');

      // 알림 데이터에서 게시글 ID 추출
      final data = message.data;
      if (data['type'] == 'comment' || data['type'] == 'like') {
        final articleId = data['article_id'];
        if (articleId != null) {
          // 해당 게시글로 이동
          Get.toNamed('/article-detail/$articleId');
        }
      }
    });
  } catch (e) {
    logger.e('FCM 초기화 오류: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Samusil Addon',
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
      locale: Get.deviceLocale,
      translations: Messages(),
      unknownRoute: GetPage(name: '/notfound', page: () => const SplashView()),
    );
  }
}
