import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../define/arrays.dart';
import '../../define/define.dart';
import '../../models/profile.dart';
import '../../utils/app.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key});

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  Profile _profile = Profile.init();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    Profile profile = await App.getProfile();
    if (!mounted) return;
    setState(() {
      _profile = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/');
              },
              leading: const Icon(Icons.menu),
              title: Row(
                children: [
                  const Image(
                    height: 30,
                    width: 30,
                    image: AssetImage("assets/icon.png"),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "app_name".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Define.APP_DIVIDER,
            ListTile(
              title: Text(Arrays.getBoardInfo(Define.BOARD_FREE).title.tr),
              leading: Arrays.getBoardInfo(Define.BOARD_FREE).icon,
              onTap: () async {
                Navigator.pop(context);
                Get.toNamed('/list/${Define.BOARD_FREE}');
              },
            ),
            ListTile(
              title: Text(Arrays.getBoardInfo(Define.BOARD_GAME_NEWS).title.tr),
              leading: Arrays.getBoardInfo(Define.BOARD_GAME_NEWS).icon,
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/list/${Define.BOARD_GAME_NEWS}');
              },
            ),
            Define.APP_DIVIDER,
            ListTile(
              title: const Text("코인경마"),
              leading: const Icon(Icons.sports_soccer),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/horse-race');
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 60, right: 60),
              title: Html(
                data:
                    "<a href='https://play.google.com/store/apps/details?id=com.lee.nippon_life.nippon_life&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='다운로드하기 Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/ko_badge_web_generic.png'/></a>",
                onLinkTap: (url, _, __) async {
                  if (!await launchUrlString(url!)) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
