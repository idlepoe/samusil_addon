import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

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
  void _onNotificationTapped(NotificationResponse response) {
    _logger.i('알림 클릭: ${response.payload}');

    // 페이로드에서 데이터 추출
    if (response.payload != null) {
      try {
        // 페이로드 문자열을 파싱 (간단한 형태)
        final payload = response.payload!;
        if (payload.contains('article_id')) {
          // 게시글 ID 추출 (간단한 파싱)
          final articleIdMatch = RegExp(
            r'article_id[":\s]+([^,}]+)',
          ).firstMatch(payload);
          if (articleIdMatch != null) {
            final articleId =
                articleIdMatch.group(1)?.replaceAll('"', '').trim();
            if (articleId != null) {
              // 해당 게시글로 이동
              Get.toNamed('/detail/$articleId');
              return;
            }
          }
        }
      } catch (e) {
        _logger.e('알림 페이로드 파싱 오류: $e');
      }
    }

    // 기본적으로 대시보드로 이동
    Get.toNamed('/');
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
}
