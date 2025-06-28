import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';
import '../../../models/schedule.dart';
import '../../../utils/schedule_service.dart';
import '../../../components/appSnackbar.dart';

class AddScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final VoidCallback onScheduleAdded;

  const AddScheduleBottomSheet({
    super.key,
    required this.selectedDate,
    required this.onScheduleAdded,
  });

  @override
  State<AddScheduleBottomSheet> createState() => _AddScheduleBottomSheetState();
}

class _AddScheduleBottomSheetState extends State<AddScheduleBottomSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedTime = '09:00';
  bool _hasNotification = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '일정 추가',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 날짜 표시
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0064FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF0064FF),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat(
                    'yyyy년 M월 d일 (E)',
                    'ko',
                  ).format(widget.selectedDate),
                  style: const TextStyle(
                    color: Color(0xFF0064FF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 시간 선택
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.grey),
              const SizedBox(width: 12),
              const Text(
                '시간',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              InkWell(
                onTap: _showTimePicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _selectedTime,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 제목 입력
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: '제목',
              hintText: '일정 제목을 입력하세요',
              prefixIcon: Icon(Icons.title),
              border: OutlineInputBorder(),
            ),
            maxLength: 50,
          ),
          const SizedBox(height: 16),

          // 설명 입력
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: '설명 (선택사항)',
              hintText: '일정에 대한 설명을 입력하세요',
              prefixIcon: Icon(Icons.description),
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            maxLength: 200,
          ),
          const SizedBox(height: 16),

          // 알림 설정
          Row(
            children: [
              const Icon(Icons.notifications, color: Colors.grey),
              const SizedBox(width: 12),
              const Text(
                '알림',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Switch(
                value: _hasNotification,
                onChanged: (value) {
                  setState(() {
                    _hasNotification = value;
                  });
                },
                activeColor: const Color(0xFF0064FF),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 저장 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveSchedule,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0064FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  _isLoading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Text(
                        '일정 추가',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTimePicker() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_selectedTime.split(':')[0]),
        minute: int.parse(_selectedTime.split(':')[1]),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              dayPeriodColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const Color(0xFF0064FF);
                }
                return const Color(0xFFF8F9FA);
              }),
              dayPeriodTextColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return const Color(0xFF191F28);
              }),
              hourMinuteColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const Color(0xFF0064FF);
                }
                return const Color(0xFFF8F9FA);
              }),
              hourMinuteTextColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return const Color(0xFF191F28);
              }),
              dialHandColor: const Color(0xFF0064FF),
              dialBackgroundColor: const Color(0xFFF8F9FA),
              dialTextColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return const Color(0xFF191F28);
              }),
              entryModeIconColor: const Color(0xFF0064FF),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0064FF),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _selectedTime =
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void _saveSchedule() async {
    if (_titleController.text.trim().isEmpty) {
      AppSnackbar.error('제목을 입력해주세요.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final schedule = Schedule(
        id: '',
        date: widget.selectedDate,
        time: _selectedTime,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        hasNotification: _hasNotification,
        createdAt: DateTime.now(),
      );

      await ScheduleService.saveSchedule(schedule);
      widget.onScheduleAdded();
      Get.back();
      AppSnackbar.success('일정이 추가되었습니다.');
    } catch (e) {
      logger.e(e);
      AppSnackbar.error('일정 추가에 실패했습니다.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
