import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_panel_controller.dart';

class ChatPanelView extends GetView<ChatPanelController> {
  const ChatPanelView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatPanelView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ChatPanelView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
