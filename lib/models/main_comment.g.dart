// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MainComment _$MainCommentFromJson(Map<String, dynamic> json) => _MainComment(
  key: _toString(json['key']),
  contents: _toString(json['contents']),
  profile_key: _toString(json['profile_key']),
  profile_name: _toString(json['profile_name']),
  created_at: _toString(json['created_at']),
  is_sub: _toBool(json['is_sub']),
  parents_key: _toString(json['parents_key']),
);

Map<String, dynamic> _$MainCommentToJson(_MainComment instance) =>
    <String, dynamic>{
      'key': instance.key,
      'contents': instance.contents,
      'profile_key': instance.profile_key,
      'profile_name': instance.profile_name,
      'created_at': instance.created_at,
      'is_sub': instance.is_sub,
      'parents_key': instance.parents_key,
    };
