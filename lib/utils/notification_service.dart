import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../pages/splash/splash_view.dart';
import '../define/define.dart';
import '../utils/app.dart';
import '../utils/http_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final Logger _logger = Logger();

  /// 알림 서비스를 초기화합니다.
  Future<void> initialize() async {
    try {
      // Android 설정
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS 설정
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      // 초기화 설정
      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // 알림 플러그인 초기화
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Android 채널 생성
      await _createNotificationChannel();

      _logger.i('로컬 알림 서비스 초기화 완료');
    } catch (e) {
      _logger.e('로컬 알림 서비스 초기화 오류: $e');
    }
  }

  /// Android 알림 채널을 생성합니다.
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default',
      '기본 알림',
      description: '기본 알림 채널',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// 알림을 표시합니다.
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    int id = 0,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'default',
            '기본 알림',
            channelDescription: '기본 알림 채널',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            playSound: true,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(id, title, body, details, payload: payload);

      _logger.i('알림 표시 완료: $title');
    } catch (e) {
      _logger.e('알림 표시 오류: $e');
    }
  }

  /// 알림 클릭 이벤트를 처리합니다.
  void _onNotificationTapped(NotificationResponse response) async {
    _logger.i('알림 클릭: ${response.payload}');

    if (response.payload != null) {
      try {
        final payload = response.payload!;
        String? type;
        String? articleId;
        if (payload.contains('type')) {
          final typeMatch = RegExp(r'type[":\s]+([^,}]+)').firstMatch(payload);
          if (typeMatch != null) {
            type = typeMatch.group(1)?.replaceAll('"', '').trim();
          }
        }
        if (payload.contains('article_id')) {
          final articleIdMatch = RegExp(
            r'article_id[":\s]+([^,}]+)',
          ).firstMatch(payload);
          if (articleIdMatch != null) {
            articleId = articleIdMatch.group(1)?.replaceAll('"', '').trim();
          }
        }
        if (type == 'comment' || type == 'like' || type == 'sub_comment') {
          if (articleId != null) {
            await navigateAfterPush('/detail/$articleId');
            return;
          }
        } else if (type == 'horse_race') {
          await navigateAfterPush('/horse-race-history');
          return;
        } else if (type == 'system') {
          await navigateAfterPush('/notifications');
          return;
        }
      } catch (e) {
        _logger.e('알림 페이로드 파싱 오류: $e');
      }
    }
    await navigateAfterPush('/');
  }

  /// 모든 알림을 제거합니다.
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    _logger.i('모든 알림 제거 완료');
  }

  /// 특정 알림을 제거합니다.
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    _logger.i('알림 제거 완료: $id');
  }

  /// 보류 중인 알림을 가져옵니다.
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// FCM 백그라운드 메시지 핸들러 (static)
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    // Firebase.initializeApp이 필요하다면 여기에 추가
    // await Firebase.initializeApp(options: ...);
    final service = NotificationService();
    await service.initialize();
    await service.showNotification(
      title: message.notification?.title ?? '새 알림',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
    service._logger.i(
      '백그라운드 메시지 수신: \x1B[36m\x1B[1m${message.messageId}\x1B[0m',
    );
  }

  Future<void> initializeFCM() async {
    try {

      // 백그라운드 메시지 핸들러 등록
      FirebaseMessaging.onBackgroundMessage(
        NotificationService.firebaseMessagingBackgroundHandler,
      );

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
      _logger.i(
        'FCM 권한 상태: \x1B[32m\x1B[1m\x1B[4m${settings.authorizationStatus}\x1B[0m',
      );

      // 포그라운드 메시지 핸들러
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        _logger.i('포그라운드 메시지 수신: ${message.messageId}');
        // 포그라운드에서 로컬 알림 표시
        await showNotification(
          title: message.notification?.title ?? '새 알림',
          body: message.notification?.body ?? '',
          payload: message.data.toString(),
        );
      });

      // 알림 클릭 핸들러
      FirebaseMessaging.onMessageOpenedApp.listen((
        RemoteMessage message,
      ) async {
        _logger.i('알림 클릭: ${message.messageId}');
        final data = message.data;
        final type = data['type'];
        if (type == 'comment' || type == 'like' || type == 'sub_comment') {
          final articleId = data['article_id'];
          if (articleId != null) {
            await navigateAfterPush('/detail/$articleId');
            return;
          }
        } else if (type == 'horse_race') {
          await navigateAfterPush('/horse-race-history');
          return;
        } else if (type == 'system') {
          await navigateAfterPush('/notifications');
          return;
        }
        await navigateAfterPush('/');
      });
    } catch (e) {
      _logger.e('FCM 초기화 오류: $e');
    }
  }

  Future<void> navigateAfterPush(String route) async {
    Get.offAllNamed('/splash');
    await Future.delayed(const Duration(milliseconds: 100));
    Get.offAllNamed('/');
    await Future.delayed(const Duration(milliseconds: 100));
    if (route != '/' && route != '/splash') {
      Get.toNamed(route);
    }
  }
}
