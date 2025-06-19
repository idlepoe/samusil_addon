import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:samusil_addon/pages/00_dash_board_page.dart';
import 'package:samusil_addon/pages/alarm/01_alarm_list_page.dart';
import 'package:samusil_addon/pages/article/01_article_list_page.dart';
import 'package:samusil_addon/pages/article/02_article_edit_page.dart';
import 'package:samusil_addon/pages/article/03_article_detail_page.dart';
import 'package:samusil_addon/pages/article/04_article_search_page.dart';
import 'package:samusil_addon/pages/option/01_option_page.dart';
import 'package:samusil_addon/pages/option/02_privacy_policy_page.dart';
import 'package:samusil_addon/pages/point/01_point_rank_page.dart';
import 'package:samusil_addon/pages/point/03_point_exchange_tab_page.dart';
import 'package:samusil_addon/pages/profile_page/01_profile_page.dart';

import '../define/arrays.dart';

class AppRouter {
  static GoRouter get router => GoRouter(
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
            path: 'list/:boardName',
            builder: (BuildContext context, GoRouterState state) {
              final boardName = state.pathParameters['boardName'];
              return ArticleListPage(Arrays.getBoardInfo(boardName!));
            },
          ),
          GoRoute(
            path: 'list/:boardName/search',
            builder: (BuildContext context, GoRouterState state) {
              final boardName = state.pathParameters['boardName'];
              return ArticleSearchPage(
                boardInfo: Arrays.getBoardInfo(boardName!),
              );
            },
          ),
          GoRoute(
            path: 'list/:boardName/edit',
            builder: (BuildContext context, GoRouterState state) {
              final boardName = state.pathParameters['boardName'];
              return ArticleEditPage(
                boardInfo: Arrays.getBoardInfo(boardName!),
              );
            },
          ),
          GoRoute(
            path: 'detail/:key',
            builder: (BuildContext context, GoRouterState state) {
              final key = state.pathParameters['key'];
              return ArticleDetailPage(articleKey: key!);
            },
          ),
        ],
      ),
    ],
  );
}
