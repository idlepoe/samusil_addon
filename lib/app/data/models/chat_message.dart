import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:samusil_addon/app/data/models/upload_item.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String sender,
    required String type, // 'text', 'file', 'image'
    required DateTime timestamp,
    String? content, // 일반 텍스트 메시지용
    UploadItem? uploadItem, // 파일/이미지 메시지용
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
