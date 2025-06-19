import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dash_board/dash_board_controller.dart';
import 'dash_board/dash_board_view.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashBoardController());
    return const DashBoardView();
  }
}
