// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Alarm _$AlarmFromJson(Map<String, dynamic> json) => _Alarm(
  key: json['key'] as String,
  my_contents: json['my_contents'] as String,
  is_read: json['is_read'] as bool,
  target_article_key: json['target_article_key'] as String,
  target_contents: json['target_contents'] as String,
  target_info: json['target_info'] as String,
  target_key_type: (json['target_key_type'] as num).toInt(),
);

Map<String, dynamic> _$AlarmToJson(_Alarm instance) => <String, dynamic>{
  'key': instance.key,
  'my_contents': instance.my_contents,
  'is_read': instance.is_read,
  'target_article_key': instance.target_article_key,
  'target_contents': instance.target_contents,
  'target_info': instance.target_info,
  'target_key_type': instance.target_key_type,
};
