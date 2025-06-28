// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Schedule _$ScheduleFromJson(Map<String, dynamic> json) => _Schedule(
  id: json['id'] as String,
  date: DateTime.parse(json['date'] as String),
  time: json['time'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  hasNotification: json['hasNotification'] as bool,
  isCompleted: json['isCompleted'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ScheduleToJson(_Schedule instance) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date.toIso8601String(),
  'time': instance.time,
  'title': instance.title,
  'description': instance.description,
  'hasNotification': instance.hasNotification,
  'isCompleted': instance.isCompleted,
  'createdAt': instance.createdAt.toIso8601String(),
};
