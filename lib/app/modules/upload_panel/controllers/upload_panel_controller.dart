import 'package:get/get.dart';

import '../../../data/models/upload_item.dart';


class UploadPanelController extends GetxController {
  final uploads = <UploadItem>[].obs;

  void addUpload(UploadItem item) {
    uploads.add(item);
  }

  void removeUpload(UploadItem item) {
    uploads.remove(item);
  }

  void shareToChatRoom(String roomId, UploadItem item) {
    // TODO: ChatPanelController 호출 또는 채팅 메시지 생성
  }

  void showInstantShareDialog(UploadItem item) {
    // TODO: 링크/QR 다이얼로그 표시
  }
}
