// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  sender: json['sender'] as String,
  type: json['type'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  content: json['content'] as String?,
  uploadItem:
      json['uploadItem'] == null
          ? null
          : UploadItem.fromJson(json['uploadItem'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'type': instance.type,
      'timestamp': instance.timestamp.toIso8601String(),
      'content': instance.content,
      'uploadItem': instance.uploadItem,
    };
