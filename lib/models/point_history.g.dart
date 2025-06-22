// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PointHistory _$PointHistoryFromJson(Map<String, dynamic> json) =>
    _PointHistory(
      id: _toString(json['id']),
      profile_uid: _toString(json['profile_uid']),
      action_type: _toString(json['action_type']),
      points_earned: _toInt(json['points_earned']),
      description: _toString(json['description']),
      related_id: _toString(json['related_id']),
      created_at: _toDateTimeObj(json['created_at']),
    );

Map<String, dynamic> _$PointHistoryToJson(_PointHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profile_uid': instance.profile_uid,
      'action_type': instance.action_type,
      'points_earned': instance.points_earned,
      'description': instance.description,
      'related_id': instance.related_id,
      'created_at': instance.created_at.toIso8601String(),
    };
