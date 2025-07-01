import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import 'schedule_controller.dart';
import 'widgets/add_schedule_bottom_sheet.dart';
import '../../components/showSimpleDialog.dart';

class ScheduleView extends GetView<ScheduleController> {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF191F28)),
        title: Obx(
          () => Text(
            "일정관리",
            style: const TextStyle(
              color: Color(0xFF191F28),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: controller.previousMonth,
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(
            onPressed: controller.nextMonth,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            // 달력
            Container(
              color: Colors.white,
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: controller.focusedDay.value,
                selectedDayPredicate: (day) {
                  return isSameDay(controller.selectedDay.value, day);
                },
                calendarFormat: controller.calendarFormat.value,
                eventLoader: controller.getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                onDaySelected: controller.onDaySelected,
                onFormatChanged: controller.onFormatChanged,
                onPageChanged: controller.onPageChanged,
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFF0064FF),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Color(0xFF0064FF),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Color(0xFFFF6B35),
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.red),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: Color(0xFF191F28),
                    fontWeight: FontWeight.w500,
                  ),
                  weekendStyle: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                locale: 'ko_KR',
              ),
            ),

            // 선택된 날짜 헤더
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Obx(
                () => Text(
                  controller.selectedDayFormatted,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191F28),
                  ),
                ),
              ),
            ),

            // 일정 목록
            Expanded(
              child: Obx(
                () =>
                    controller.selectedDaySchedules.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.selectedDaySchedules.length,
                          itemBuilder: (context, index) {
                            final schedule =
                                controller.selectedDaySchedules[index];
                            return _buildScheduleItem(schedule);
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddScheduleBottomSheet,
        backgroundColor: const Color(0xFF0064FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.event_note,
              size: 40,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '등록된 일정이 없습니다',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '하단의 + 버튼을 눌러 일정을 추가해보세요',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(schedule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: GestureDetector(
          onTap: () => controller.toggleScheduleCompletion(schedule.id),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    schedule.isCompleted
                        ? const Color(0xFF00C851)
                        : Colors.grey.shade400,
                width: 2,
              ),
              color:
                  schedule.isCompleted
                      ? const Color(0xFF00C851)
                      : Colors.transparent,
            ),
            child:
                schedule.isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
          ),
        ),
        title: Text(
          schedule.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color:
                schedule.isCompleted
                    ? Colors.grey.shade500
                    : const Color(0xFF191F28),
            decoration:
                schedule.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (schedule.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                schedule.description,
                style: TextStyle(
                  fontSize: 14,
                  color:
                      schedule.isCompleted
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  schedule.time,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (schedule.hasNotification) ...[
                  const SizedBox(width: 12),
                  Icon(
                    Icons.notifications_active,
                    size: 16,
                    color: Colors.orange.shade400,
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          position: PopupMenuPosition.under,
          elevation: 4,
          color: Colors.white,
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  value: 'delete',
                  height: 48,
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        color: const Color(0xFFFF3B30),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '삭제',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFF3B30),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
          onSelected: (value) {
            if (value == 'delete') {
              _showDeleteConfirmDialog(schedule.id);
            }
          },
        ),
      ),
    );
  }

  void _showAddScheduleBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => AddScheduleBottomSheet(
            selectedDate: controller.selectedDay.value,
            onScheduleAdded: controller.onScheduleAdded,
          ),
    );
  }

  void _showDeleteConfirmDialog(String scheduleId) {
    showSimpleDialog(
      title: '일정 삭제',
      message: '이 일정을 삭제하시겠습니까?\n삭제된 일정은 복구할 수 없습니다.',
      confirmText: '삭제',
      confirmButtonStyle: SimpleDialogButtonStyle.destructive,
      onConfirm: () {
        controller.deleteSchedule(scheduleId);
      },
    );
  }
}
