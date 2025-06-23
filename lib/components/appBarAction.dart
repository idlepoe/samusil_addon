import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:office_lounge/main.dart';

import '../define/arrays.dart';
import '../define/define.dart';
import '../define/enum.dart';
import '../models/alarm.dart';
import '../models/profile.dart';
import 'package:badges/badges.dart' as badges;
import 'profile_avatar_widget.dart';

import '../utils/app.dart';
import '../utils/util.dart';
import '../controllers/profile_controller.dart';

enum PopupItem { profile, point, notifications, option, logout }

List<Widget> AppBarAction(BuildContext context, Profile profile) {
  return [
    PopupMenuButton<PopupItem>(
      icon: Obx(() {
        final profileController = ProfileController.to;
        return ProfileAvatarWidget(
          photoUrl: profileController.profileImageUrl,
          name: profileController.userName,
          size: 32,
        );
      }),
      onSelected: (PopupItem item) {
        switch (item) {
          case PopupItem.point:
            Get.toNamed('/point-history');
            break;
          case PopupItem.notifications:
            Get.toNamed('/notifications');
            break;
          case PopupItem.option:
            Get.toNamed('/option');
            break;
          case PopupItem.logout:
            _showLogoutDialog(context);
            break;
          default:
            break;
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<PopupItem>>[
            PopupMenuItem<PopupItem>(
              enabled: false,
              child: Obx(() {
                final profileController = ProfileController.to;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfileAvatarWidget(
                      photoUrl: profileController.profileImageUrl,
                      name: profileController.userName,
                      size: 40,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profileController.userName),
                        Text("${profileController.currentPointRounded}P"),
                      ],
                    ),
                  ],
                );
              }),
            ),
            const PopupMenuDivider(height: 1),
            PopupMenuItem<PopupItem>(
              value: PopupItem.point,
              child: Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text("포인트 정보"),
                ],
              ),
            ),
            PopupMenuItem<PopupItem>(
              value: PopupItem.notifications,
              child: Row(
                children: [
                  const Icon(Icons.notifications, color: Color(0xFF0064FF)),
                  const SizedBox(width: 8),
                  const Text("알림"),
                ],
              ),
            ),
            PopupMenuItem<PopupItem>(
              value: PopupItem.option,
              child: Row(
                children: [
                  const Icon(Icons.settings, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text("옵션"),
                ],
              ),
            ),
            const PopupMenuDivider(height: 1),
            PopupMenuItem<PopupItem>(
              value: PopupItem.logout,
              child: Row(
                children: [
                  const Icon(Icons.logout, color: Colors.red),
                  const SizedBox(width: 8),
                  Text("로그아웃"),
                ],
              ),
            ),
          ],
    ),
    const SizedBox(width: 10),
  ];
}

void _showLogoutDialog(BuildContext context) {
  Get.dialog(
    AlertDialog(
      title: const Text('로그아웃'),
      content: const Text('정말 로그아웃하시겠습니까?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('취소')),
        TextButton(
          onPressed: () async {
            Get.back();
            await FirebaseAuth.instance.signOut();
            Get.offAllNamed('/splash');
          },
          child: const Text('로그아웃'),
        ),
      ],
    ),
  );
}
