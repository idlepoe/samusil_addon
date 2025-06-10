import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:samusil_addon/app/modules/chat_panel/views/chat_panel_view.dart';
import 'package:samusil_addon/app/modules/upload_panel/views/upload_panel_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > constraints.maxHeight;

        return Scaffold(
          // appBar: AppBar(title: const Text('사무실 애드온')),
          body: isWide
              ? Row(
                  children: const [
                    Expanded(child: UploadPanelView()),
                    VerticalDivider(width: 1),
                    Expanded(child: ChatPanelView()),
                  ],
                )
              : Column(
                  children: const [
                    Expanded(child: UploadPanelView()),
                    Divider(height: 1),
                    Expanded(child: ChatPanelView()),
                  ],
                ),
        );
      },
    );
  }
}
