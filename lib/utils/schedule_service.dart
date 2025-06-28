import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import '../models/schedule.dart';

class ScheduleService {
  static const String _scheduleKey = 'schedules';
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Initialize notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notifications.initialize(initializationSettings);

    // Request notification permission
    await _requestNotificationPermission();
  }

  // 알림 권한 요청
  static Future<void> _requestNotificationPermission() async {
    await Permission.notification.request();
  }

  // 모든 일정 가져오기
  static Future<List<Schedule>> getAllSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final schedulesJson = prefs.getStringList(_scheduleKey) ?? [];

    return schedulesJson
        .map((json) => Schedule.fromJson(jsonDecode(json)))
        .toList();
  }

  // 특정 날짜의 일정 가져오기
  static Future<List<Schedule>> getSchedulesByDate(DateTime date) async {
    final allSchedules = await getAllSchedules();
    return allSchedules
        .where(
          (schedule) =>
              schedule.date.year == date.year &&
              schedule.date.month == date.month &&
              schedule.date.day == date.day,
        )
        .toList();
  }

  // 일정 저장
  static Future<void> saveSchedule(Schedule schedule) async {
    final prefs = await SharedPreferences.getInstance();
    final allSchedules = await getAllSchedules();

    // ID가 비어있으면 새로운 ID 생성
    if (schedule.id.isEmpty) {
      schedule = schedule.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
    }

    // 기존 일정 업데이트 또는 새 일정 추가
    final existingIndex = allSchedules.indexWhere((s) => s.id == schedule.id);
    if (existingIndex != -1) {
      allSchedules[existingIndex] = schedule;
    } else {
      allSchedules.add(schedule);
    }

    // SharedPreferences에 저장
    final schedulesJson =
        allSchedules.map((schedule) => jsonEncode(schedule.toJson())).toList();
    await prefs.setStringList(_scheduleKey, schedulesJson);

    // 알림 설정
    if (schedule.hasNotification) {
      await _scheduleNotification(schedule);
    }
  }

  // 일정 삭제
  static Future<void> deleteSchedule(String scheduleId) async {
    final prefs = await SharedPreferences.getInstance();
    final allSchedules = await getAllSchedules();

    allSchedules.removeWhere((schedule) => schedule.id == scheduleId);

    final schedulesJson =
        allSchedules.map((schedule) => jsonEncode(schedule.toJson())).toList();
    await prefs.setStringList(_scheduleKey, schedulesJson);

    // 알림 취소 (같은 방식으로 ID 계산)
    final notificationId = scheduleId.hashCode & 0x7FFFFFFF;
    await _notifications.cancel(notificationId);
  }

  // 일정 완료 상태 토글
  static Future<void> toggleScheduleCompletion(String scheduleId) async {
    final allSchedules = await getAllSchedules();
    final scheduleIndex = allSchedules.indexWhere((s) => s.id == scheduleId);

    if (scheduleIndex != -1) {
      final schedule = allSchedules[scheduleIndex];
      final updatedSchedule = schedule.copyWith(
        isCompleted: !schedule.isCompleted,
      );
      allSchedules[scheduleIndex] = updatedSchedule;

      final prefs = await SharedPreferences.getInstance();
      final schedulesJson =
          allSchedules
              .map((schedule) => jsonEncode(schedule.toJson()))
              .toList();
      await prefs.setStringList(_scheduleKey, schedulesJson);
    }
  }

  // 알림 예약
  static Future<void> _scheduleNotification(Schedule schedule) async {
    final scheduledDateTime = _getScheduledDateTime(schedule);

    // 과거 시간이면 알림을 설정하지 않음
    if (scheduledDateTime.isBefore(DateTime.now())) {
      return;
    }

    // ID를 32비트 정수 범위 내로 제한 (해시코드 사용)
    final notificationId = schedule.id.hashCode & 0x7FFFFFFF;

    try {
      await _notifications.zonedSchedule(
        notificationId,
        schedule.title,
        schedule.description.isNotEmpty
            ? schedule.description
            : '${schedule.time}에 예정된 일정입니다.',
        tz.TZDateTime.from(scheduledDateTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'schedule_channel',
            '일정 알림',
            channelDescription: '등록된 일정에 대한 알림입니다.',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      // exact alarm 권한이 없는 경우 일반 알림으로 fallback
      await _notifications.zonedSchedule(
        notificationId,
        schedule.title,
        schedule.description.isNotEmpty
            ? schedule.description
            : '${schedule.time}에 예정된 일정입니다.',
        tz.TZDateTime.from(scheduledDateTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'schedule_channel',
            '일정 알림',
            channelDescription: '등록된 일정에 대한 알림입니다.',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  // 일정 시간을 DateTime으로 변환
  static DateTime _getScheduledDateTime(Schedule schedule) {
    final timeParts = schedule.time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    return DateTime(
      schedule.date.year,
      schedule.date.month,
      schedule.date.day,
      hour,
      minute,
    );
  }
}
