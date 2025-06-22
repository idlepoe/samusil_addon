// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PointHistory _$PointHistoryFromJson(Map<String, dynamic> json) =>
    _PointHistory(
      id: json['id'] as String?,
      profile_uid: json['profile_uid'] as String,
      action_type: json['action_type'] as String,
      points_earned: (json['points_earned'] as num).toInt(),
      description: json['description'] as String,
      related_id: json['related_id'] as String?,
      created_at: json['created_at'] as String,
    );

Map<String, dynamic> _$PointHistoryToJson(_PointHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profile_uid': instance.profile_uid,
      'action_type': instance.action_type,
      'points_earned': instance.points_earned,
      'description': instance.description,
      'related_id': instance.related_id,
      'created_at': instance.created_at,
    };
