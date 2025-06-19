import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:samusil_addon/pages/00_dash_board_page.dart';
import 'package:samusil_addon/pages/alarm/01_alarm_list_page.dart';
import 'package:samusil_addon/pages/article/01_article_list_page.dart';
import 'package:samusil_addon/pages/article/02_article_edit_page.dart';
import 'package:samusil_addon/pages/article/03_article_detail_key_page.dart';
import 'package:samusil_addon/pages/article/04_article_search_page.dart';
import 'package:samusil_addon/pages/option/01_option_page.dart';
import 'package:samusil_addon/pages/option/02_privacy_policy_page.dart';
import 'package:samusil_addon/pages/point/01_point_rank_page.dart';
import 'package:samusil_addon/pages/point/03_point_exchange_tab_page.dart';
import 'package:samusil_addon/pages/profile_page/01_profile_page.dart';
import 'package:samusil_addon/utils/http_service.dart';
import 'package:samusil_addon/utils/app.dart';

import 'define/arrays.dart';
import 'firebase_options.dart';
import 'locale/messages.dart';

// 전역 logger 인스턴스
final logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // HttpService 초기화 (baseUrl은 나중에 설정)
  HttpService().initialize();

  // Cloud Functions baseUrl 설정 (asia-northeast3 리전)
  App.setCloudFunctionsBaseUrl(
    'https://asia-northeast3-samusil-addon.cloudfunctions.net',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "app_name".tr,
      locale: Get.deviceLocale,
      translations: Messages(),
      home: const DashBoardPage(),
      builder:
          (context, child) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: GoRouter(
              routes: <RouteBase>[
                GoRoute(
                  path: '/',
                  builder: (BuildContext context, GoRouterState state) {
                    return const DashBoardPage();
                  },
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'alarm',
                      builder: (BuildContext context, GoRouterState state) {
                        return const AlarmListPage();
                      },
                    ),
                    GoRoute(
                      path: 'profile',
                      builder: (BuildContext context, GoRouterState state) {
                        return const ProfilePage();
                      },
                    ),
                    GoRoute(
                      path: 'point_rank',
                      builder: (BuildContext context, GoRouterState state) {
                        return const PointRankPage();
                      },
                    ),
                    GoRoute(
                      path: 'point_exchange',
                      builder: (BuildContext context, GoRouterState state) {
                        return const PointExchangeTabPage();
                      },
                    ),
                    GoRoute(
                      path: 'option',
                      builder: (BuildContext context, GoRouterState state) {
                        return const OptionPage();
                      },
                    ),
                    GoRoute(
                      path: 'privacy_policy',
                      builder: (BuildContext context, GoRouterState state) {
                        return const PrivacyPolicy();
                      },
                    ),
                    GoRoute(
                      path: 'list/:index',
                      builder: (BuildContext context, GoRouterState state) {
                        final index = state.pathParameters['index'];
                        return ArticleListPage(
                          Arrays.getBoardInfo(int.parse(index!)),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'list/:index/search',
                      builder: (BuildContext context, GoRouterState state) {
                        final index = state.pathParameters['index'];
                        return ArticleSearchPage(
                          boardInfo: Arrays.getBoardInfo(int.parse(index!)),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'list/:index/edit',
                      builder: (BuildContext context, GoRouterState state) {
                        final index = state.pathParameters['index'];
                        return ArticleEditPage(
                          boardInfo: Arrays.getBoardInfo(int.parse(index!)),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'detail/:key',
                      builder: (BuildContext context, GoRouterState state) {
                        final key = state.pathParameters['key'];
                        return ArticleDetailKeyPage(articleKey: key!);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
