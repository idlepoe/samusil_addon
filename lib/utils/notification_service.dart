import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../pages/splash/splash_view.dart';
import '../define/define.dart';
import '../utils/app.dart';
import '../utils/http_service.dart';
import '../utils/pending_navigation_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final Logger _logger = Logger();
  final PendingNavigationService _pendingNavigation =
      PendingNavigationService();

  /// 알림 서비스를 초기화합니다.
  Future<void> initialize() async {
    try {
      // Android 설정
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@drawable/notification_icon');

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
        onDidReceiveBackgroundNotificationResponse:
            _onBackgroundNotificationTapped,
      );

      // Android 채널 생성
      await _createNotificationChannel();

      _logger.i('🔔 로컬 알림 서비스 초기화 완료');
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
    int? id,
  }) async {
    try {
      // id가 null이면 현재 시간을 기반으로 고유한 id 생성
      final notificationId =
          id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000);

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
            icon: '@drawable/notification_icon', // icon_it.png 사용
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

      await _notifications.show(
        notificationId,
        title,
        body,
        details,
        payload: payload,
      );

      _logger.i('🔔 알림 표시 완료: $title (ID: $notificationId)');
      _logger.i('🔔 알림 페이로드: $payload');
    } catch (e) {
      _logger.e('알림 표시 오류: $e');
    }
  }

  /// 포어그라운드 메시지를 스낵바로 표시합니다.
  Future<void> _showForegroundMessage(RemoteMessage message) async {
    try {
      final data = message.data;
      final type = data['type'];
      final articleId = data['article_id'];
      final title = message.notification?.title ?? '새 알림';
      final body = message.notification?.body ?? '';

      _logger.i('🎯 포그라운드 메시지 파싱 - type: $type, article_id: $articleId');

      // 메시지 타입에 따른 액션 텍스트 결정
      String actionText = '확인';
      String? targetRoute;

      if (type == 'comment' || type == 'sub_comment') {
        actionText = '댓글 보기';
        if (articleId != null && articleId.isNotEmpty) {
          targetRoute = '/detail/$articleId';
        }
      } else if (type == 'like') {
        actionText = '게시글 보기';
        if (articleId != null && articleId.isNotEmpty) {
          targetRoute = '/detail/$articleId';
        }
      } else if (type == 'horse_race') {
        actionText = '경마 보기';
        targetRoute = '/horse-race-history';
      } else if (type == 'system') {
        actionText = '알림 보기';
        targetRoute = '/notifications';
      }

      // 토스 스타일 스낵바
      Get.snackbar(
        '',
        '',
        titleText: Container(),
        messageText: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              // 아이콘
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF0066FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              // 텍스트 영역
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191F28),
                        height: 1.3,
                      ),
                    ),
                    if (body.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        body,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B7684),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // 액션 버튼
              if (targetRoute != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Get.back(); // 스낵바 닫기
                    Get.toNamed(targetRoute!);
                    _logger.i('🚀 포그라운드 스낵바 클릭 - 이동: $targetRoute');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0066FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      actionText,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.white,
        margin: const EdgeInsets.fromLTRB(16, 50, 16, 0),
        borderRadius: 12,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutCubic,
        reverseAnimationCurve: Curves.easeInCubic,
        animationDuration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
      );

      _logger.i('🔔 포그라운드 스낵바 표시 완료 - $title');
    } catch (e) {
      _logger.e('포그라운드 메시지 표시 오류: $e');
    }
  }

  /// 백그라운드 알림 클릭 이벤트를 처리합니다.
  @pragma('vm:entry-point')
  static void _onBackgroundNotificationTapped(NotificationResponse response) {
    final logger = Logger();
    logger.i('🔔🔔🔔 백그라운드 알림 클릭 이벤트 수신! 🔔🔔🔔');
    logger.i('🔔 백그라운드 알림 ID: ${response.id}');
    logger.i('🔔 백그라운드 알림 페이로드: ${response.payload}');

    // 백그라운드에서는 간단히 로그만 출력하고 메인 앱에서 처리하도록 함
    if (response.payload != null) {
      logger.i('🔔 백그라운드 페이로드 수신: ${response.payload}');
    }
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

    // 메시지 ID를 기반으로 고유한 알림 ID 생성
    final notificationId =
        message.messageId?.hashCode ??
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await service.showNotification(
      title: message.notification?.title ?? '새 알림',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
      id: notificationId,
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

      // 권한이 거부된 경우 로그 출력
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        _logger.w('FCM 알림 권한이 거부되었습니다.');
        return;
      }

      // 앱이 종료된 상태에서 알림을 클릭하여 앱이 시작된 경우 처리
      await _handleInitialMessage();

      // 포그라운드 메시지 핸들러
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        _logger.i('포그라운드 메시지 수신: ${message.messageId}');
        _logger.i('포그라운드 메시지 데이터: ${message.data}');

        // 포어그라운드에서는 스낵바로 메시지 표시
        await _showForegroundMessage(message);
      });

      // 알림 클릭 핸들러 (FCM 직접 클릭)
      FirebaseMessaging.onMessageOpenedApp.listen((
        RemoteMessage message,
      ) async {
        _logger.i('FCM 알림 클릭: ${message.messageId}');
        _logger.i('FCM 데이터: ${message.data}');

        final data = message.data;
        final type = data['type'];
        final articleId = data['article_id'];

        _logger.i('FCM 파싱된 데이터 - type: $type, article_id: $articleId');

        if (type == 'comment' || type == 'like' || type == 'sub_comment') {
          if (articleId != null && articleId.isNotEmpty) {
            _logger.i('🚀 FCM - 게시글 상세 페이지로 지연된 네비게이션 설정: /detail/$articleId');
            await _pendingNavigation.setPendingNavigation(
              route: '/detail/$articleId',
              data: {'article_id': articleId, 'type': type},
            );
            await navigateAfterPush('/');
            return;
          }
        } else if (type == 'horse_race') {
          _logger.i('🚀 FCM - 경마 히스토리 페이지로 지연된 네비게이션 설정');
          await _pendingNavigation.setPendingNavigation(
            route: '/horse-race-history',
            data: {'type': type},
          );
          await navigateAfterPush('/');
          return;
        } else if (type == 'system') {
          _logger.i('🚀 FCM - 알림 페이지로 지연된 네비게이션 설정');
          await _pendingNavigation.setPendingNavigation(
            route: '/notifications',
            data: {'type': type},
          );
          await navigateAfterPush('/');
          return;
        }
        await navigateAfterPush('/');
      });
    } catch (e) {
      _logger.e('FCM 초기화 오류: $e');
    }
  }

  /// 앱이 종료된 상태에서 알림을 클릭하여 앱이 시작된 경우 처리
  Future<void> _handleInitialMessage() async {
    try {
      final initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        _logger.i('초기 메시지 수신: ${initialMessage.messageId}');
        _logger.i('초기 메시지 데이터: ${initialMessage.data}');

        final data = initialMessage.data;
        final type = data['type'];
        final articleId = data['article_id'];

        _logger.i('초기 메시지 파싱된 데이터 - type: $type, article_id: $articleId');

        // 초기 메시지에서는 지연된 네비게이션만 설정하고 실제 네비게이션은 하지 않음
        if (type == 'comment' || type == 'like' || type == 'sub_comment') {
          if (articleId != null && articleId.isNotEmpty) {
            _logger.i(
              '🚀 초기 메시지 - 게시글 상세 페이지로 지연된 네비게이션 설정: /detail/$articleId',
            );
            await _pendingNavigation.setPendingNavigation(
              route: '/detail/$articleId',
              data: {'article_id': articleId, 'type': type},
            );
            return;
          }
        } else if (type == 'horse_race') {
          _logger.i('🚀 초기 메시지 - 경마 히스토리 페이지로 지연된 네비게이션 설정');
          await _pendingNavigation.setPendingNavigation(
            route: '/horse-race-history',
            data: {'type': type},
          );
          return;
        } else if (type == 'system') {
          _logger.i('🚀 초기 메시지 - 알림 페이지로 지연된 네비게이션 설정');
          await _pendingNavigation.setPendingNavigation(
            route: '/notifications',
            data: {'type': type},
          );
          return;
        }

        _logger.i('🚀 초기 메시지 - 알 수 없는 타입이므로 지연된 네비게이션 설정 안함');
      }
    } catch (e) {
      _logger.e('초기 메시지 처리 오류: $e');
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
