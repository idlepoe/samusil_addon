import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';

@freezed
abstract class Schedule with _$Schedule {
  const factory Schedule({
    required String id,
    required DateTime date,
    required String time,
    required String title,
    required String description,
    required bool hasNotification,
    @Default(false) bool isCompleted,
    required DateTime createdAt,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  factory Schedule.init() => Schedule(
    id: '',
    date: DateTime.now(),
    time: '09:00',
    title: '',
    description: '',
    hasNotification: false,
    isCompleted: false,
    createdAt: DateTime.now(),
  );
}
