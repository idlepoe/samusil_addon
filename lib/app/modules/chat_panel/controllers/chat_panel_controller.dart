import 'package:get/get.dart';

import '../../../data/models/chat_message.dart';

class ChatPanelController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final currentRoomId = ''.obs;

  /// 채팅방 입장
  void enterRoom(String roomId) {
    currentRoomId.value = roomId;
    loadMessages(roomId);
  }

  /// 채팅 메시지 로드
  void loadMessages(String roomId) {
    // Firestore 또는 로컬에서 메시지 로딩 (추후 구현)
    messages.clear();
  }

  /// 텍스트 메시지 전송
  void sendTextMessage(String content) {
    final msg = ChatMessage(
      sender: 'my_uid', // AuthController.to.uid 등에서 가져올 수 있음
      type: 'text',
      timestamp: DateTime.now(),
      content: content, uploadItem: null,
    );
    messages.add(msg);
  }

  /// 업로드 항목 공유 (파일, 이미지)
  void shareUploadAsMessage(ChatMessage message) {
    messages.add(message);
  }
}
