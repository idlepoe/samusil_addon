import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
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
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   SwipeablePageRoute(
                //       builder: (BuildContext context) => DashBoardPage()),
                //   (route) => false,
                // );
                context.go('/');
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
            // Container(
            //   decoration: const BoxDecoration(
            //       gradient: LinearGradient(
            //           begin: Alignment.topLeft,
            //           end: Alignment.bottomRight,
            //           colors: [
            //         Colors.purpleAccent,
            //         Colors.redAccent,
            //         Colors.deepOrange,
            //         Colors.yellowAccent,
            //         Colors.lightBlueAccent,
            //       ])),
            //   child: ListTile(
            //     leading: Arrays.getBoardInfo(Define.INDEX_WISH_PAGE).icon,
            //     title: Text(
            //         Arrays.getBoardInfo(Define.INDEX_WISH_PAGE).title.tr,
            //         style: TextStyle(color: Colors.white)),
            //     onTap: () async {
            //       Navigator.pop(context);
            //       await Navigator.of(context).push(SwipeablePageRoute(
            //         builder: (BuildContext context) => WishPage(),
            //       ));
            //     },
            //   ),
            // ),
            ListTile(
              title: Text(
                Arrays.getBoardInfoByIndex(
                  Define.INDEX_BOARD_ALL_PAGE,
                ).title.tr,
              ),
              leading:
                  Arrays.getBoardInfoByIndex(Define.INDEX_BOARD_ALL_PAGE).icon,
              onTap: () {
                Navigator.pop(context);
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     SwipeablePageRoute(
                //         builder: (BuildContext context) => ArticleListPage(
                //             Arrays.getBoardInfo(Define.INDEX_BOARD_ALL_PAGE))),
                //     (route) => false);
                GoRouter.of(context).push("/list/${Define.BOARD_ALL}");
                // context.go('/list/' + Define.INDEX_BOARD_ALL_PAGE.toString());
              },
            ),
            Define.APP_DIVIDER,
            ListTile(
              title: Text(
                Arrays.getBoardInfoByIndex(Define.INDEX_BOARD_IT_PAGE).title.tr,
              ),
              leading:
                  Arrays.getBoardInfoByIndex(Define.INDEX_BOARD_IT_PAGE).icon,
              onTap: () {
                Navigator.pop(context);
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   SwipeablePageRoute(
                //       builder: (BuildContext context) => ArticleListPage(
                //           Arrays.getBoardInfo(Define.INDEX_BOARD_IT_PAGE))),
                //   (route) => false,
                // );
                context.go('/list/${Define.BOARD_IT}');
              },
            ),
            ListTile(
              title: Text(
                Arrays.getBoardInfoByIndex(
                  Define.INDEX_BOARD_FREE_PAGE,
                ).title.tr,
              ),
              leading:
                  Arrays.getBoardInfoByIndex(Define.INDEX_BOARD_FREE_PAGE).icon,
              onTap: () async {
                Navigator.pop(context);
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   SwipeablePageRoute(
                //       builder: (BuildContext context) => ArticleListPage(
                //           Arrays.getBoardInfo(Define.INDEX_BOARD_FREE_PAGE))),
                //   (route) => false,
                // );
                // await Future.delayed(Duration.zero);
                context.go('/list/${Define.BOARD_FREE}');
              },
            ),
            Define.APP_DIVIDER,
            ListTile(
              title: Text(
                Arrays.getBoardInfoByIndex(
                  Define.INDEX_BOARD_IT_NEWS_PAGE,
                ).title.tr,
              ),
              leading:
                  Arrays.getBoardInfoByIndex(
                    Define.INDEX_BOARD_IT_NEWS_PAGE,
                  ).icon,
              onTap: () async {
                Navigator.pop(context);
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   SwipeablePageRoute(
                //       builder: (BuildContext context) => ArticleListPage(
                //           Arrays.getBoardInfo(
                //               Define.INDEX_BOARD_IT_NEWS_PAGE))),
                //   (route) => false,
                // );
                await Future.delayed(Duration.zero);
                context.go('/list/${Define.BOARD_IT_NEWS}');
              },
            ),
            ListTile(
              title: Text(
                Arrays.getBoardInfoByIndex(
                  Define.INDEX_BOARD_GAME_NEWS_PAGE,
                ).title.tr,
              ),
              leading:
                  Arrays.getBoardInfoByIndex(
                    Define.INDEX_BOARD_GAME_NEWS_PAGE,
                  ).icon,
              onTap: () {
                // Navigator.pop(context);
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   SwipeablePageRoute(
                //       builder: (BuildContext context) => ArticleListPage(
                //           Arrays.getBoardInfo(
                //               Define.INDEX_BOARD_GAME_NEWS_PAGE))),
                //   (route) => false,
                // );
                context.go('/list/${Define.BOARD_GAME_NEWS}');
              },
            ),
            Define.APP_DIVIDER,
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
