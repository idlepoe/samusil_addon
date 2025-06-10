import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_panel_controller.dart';

class ChatPanelView extends GetView<ChatPanelController> {
  const ChatPanelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('💬 공유 공간', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: controller.messages.length,
                  itemBuilder: (_, index) {
                    final msg = controller.messages[index];
                    return ListTile(
                      title: Text('[${msg.sender}] ${msg.content}'),
                      subtitle: Text(msg.type),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
