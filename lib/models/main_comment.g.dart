// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MainComment _$MainCommentFromJson(Map<String, dynamic> json) => _MainComment(
  id: _toString(json['id']),
  contents: _toString(json['contents']),
  profile_uid: _toString(json['profile_uid']),
  profile_name: _toString(json['profile_name']),
  profile_photo_url: _toString(json['profile_photo_url']),
  created_at: _timestampFromJson(json['created_at']),
  is_sub: _toBool(json['is_sub']),
  parents_key: _toString(json['parents_key']),
  profile_point: _toInt(json['profile_point']),
  count_report: json['count_report'] == null ? 0 : _toInt(json['count_report']),
);

Map<String, dynamic> _$MainCommentToJson(_MainComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contents': instance.contents,
      'profile_uid': instance.profile_uid,
      'profile_name': instance.profile_name,
      'profile_photo_url': instance.profile_photo_url,
      'created_at': _timestampToJson(instance.created_at),
      'is_sub': instance.is_sub,
      'parents_key': instance.parents_key,
      'profile_point': instance.profile_point,
      'count_report': instance.count_report,
    };
