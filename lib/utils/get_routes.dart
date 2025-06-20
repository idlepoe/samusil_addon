import 'package:get/get.dart';

// Views
import '../pages/splash/splash_view.dart';
import '../pages/splash/splash_binding.dart';
import '../pages/dash_board/dash_board_view.dart';
import '../pages/dash_board/dash_board_binding.dart';
import '../pages/article/article_list/article_list_view.dart';
import '../pages/article/article_list/article_list_binding.dart';
import '../pages/article/article_edit/article_edit_view.dart';
import '../pages/article/article_edit/article_edit_binding.dart';
import '../pages/article/article_detail/article_detail_view.dart';
import '../pages/article/article_detail/article_detail_binding.dart';
import '../pages/article/article_search/article_search_view.dart';
import '../pages/article/article_search/article_search_binding.dart';
import '../pages/option/01_option_page.dart';
import '../pages/option/01_option_binding.dart';
import '../pages/option/02_privacy_policy_page.dart';
import '../pages/option/02_privacy_policy_binding.dart';
import '../pages/point/01_point_rank_page.dart';
import '../pages/point/01_point_rank_binding.dart';
import '../pages/point/02_point_information_page.dart';
import '../pages/point/02_point_information_binding.dart';
import '../pages/point/03_point_exchange_tab_page.dart';
import '../pages/point/03_point_exchange_tab_binding.dart';
import '../pages/point/04_coin_buy_page.dart';
import '../pages/point/04_coin_buy_binding.dart';
import '../pages/point/05_coin_sell_page.dart';
import '../pages/point/05_coin_sell_binding.dart';
import '../pages/profile/profile_view.dart';
import '../pages/profile/profile_binding.dart';
import '../pages/wish/wish_view.dart';
import '../pages/wish/wish_binding.dart';

class GetRoutes {
  static final List<GetPage> routes = [
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
      name: '/edit',
      page: () => const ArticleEditView(),
      binding: ArticleEditBinding(),
    ),
    GetPage(
      name: '/edit/:articleId',
      page: () => const ArticleEditView(),
      binding: ArticleEditBinding(),
    ),
    GetPage(
      name: '/detail/:articleId',
      page: () => const ArticleDetailView(),
      binding: ArticleDetailBinding(),
    ),
    GetPage(
      name: '/search/:boardName',
      page: () => const ArticleSearchView(),
      binding: ArticleSearchBinding(),
    ),
    GetPage(
      name: '/option',
      page: () => const OptionPage(),
      binding: OptionBinding(),
    ),
    GetPage(
      name: '/privacy',
      page: () => const PrivacyPolicy(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: '/profile',
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/point_rank',
      page: () => const PointRankPage(),
      binding: PointRankBinding(),
    ),
    GetPage(
      name: '/point_info',
      page: () => const PointInformationPage(),
      binding: PointInformationBinding(),
    ),
    GetPage(
      name: '/point_exchange',
      page: () => const PointExchangeTabPage(),
      binding: PointExchangeTabBinding(),
    ),
    GetPage(
      name: '/coin_buy',
      page: () => const CoinBuyPage(),
      binding: CoinBuyBinding(),
    ),
    GetPage(
      name: '/coin_sell',
      page: () => const CoinSellPage(),
      binding: CoinSellBinding(),
    ),
    GetPage(
      name: '/wish',
      page: () => const WishView(),
      binding: WishBinding(),
    ),
  ];
}
