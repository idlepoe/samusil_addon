import 'package:get/get.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'dart:io';
import '../../../data/models/upload_item.dart';

class UploadPanelController extends GetxController {
  final uploads = <UploadItem>[].obs;

  void addUpload(UploadItem item) {
    uploads.add(item);
  }

  void removeUpload(UploadItem item) {
    uploads.remove(item);
  }

  Future<void> handlePaste() async {
    try {
      final clipboard = SystemClipboard.instance;
      if (clipboard == null) return;

      final reader = await clipboard.read();
      if (reader.canProvide(Formats.fileUri)) {
        final fileUri = await reader.readValue(Formats.fileUri);
        if (fileUri != null) {
          final filePath = fileUri.toFilePath();
          if (filePath != null) {
            final fileObj = File(filePath);
            if (await fileObj.exists()) {
              final fileName = filePath.split(Platform.pathSeparator).last;
              final fileType = fileName.split('.').last.toLowerCase();
              
              addUpload(UploadItem(
                name: fileName,
                url: filePath,
                type: fileType,
              ));
            }
          }
        }
      }
    } catch (e) {
      print('Error handling paste: $e');
    }
  }

  void shareToChatRoom(String roomId, UploadItem item) {
    // TODO: ChatPanelController 호출 또는 채팅 메시지 생성
  }

  void showInstantShareDialog(UploadItem item) {
    // TODO: 링크/QR 다이얼로그 표시
  }
}
