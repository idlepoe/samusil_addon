import 'package:get/get.dart';

// Models
import '../models/board_info.dart';

// Utils
import '../define/arrays.dart';

// Views
import '../pages/splash/splash_view.dart';
import '../pages/splash/splash_binding.dart';
import '../pages/dash_board/dash_board_view.dart';
import '../pages/dash_board/dash_board_binding.dart';
import '../pages/article/article_list/article_list_view.dart';
import '../pages/article/article_list/article_list_binding.dart';
import '../pages/article/article_detail/article_detail_view.dart';
import '../pages/article/article_detail/article_detail_binding.dart';
import '../pages/article/article_search/article_search_view.dart';
import '../pages/article/article_search/article_search_binding.dart';
import '../pages/article/article_edit/article_edit_view.dart';
import '../pages/article/article_edit/article_edit_binding.dart';
import '../pages/option/01_option_page.dart';
import '../pages/option/01_option_binding.dart';
import '../pages/option/02_privacy_policy_page.dart';
import '../pages/option/02_privacy_policy_binding.dart';
import '../pages/wish/wish_view.dart';
import '../pages/wish/wish_binding.dart';
import '../pages/horse_race/horse_race_view.dart';
import '../pages/horse_race/horse_race_binding.dart';
import '../pages/notification/notification_history_view.dart';
import '../pages/notification/notification_history_binding.dart';
import '../pages/point/point_history_view.dart';
import '../pages/point/point_history_binding.dart';

class GetRoutes {
  static final routes = [
    GetPage(
      name: '/splash',
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: '/',
      page: () => const DashBoardView(),
      binding: DashBoardBinding(),
    ),
    GetPage(
      name: '/list/:boardName',
      page: () => const ArticleListView(),
      binding: ArticleListBinding(),
    ),
    GetPage(
      name: '/list/:boardName/search',
      page: () => const ArticleSearchView(),
      binding: ArticleSearchBinding(),
    ),
    GetPage(
      name: '/list/:boardName/edit',
      page: () {
        final boardName = Get.parameters['boardName'] ?? '';
        final boardInfo = Arrays.getBoardInfo(boardName);
        return ArticleEditView(boardInfo);
      },
      binding: ArticleEditBinding(),
    ),
    GetPage(
      name: '/detail/:id',
      page: () => const ArticleDetailView(),
      binding: ArticleDetailBinding(),
    ),
    GetPage(
      name: '/edit/:id',
      page: () {
        final id = Get.parameters['id'] ?? '';
        final boardInfo = BoardInfo.init(); // 임시로 빈 boardInfo 전달
        return ArticleEditView(boardInfo, id: id);
      },
      binding: ArticleEditBinding(),
    ),
    GetPage(
      name: '/option',
      page: () => const OptionPage(),
      binding: OptionBinding(),
    ),
    GetPage(
      name: '/privacy-policy',
      page: () => const PrivacyPolicy(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: '/wish',
      page: () => const WishView(),
      binding: WishBinding(),
    ),
    GetPage(
      name: '/horse-race',
      page: () => const HorseRaceView(),
      binding: HorseRaceBinding(),
    ),
    GetPage(
      name: '/notifications',
      page: () => const NotificationHistoryView(),
      binding: NotificationHistoryBinding(),
    ),
    GetPage(
      name: '/point-history',
      page: () => const PointHistoryView(),
      binding: PointHistoryBinding(),
    ),
  ];
}
