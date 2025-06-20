// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wish.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Wish _$WishFromJson(Map<String, dynamic> json) => _Wish(
  index: _toInt(json['index']),
  uid: _toString(json['uid']),
  comments: _toString(json['comments']),
  nick_name: _toString(json['nick_name']),
  streak: _toInt(json['streak']),
  created_at: _toString(json['created_at']),
);

Map<String, dynamic> _$WishToJson(_Wish instance) => <String, dynamic>{
  'index': instance.index,
  'uid': instance.uid,
  'comments': instance.comments,
  'nick_name': instance.nick_name,
  'streak': instance.streak,
  'created_at': instance.created_at,
};
