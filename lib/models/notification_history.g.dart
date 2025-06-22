// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationHistory _$NotificationHistoryFromJson(Map<String, dynamic> json) =>
    _NotificationHistory(
      id: _toString(json['id']),
      type: _toString(json['type']),
      title: _toString(json['title']),
      body: _toString(json['body']),
      article_id: _toString(json['article_id']),
      article_title: _toString(json['article_title']),
      sender_uid: _toString(json['sender_uid']),
      sender_name: _toString(json['sender_name']),
      created_at: _toDateTime(json['created_at']),
      read: _toBool(json['read']),
    );

Map<String, dynamic> _$NotificationHistoryToJson(
  _NotificationHistory instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'body': instance.body,
  'article_id': instance.article_id,
  'article_title': instance.article_title,
  'sender_uid': instance.sender_uid,
  'sender_name': instance.sender_name,
  'created_at': instance.created_at.toIso8601String(),
  'read': instance.read,
};
