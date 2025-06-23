import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
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
              leading: const Icon(Icons.home, color: Color(0xFF0064FF)),
              title: Row(
                children: [
                  const Image(
                    height: 30,
                    width: 30,
                    image: AssetImage("assets/icon.png"),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "오피스 라운지",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Define.APP_DIVIDER,

            // 잡담 게시판
            ListTile(
              title: Text("잡담 게시판"),
              subtitle: Text("자유롭게 이야기를 나누는 공간입니다"),
              leading: const Icon(LineIcons.freebsd, color: Color(0xFF4DABF7)),
              onTap: () async {
                Navigator.pop(context);
                Get.toNamed('/list/${Define.BOARD_FREE}');
              },
            ),

            // 게임 뉴스
            ListTile(
              title: Text("게임뉴스"),
              subtitle: Text("최신 게임 뉴스와 업데이트 소식"),
              leading: const Icon(LineIcons.gamepad, color: Color(0xFF51CF66)),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/list/${Define.BOARD_GAME_NEWS}');
              },
            ),

            // 연예 뉴스
            ListTile(
              title: Text("연예뉴스"),
              subtitle: Text("최신 연예계 소식과 셀럽 업데이트"),
              leading: const Icon(LineIcons.heart, color: Color(0xFFFF1493)),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/list/${Define.BOARD_ENTERTAINMENT_NEWS}');
              },
            ),

            // 뮤직살롱
            ListTile(
              title: Text("뮤직살롱"),
              subtitle: Text("오피스 플레이리스트를 공유하고 발견하세요"),
              leading: const Icon(LineIcons.music, color: Colors.purple),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/office-music-list');
              },
            ),

            // 즐겨찾기
            ListTile(
              title: const Text("즐겨찾기"),
              subtitle: const Text("즐겨찾기한 플레이리스트를 확인하세요"),
              leading: const Icon(Icons.bookmark, color: Color(0xFF3182F6)),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/favorite-playlist');
              },
            ),

            Define.APP_DIVIDER,

            // 코인경마
            ListTile(
              title: const Text("코인경마"),
              subtitle: Text("코인에 베팅하고 포인트를 획득하세요"),
              leading: const Icon(Icons.sports_soccer, color: Colors.orange),
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
