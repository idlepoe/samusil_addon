// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  uid: _toString(json['uid']),
  name: _toString(json['name']),
  photo_url: _toString(json['photo_url']),
  wish_last_date: _toString(json['wish_last_date']),
  wish_streak: _toInt(json['wish_streak']),
  point: (json['point'] as num).toDouble(),
  one_comment: _toString(json['one_comment']),
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'uid': instance.uid,
  'name': instance.name,
  'photo_url': instance.photo_url,
  'wish_last_date': instance.wish_last_date,
  'wish_streak': instance.wish_streak,
  'point': instance.point,
  'one_comment': instance.one_comment,
};
