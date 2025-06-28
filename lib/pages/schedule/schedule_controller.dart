import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/schedule.dart';
import '../../utils/schedule_service.dart';
import '../../components/appSnackbar.dart';
import '../../components/showSimpleDialog.dart';

class ScheduleController extends GetxController {
  // 현재 포커스된 날짜
  final focusedDay = DateTime.now().obs;

  // 선택된 날짜
  final selectedDay = DateTime.now().obs;

  // 달력 형식
  final calendarFormat = CalendarFormat.month.obs;

  // 페이지 컨트롤러 (월 변경용)
  final pageController = PageController();

  // 현재 표시 중인 월
  final currentMonth = DateTime.now().obs;

  // 선택된 날짜의 일정 목록
  final selectedDaySchedules = <Schedule>[].obs;

  // 모든 일정 (달력에 표시용)
  final allSchedules = <Schedule>[].obs;

  // 로딩 상태
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSchedules();
    loadSelectedDaySchedules();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // 모든 일정 로드
  Future<void> loadSchedules() async {
    isLoading.value = true;
    try {
      final schedules = await ScheduleService.getAllSchedules();
      allSchedules.value = schedules;
    } catch (e) {
      AppSnackbar.error('일정을 불러오는데 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  // 선택된 날짜의 일정 로드
  Future<void> loadSelectedDaySchedules() async {
    try {
      final schedules = await ScheduleService.getSchedulesByDate(
        selectedDay.value,
      );
      // 시간순으로 정렬
      schedules.sort((a, b) => a.time.compareTo(b.time));
      selectedDaySchedules.value = schedules;
    } catch (e) {
      AppSnackbar.error('일정을 불러오는데 실패했습니다.');
    }
  }

  // 날짜 선택
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay.value = selectedDay;
    this.focusedDay.value = focusedDay;
    loadSelectedDaySchedules();
  }

  // 달력 형식 변경
  void onFormatChanged(CalendarFormat format) {
    calendarFormat.value = format;
  }

  // 월 변경 (이전)
  void previousMonth() {
    final newMonth = DateTime(
      currentMonth.value.year,
      currentMonth.value.month - 1,
    );
    currentMonth.value = newMonth;
    focusedDay.value = newMonth;
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // 월 변경 (다음)
  void nextMonth() {
    final newMonth = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
    );
    currentMonth.value = newMonth;
    focusedDay.value = newMonth;
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // 페이지 변경 시 호출
  void onPageChanged(DateTime focusedDay) {
    this.focusedDay.value = focusedDay;
    currentMonth.value = focusedDay;
  }

  // 특정 날짜에 일정이 있는지 확인
  List<Schedule> getEventsForDay(DateTime day) {
    return allSchedules.where((schedule) {
      return isSameDay(schedule.date, day);
    }).toList();
  }

  // 일정 완료 토글
  Future<void> toggleScheduleCompletion(String scheduleId) async {
    try {
      await ScheduleService.toggleScheduleCompletion(scheduleId);
      await loadSchedules();
      await loadSelectedDaySchedules();
    } catch (e) {
      AppSnackbar.error('일정 상태 변경에 실패했습니다.');
    }
  }

  // 일정 삭제
  Future<void> deleteSchedule(String scheduleId) async {
    try {
      await ScheduleService.deleteSchedule(scheduleId);
      await loadSchedules();
      await loadSelectedDaySchedules();
      AppSnackbar.success('일정이 삭제되었습니다.');
    } catch (e) {
      AppSnackbar.error('일정 삭제에 실패했습니다.');
    }
  }

  // 일정 추가 완료 후 새로고침
  Future<void> onScheduleAdded() async {
    await loadSchedules();
    await loadSelectedDaySchedules();
  }

  // 월 이름 포맷
  String get currentMonthName {
    return DateFormat('yyyy년 M월').format(currentMonth.value);
  }

  // 선택된 날짜 포맷
  String get selectedDayFormatted {
    return DateFormat('M월 d일 (E)', 'ko').format(selectedDay.value);
  }
}
