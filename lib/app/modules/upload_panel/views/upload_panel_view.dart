import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:clipboard/clipboard.dart';
import '../controllers/upload_panel_controller.dart';

class UploadPanelView extends GetView<UploadPanelController> {
  const UploadPanelView({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    
    return Focus(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          print('Key pressed: ${event.logicalKey}');
          if (event.logicalKey == LogicalKeyboardKey.keyV && 
              HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.controlLeft)) {
            // Handle Ctrl+V paste event
            FlutterClipboard.paste().then((value) {
              print('Pasted value: $value');
            });
          }
        }
        return KeyEventResult.handled;
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue.shade50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('📁 내 서버', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.uploads.length,
                    itemBuilder: (_, index) {
                      final item = controller.uploads[index];
                      return ListTile(
                        leading: const Icon(Icons.insert_drive_file),
                        title: Text("item.name"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () => controller.shareToChatRoom('targetRoomId', item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.qr_code),
                              onPressed: () => controller.showInstantShareDialog(item),
                            ),
                          ],
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
