import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:samusil_addon/main.dart';

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

enum PopupItem { profile, point, option, logout }

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
      onSelected: (PopupItem item) {},
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
                  Text("point_information".tr),
                ],
              ),
            ),
            PopupMenuItem<PopupItem>(
              value: PopupItem.option,
              child: Row(
                children: [
                  const Icon(Icons.settings, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text("option".tr),
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
                  Text("logout".tr),
                ],
              ),
            ),
          ],
    ),
    const SizedBox(width: 10),
  ];
}
