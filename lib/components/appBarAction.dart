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

import '../utils/app.dart';
import '../utils/util.dart';

List<Widget> AppBarAction(BuildContext context, Profile profile) {
  int noReadLength = 0;
  for (Alarm row in profile.alarms) {
    if (!row.is_read) {
      noReadLength++;
    }
  }
  return [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        badges.Badge(
          badgeContent: Text(
            noReadLength.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          badgeStyle: const badges.BadgeStyle(),
          position: badges.BadgePosition.topEnd(top: 0, end: 0),
          showBadge: noReadLength > 0,
          child: IconButton(
            onPressed: () async {
              Get.toNamed("/alarm");
            },
            icon: const Icon(Icons.notifications_none_outlined),
          ),
        ),
      ],
    ),
    const SizedBox(width: 10),
    PopupMenuButton<PopupItem>(
      icon: CircleAvatar(
        backgroundImage:
            Utils.isValidNilEmptyStr(profile.profile_image_url)
                ? NetworkImage(profile.profile_image_url)
                : null,
        child:
            Utils.isValidNilEmptyStr(profile.profile_image_url)
                ? null
                : const CircleAvatar(
                  backgroundImage: AssetImage('assets/anon_icon.jpg'),
                ),
      ),
      onSelected: (PopupItem item) {},
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<PopupItem>>[
            PopupMenuItem<PopupItem>(
              enabled: false,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        Utils.isValidNilEmptyStr(profile.profile_image_url)
                            ? NetworkImage(profile.profile_image_url)
                            : null,
                    child:
                        Utils.isValidNilEmptyStr(profile.profile_image_url)
                            ? null
                            : const CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/anon_icon.jpg',
                              ),
                            ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.name),
                      Text("${profile.point.round()}P"),
                    ],
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(height: 1),
            PopupMenuItem<PopupItem>(
              onTap: () async {
                // print("profile");
                // await Future.delayed(Duration.zero);
                // await Navigator.of(context).push(SwipeablePageRoute(
                //   builder: (BuildContext context) => ProfilePage(),
                // ));
                Get.toNamed("/profile");
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Arrays.getBoardInfo(Define.BOARD_PROFILE).icon,
                  const SizedBox(width: 10),
                  Text(Arrays.getBoardInfo(Define.BOARD_PROFILE).title.tr),
                ],
              ),
            ),
            PopupMenuItem<PopupItem>(
              onTap: () {
                Get.toNamed("/point/rank");
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LineIcons.barChart),
                  const SizedBox(width: 10),
                  Text("point_rank".tr),
                ],
              ),
            ),
            PopupMenuItem<PopupItem>(
              onTap: () async {
                FirebaseAuth.instance.signOut();
                await Utils.sharedPrefClear();
                profile = await App.checkUser();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LineIcons.alternateSignOut),
                  const SizedBox(width: 10),
                  Text("logout".tr),
                ],
              ),
            ),
            const PopupMenuDivider(height: 1),
            PopupMenuItem<PopupItem>(
              onTap: () async {
                // await Future.delayed(Duration.zero);
                // await Navigator.of(context).push(SwipeablePageRoute(
                //   builder: (BuildContext context) => OptionPage(),
                // ));
                Get.toNamed("/option");
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LineIcons.cog),
                  const SizedBox(width: 10),
                  Text("option".tr),
                ],
              ),
            ),
          ],
    ),
    const SizedBox(width: 10),
  ];
}
