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
            // 홈
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

            // 오늘의 소원
            ListTile(
              title: Text("오늘의 소원"),
              subtitle: Text("소원을 빌어 포인트를 획득하세요"),
              leading: const Icon(Icons.star, color: Color(0xFFFFD700)),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/wish');
              },
            ),

            // 일정관리
            ListTile(
              title: Text("일정관리"),
              subtitle: Text("일정을 관리하고 알림을 받으세요"),
              leading: const Icon(
                Icons.calendar_today,
                color: Color(0xFF9C27B0),
              ),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/schedule');
              },
            ),
            Define.APP_DIVIDER,

            // 게임 섹션
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Text(
                "게임",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
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
            // 출근길 낚시왕
            ListTile(
              title: const Text("출근길 낚시왕"),
              subtitle: Text("물고기를 잡고 포인트를 획득하세요"),
              leading: const Icon(Icons.phishing, color: Colors.blue),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/fishing-game');
              },
            ),
            // 섯다
            ListTile(
              title: const Text("섯다"),
              subtitle: Text("AI와 함께하는 전통 카드 게임"),
              leading: const Icon(Icons.casino, color: Colors.red),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/sutda');
              },
            ),
            Define.APP_DIVIDER,

            // 뉴스 섹션
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Text(
                "뉴스",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
            Define.APP_DIVIDER,

            // 게시판 섹션
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Text(
                "게시판",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
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
            Define.APP_DIVIDER,

            // 뮤직 섹션
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Text(
                "뮤직",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
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

            // 포인트 상점 섹션
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Text(
                "포인트 상점",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // 서울시립미술관 아트워크
            ListTile(
              title: const Text("서울시립미술관 아트워크"),
              subtitle: const Text("포인트를 사용해서 작품을 구입하세요"),
              leading: const Icon(Icons.museum, color: Color(0xFF8B4513)),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/artwork');
              },
            ),
          ],
        ),
      ),
    );
  }
}
