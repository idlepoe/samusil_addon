import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:line_icons/line_icons.dart';
import 'package:samusil_addon/pages/point/03_point_exchange_tab_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';

import '../../define/arrays.dart';
import '../../define/define.dart';
import '../../define/enum.dart';
import '../../models/article.dart';
import '../../models/profile.dart';
import '../../utils/app.dart';
import '../../utils/util.dart';
import '../components/appBarAction.dart';
import '../models/coin.dart';
import '../models/wish.dart';
import '../utils/news.dart';
import 'left_drawer/left_drawer.dart';
import '../../main.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  bool _isCommentLoading = false;

  bool _showInput = false;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _listMaxLength = Define.DEFAULT_BOARD_GET_LENGTH;

  Profile _profile = Profile.init();
  List<Wish> _wishList = [];
  final int _wishCount = 0;
  List<Article> _articleList = [];
  List<Article> _itList = [];
  List<Article> _gameList = [];
  final List<Coin> _coinList = [];

  ViewType viewType = ViewType.normal;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (kIsWeb) {
      logger.i(Uri.base.origin);
    }
    logger.i("AllArticlePage init");
    _profile = await App.checkUser();
    // _coinList = await App.getCoinList(withoutNoTrade: true);
    // setState(() {});
    _wishList = await App.getWishList();
    // setState(() {});
    // _wishCount = await App.getTotalWishCount();
    // setState(() {});
    _itList = await App.getArticleList(
        Arrays.getBoardInfo(Define.INDEX_BOARD_IT_NEWS_PAGE),
        "",
        Define.DEFAULT_DASH_BOARD_GET_LENGTH);
    setState(() {});
    _gameList = await App.getArticleList(
        Arrays.getBoardInfo(Define.INDEX_BOARD_GAME_NEWS_PAGE),
        "",
        Define.DEFAULT_DASH_BOARD_GET_LENGTH);
    setState(() {});
    _articleList = await App.getArticleList(
        Arrays.getBoardInfo(Define.INDEX_BOARD_ALL_PAGE),
        "",
        Define.DEFAULT_DASH_BOARD_GET_LENGTH);
    setState(() {});
    await getExternalData();
  }

  Future<void> getExternalData() async {
    // News.getITWorldNewsList(context);
    if (await App.isMaster()) {
      Timer.periodic(const Duration(minutes: 60), (timer) async {
        await News.getGameNewsList(context);
        await News.getITWorldNewsList(context);
        await App.getCoinPriceFromPaprika(context);
      });
    }
  }

  void _onRefreshLite() async {
    logger.i("_onRefresh");
    _listMaxLength = Define.DEFAULT_BOARD_GET_LENGTH;
    _itList = await App.getArticleList(
        Arrays.getBoardInfo(Define.INDEX_BOARD_IT_NEWS_PAGE),
        "",
        Define.DEFAULT_DASH_BOARD_GET_LENGTH);
    setState(() {});
    _gameList = await App.getArticleList(
        Arrays.getBoardInfo(Define.INDEX_BOARD_GAME_NEWS_PAGE),
        "",
        Define.DEFAULT_DASH_BOARD_GET_LENGTH);
    setState(() {});
    _articleList = await App.getArticleList(
        Arrays.getBoardInfo(Define.INDEX_BOARD_ALL_PAGE),
        "",
        Define.DEFAULT_DASH_BOARD_GET_LENGTH);
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onRefresh() async {
    logger.i("_onRefresh");
    _listMaxLength = Define.DEFAULT_BOARD_GET_LENGTH;
    await init();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    logger.i("loading");
    _listMaxLength =
        _listMaxLength + Define.DEFAULT_BOARD_GET_LENGTH > _articleList.length
            ? _articleList.length
            : _listMaxLength + Define.DEFAULT_BOARD_GET_LENGTH;
    // loadAd();
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  final InAppReview _inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double width30 = width * 0.3;
    double width46 = width * 0.45;
    double width60 = width * 0.6;
    DateTime today = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
        iconTheme: const IconThemeData(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        elevation: 0,
        title: Text(
          "app_name".tr,
          style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        ),
        centerTitle: true,
        actions: AppBarAction(context, _profile),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        header: ClassicHeader(
          idleText: "header_idle_text".tr,
          releaseText: "header_release_text".tr,
          refreshingText: "header_loading_text".tr,
          completeText: "header_complete_text".tr,
        ),
        enablePullDown: true,
        onRefresh: _onRefreshLite,
        footer: ClassicFooter(
          idleText: "footer_can_loading_text".tr,
          canLoadingText: "footer_can_loading_text".tr,
          loadingText: "footer_loading_text".tr,
        ),
        enablePullUp: false,
        onLoading: _onLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_coinList.isNotEmpty)
                SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: ScrollLoopAutoScroll(
                    duplicateChild: 2,
                    scrollDirection: Axis.horizontal,
                    child: InkWell(
                      onTap: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const PointExchangeTabPage(),
                        ));
                      },
                      child: Row(
                        children: List.generate(_coinList.length, (index) {
                          return Wrap(children: [
                            Icon(
                              _getCryptoIcon(_coinList[index].id.split("-")[0]),
                              color: Color(_coinList[index].color!.toInt()),
                              size: 15,
                            ),
                            const SizedBox(width: 3),
                            RichText(
                              text: TextSpan(
                                  text: _coinList[index].symbol,
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text: (_coinList[index]
                                                    .diffPercentage ==
                                                null
                                            ? ""
                                            : "(${_coinList[index].diffPercentage! > 0 ? "+" : ""}${_coinList[index].diffPercentage!.toStringAsPrecision(1)}%)"),
                                        style: TextStyle(
                                            color: _coinList[index]
                                                        .diffPercentage! >
                                                    0
                                                ? Colors.green
                                                : Colors.red)),
                                  ]),
                            ),
                            const SizedBox(width: 10)
                          ]);
                        }),
                      ),
                    ),
                  ),
                ),
              Column(
                children: [
                  ListTile(
                    tileColor: Colors.grey.shade200,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          children: [
                            Column(
                              children: [
                                Text(today.month.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color:
                                            Utils.weekDayColor(today.weekday))),
                                Text("month".tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color:
                                            Utils.weekDayColor(today.weekday))),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Text(today.day.toString(),
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Utils.weekDayColor(today.weekday))),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 40,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                child: Text(Utils.weekDayString(today.weekday),
                                    style: TextStyle(
                                        color:
                                            Utils.weekDayColor(today.weekday))),
                              ),
                            )
                          ],
                        ),
                        Text("wish".tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await showKeyboardInput();
                    },
                    child: Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              const Image(
                                height: 180,
                                width: double.infinity,
                                image: AssetImage("assets/wish_of_stone.jpg"),
                                fit: BoxFit.fitWidth,
                              ),
                              if (_wishCount > 0)
                                Text(
                                    "${"total_wish".tr} ${Utils.numberFormat(_wishCount)}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15)),
                            ],
                          ),
                          if (_wishList.isNotEmpty)
                            SizedBox(
                              height: 60,
                              child: ScrollLoopAutoScroll(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children:
                                      List.generate(_wishList.length, (index) {
                                    return ListTile(
                                        leading: Text(
                                            "${_wishList[index].index} ${"place".tr}"),
                                        title: Text(_wishList[index].comments),
                                        subtitle: Text(
                                            "${_wishList[index].nick_name}(${_wishList[index].streak}${"streak".tr})"));
                                  }),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  if (_itList.isNotEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: InkWell(
                        onTap: () async {
                          // Navigator.of(context).push(SwipeablePageRoute(
                          //   builder: (BuildContext context) =>
                          //       ArticleDetailPage(
                          //     article: _itList[0],
                          //     boardInfo: Arrays.getBoardInfo(
                          //         Define.INDEX_BOARD_IT_NEWS_PAGE),
                          //     isFromDash: true,
                          //   ),
                          // ));

                          _itList[0] = _itList[0].copyWith(
                            count_view: await App.articleCountViewUp(_itList[0].key),
                          );

                          if (!mounted) return;

                          await GoRouter.of(context)
                              .push("/detail/${_itList[0].key}");
                        },
                        child: Card(
                          elevation: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5)),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fitHeight,
                                      width: width30,
                                      imageUrl: _itList[0].thumbnail ?? "",
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: Image.asset(
                                                  'assets/icon.png',
                                                  color: Colors.grey,
                                                  fit: BoxFit.fitHeight)),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: SizedBox(
                                  height: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("it_news_board".tr,
                                                style: const TextStyle(
                                                    color: Colors.grey)),
                                            Text(
                                              _itList[0].title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                Utils
                                                    .toConvertFireDateToCommentTime(
                                                        _itList[0].created_at),
                                                style: const TextStyle(
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (_itList.isNotEmpty && _itList.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        elevation: 2,
                        child: Column(
                          children: [
                            Column(
                              children: List.generate(
                                  _itList.length > 2 ? 3 : _itList.length - 1,
                                  (index) {
                                return Column(
                                  children: [
                                    ListTile(
                                        onTap: () async {
                                          // Navigator.of(context)
                                          //     .push(SwipeablePageRoute(
                                          //   builder: (BuildContext context) =>
                                          //       ArticleDetailPage(
                                          //     article: _itList[index + 1],
                                          //     boardInfo: Arrays.getBoardInfo(
                                          //         Define
                                          //             .INDEX_BOARD_IT_NEWS_PAGE),
                                          //     isFromDash: true,
                                          //   ),
                                          // ));
                                          // context
                                          //     .go('/detail/' + _itList[index + 1].key);
                                          GoRouter.of(context).push(
                                              "/detail/${_itList[index + 1].key}");

                                          _itList[index + 1] = _itList[index + 1].copyWith(
                                            count_view: await App.articleCountViewUp(
                                                _itList[index + 1].key),
                                          );
                                        },
                                        visualDensity: const VisualDensity(
                                            horizontal: 0, vertical: -4),
                                        title: Text(_itList[index + 1].title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1)),
                                    Define.APP_DIVIDER,
                                  ],
                                );
                              }),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.of(context)
                                //     .push(SwipeablePageRoute(
                                //   builder: (BuildContext context) =>
                                //       ArticleListPage(Arrays.getBoardInfo(
                                //           Define.INDEX_BOARD_IT_NEWS_PAGE)),
                                // ));
                                // context.go(
                                //     '/list/' + Define.INDEX_BOARD_IT_NEWS_PAGE.toString());

                                GoRouter.of(context).push(
                                    "/list/${Define.INDEX_BOARD_IT_NEWS_PAGE}");
                              },
                              child: ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),
                                title: Text(
                                  "${"it_news_board".tr} >",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_gameList.isNotEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: InkWell(
                        onTap: () async {
                          // Navigator.of(context).push(SwipeablePageRoute(
                          //   builder: (BuildContext context) =>
                          //       ArticleDetailPage(
                          //     article: _gameList[0],
                          //     boardInfo: Arrays.getBoardInfo(
                          //         Define.INDEX_BOARD_GAME_NEWS_PAGE),
                          //     isFromDash: true,
                          //   ),
                          // ));

                          _gameList[0] = _gameList[0].copyWith(
                            count_view: await App.articleCountViewUp(_gameList[0].key),
                          );

                          if (!mounted) return;

                          await GoRouter.of(context)
                              .push("/detail/${_gameList[0].key}");
                        },
                        child: Card(
                          elevation: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5)),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fitHeight,
                                      width: width30,
                                      imageUrl: _gameList[0].thumbnail ?? "",
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: Image.asset(
                                                  'assets/icon.png',
                                                  color: Colors.grey,
                                                  fit: BoxFit.fitHeight)),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: SizedBox(
                                  height: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("game_news_board".tr,
                                                style: const TextStyle(
                                                    color: Colors.grey)),
                                            Text(
                                              _gameList[0].title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                Utils
                                                    .toConvertFireDateToCommentTime(
                                                        _gameList[0]
                                                            .created_at),
                                                style: const TextStyle(
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (_gameList.isNotEmpty && _gameList.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        elevation: 2,
                        child: Column(
                          children: [
                            Column(
                              children: List.generate(
                                  _gameList.length > 2
                                      ? 3
                                      : _gameList.length - 1, (index) {
                                return Column(
                                  children: [
                                    ListTile(
                                        onTap: () async {
                                          // Navigator.of(context)
                                          //     .push(SwipeablePageRoute(
                                          //   builder: (BuildContext context) =>
                                          //       ArticleDetailPage(
                                          //     article: _gameList[index + 1],
                                          //     boardInfo: Arrays.getBoardInfo(Define
                                          //         .INDEX_BOARD_GAME_NEWS_PAGE),
                                          //     isFromDash: true,
                                          //   ),
                                          // ));
                                          GoRouter.of(context).push(
                                              "/detail/${_gameList[index + 1].key}");
                                          _gameList[index + 1] = _gameList[index + 1].copyWith(
                                            count_view: await App.articleCountViewUp(
                                                _gameList[index + 1].key),
                                          );
                                        },
                                        visualDensity: const VisualDensity(
                                            horizontal: 0, vertical: -4),
                                        title: Text(_gameList[index + 1].title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1)),
                                    Define.APP_DIVIDER,
                                  ],
                                );
                              }),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Navigator.of(context)
                                //     .push(SwipeablePageRoute(
                                //   builder: (BuildContext context) =>
                                //       ArticleListPage(Arrays.getBoardInfo(
                                //           Define.INDEX_BOARD_GAME_NEWS_PAGE)),
                                // ));
                                GoRouter.of(context).push(
                                    "/list/${Define.INDEX_BOARD_GAME_NEWS_PAGE}");
                              },
                              child: ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),
                                title: Text(
                                  "${"game_news_board".tr} >",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      // await Navigator.of(context).push(SwipeablePageRoute(
                      //   builder: (BuildContext context) => ArticleListPage(
                      //       Arrays.getBoardInfo(Define.INDEX_BOARD_ALL_PAGE)),
                      // ));
                      GoRouter.of(context)
                          .push("/list/${Define.INDEX_BOARD_ALL_PAGE}");
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 15),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Text(
                            "all_board".tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (_articleList.isNotEmpty)
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: List.generate(
                            _articleList.length <= 20
                                ? _articleList.length
                                : 20, (index) {
                          String image = "";
                          for (int i = 0;
                              i < _articleList[index].contents.length;
                              i++) {
                            if (_articleList[index].contents[i].isPicture) {
                              image = _articleList[index].contents[i].contents;
                              break;
                            }
                          }

                          return Column(
                            children: [
                              ListTile(
                                onTap: () async {
                                  // Navigator.of(context).push(SwipeablePageRoute(
                                  //   builder: (BuildContext context) =>
                                  //       ArticleDetailPage(
                                  //     article: _articleList[index],
                                  //     boardInfo: Arrays.getBoardInfo(
                                  //         Define.INDEX_BOARD_ALL_PAGE),
                                  //     isFromDash: true,
                                  //   ),
                                  // ));

                                  _articleList[index] = _articleList[index].copyWith(
                                    count_view: await App.articleCountViewUp(
                                        _articleList[index].key),
                                  );

                                  if (!mounted) return;

                                  await GoRouter.of(context).push(
                                      "/detail/${_articleList[index].key}");
                                },
                                leading: CachedNetworkImage(
                                  imageUrl: image,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 60,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      SizedBox(
                                    width: 60,
                                    height: 40,
                                    child: Image.asset('assets/icon.png',
                                        color: Colors.grey,
                                        fit: BoxFit.fitHeight),
                                  ),
                                ),
                                title: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  text: TextSpan(
                                      text: _articleList[index].title,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text: _articleList[index]
                                                    .comments
                                                    .isNotEmpty
                                                ? "[${_articleList[index].comments.length}]"
                                                : "",
                                            style: const TextStyle(
                                                color: Colors.indigoAccent))
                                      ]),
                                ),
                                subtitle: Text(
                                    "${Arrays.getBoardInfo(_articleList[index].board_index).title.tr} | ${Utils.toConvertFireDateToCommentTime(_articleList[index].created_at)}"),
                              ),
                              Define.APP_DIVIDER
                            ],
                          );
                        }),
                      ),
                    ),
                  InkWell(
                    onTap: () async {
                      // await Navigator.of(context).push(SwipeablePageRoute(
                      //   builder: (BuildContext context) => ArticleListPage(
                      //       Arrays.getBoardInfo(Define.INDEX_BOARD_ALL_PAGE)),
                      // ));

                      GoRouter.of(context)
                          .push("/list/${Define.INDEX_BOARD_ALL_PAGE}");
                    },
                    child: ListTile(
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -4),
                      title: Text(
                        "${"all_board".tr} >",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomSheet: !_showInput
          ? null
          : ListTile(
              tileColor: Colors.white.withOpacity(0.2),
              contentPadding: const EdgeInsets.only(left: 3, right: 3),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    enabled: !_isCommentLoading,
                    controller: _commentController,
                    focusNode: _commentFocusNode,
                    decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: "",
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        suffixIcon: _isCommentLoading
                            ? Transform.scale(
                                scale: 0.5,
                                child: const CircularProgressIndicator())
                            : IconButton(
                                icon: Icon(LineIcons.magic,
                                    color: _commentController.text.isEmpty
                                        ? Colors.grey
                                        : Colors.lightBlue),
                                onPressed: _commentController.text.isEmpty
                                    ? null
                                    : () async {
                                        await createWish(
                                            _commentController.text);
                                      },
                              )),
                    onChanged: (s) {
                      setState(() {});
                    },
                    onFieldSubmitted: _commentController.text.isEmpty
                        ? null
                        : (s) async {
                            await createWish(_commentController.text);
                          },
                  ),
                ],
              ),
            ),
      drawer: const LeftDrawer(),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width / 2,
    );
  }

  Future<void> showKeyboardInput() async {
    bool alreadyWished = await Utils.getAlreadyWish();
    if (alreadyWished) {
      Fluttertoast.showToast(msg: "already_wished".tr);
      setState(() {
        _showInput = false;
      });
      return;
    }
    logger.d("showKeyboardInput");
    logger.d(_commentController.text.isEmpty);
    if (_commentController.text.isEmpty) {
      setState(() {
        _showInput = !_showInput;
      });
      if (_showInput) {
        _commentFocusNode.requestFocus();
      }
    }
  }

  Future<void> createWish(String wish) async {
    if (wish.isEmpty || _isCommentLoading) {
      return;
    }
    setState(() {
      _isCommentLoading = true;
    });
    List<Wish> wishList = await App.updateWish(_profile, wish);
    setState(() {
      _wishList = wishList;
    });
    await Utils.setAlreadyWish(Utils.getStringToday());
    _profile = _profile.copyWith(wish_streak: _profile.wish_streak + 1);

    if (mounted) {
      Fluttertoast.showToast(msg: "success_create_wish".tr);
    }
    _profile = await App.checkUser();
    setState(() {
      _isCommentLoading = false;
      _commentController.text = "";
      _showInput = false;
    });
  }

  @override
  bool get wantKeepAlive => true;

  IconData _getCryptoIcon(String symbol) {
    switch (symbol.toLowerCase()) {
      case 'btc':
        return CryptoFontIcons.BTC;
      case 'eth':
        return CryptoFontIcons.ETH;
      case 'usdt':
        return CryptoFontIcons.USDT;
      case 'doge':
        return CryptoFontIcons.DOGE;
      default:
        return CryptoFontIcons.BTC;
    }
  }
}
