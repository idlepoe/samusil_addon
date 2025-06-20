import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // 기존 ProfilePage의 UI 코드를 여기에 옮기세요.
    return Scaffold(
      appBar: AppBar(title: const Text('프로필')),
      body: Center(child: Text('프로필 페이지')),
    );
  }
}
