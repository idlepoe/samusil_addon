import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/upload_panel_controller.dart';

class UploadPanelView extends GetView<UploadPanelController> {
  const UploadPanelView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UploadPanelView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UploadPanelView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
