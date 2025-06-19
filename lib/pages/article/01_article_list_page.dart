import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:logger/logger.dart';
import 'package:samusil_addon/components/appBarAction.dart';
import 'package:samusil_addon/models/board_info.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../components/bottomButton.dart';
import '../../define/define.dart';
import '../../define/enum.dart';
import '../../models/article.dart';
import '../../models/article_contents.dart';
import '../../models/profile.dart';
import '../../utils/app.dart';
import '../../utils/util.dart';

class ArticleListPage extends StatefulWidget {
  BoardInfo boardInfo;

  ArticleListPage(this.boardInfo, {super.key});

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage>
    with AutomaticKeepAliveClientMixin {
  var logger = Logger();

  Profile _profile = Profile.init();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _listMaxLength = Define.DEFAULT_BOARD_PAGE_LENGTH;

  BoardInfo _boardInfo = BoardInfo.init();
  List<Article> _list = [];

  ViewType viewType = ViewType.normal;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    logger.i("ArticleListPage init");
    _boardInfo = widget.boardInfo;
    _profile = await App.getProfile();
    _list = await App.getArticleList(
        _boardInfo, "", Define.DEFAULT_BOARD_GET_LENGTH);
    setState(() {});
  }

  void _onRefresh() async {
    logger.i("_onRefresh");
    _listMaxLength = Define.DEFAULT_BOARD_PAGE_LENGTH;
    await init();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    logger.i("loading");
    _listMaxLength =
        _listMaxLength + Define.DEFAULT_BOARD_PAGE_LENGTH > _list.length
            ? _list.length
            : _listMaxLength + Define.DEFAULT_BOARD_PAGE_LENGTH;
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
        iconTheme: const IconThemeData(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        elevation: 0,
        title: Text(
          _boardInfo.title.tr,
          style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        ),
        centerTitle: true,
        actions: AppBarAction(context, _profile),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: Define.BOTTOM_SHEET_HEIGHT),
        child: SmartRefresher(
          controller: _refreshController,
          header: ClassicHeader(
            idleText: "header_idle_text".tr,
            releaseText: "header_release_text".tr,
            refreshingText: "header_loading_text".tr,
            completeText: "header_complete_text".tr,
          ),
          enablePullDown: true,
          onRefresh: _onRefresh,
          footer: ClassicFooter(
            idleText: "footer_can_loading_text".tr,
            canLoadingText: "footer_can_loading_text".tr,
            loadingText: "footer_loading_text".tr,
          ),
          enablePullUp: _list.length > _listMaxLength,
          onLoading: _onLoading,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    _boardInfo.description.tr,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                    ),
                    maxLines: 3,
                  ),
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                ),
                Define.APP_DIVIDER,
                Column(
                  children: List.generate(
                      _list.length > _listMaxLength
                          ? _listMaxLength
                          : _list.length, (index) {
                    bool hasPicture = false;
                    for (ArticleContent ac in _list[index].contents) {
                      if (ac.isPicture) {
                        hasPicture = true;
                      }
                    }
                    bool noContents = _list[index].contents.isEmpty;
                    return Column(
                      children: [
                  
                        ListTile(
                          title: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: (hasPicture
                                          ? viewType == ViewType.popular
                                              ? "🌟"
                                              : "🖼 "
                                          : "") +
                                      _list[index].title +
                                      (noContents
                                          ? " (${"no_contents".tr})"
                                          : ""),
                                  style: const TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: (_list[index].comments.isNotEmpty
                                      ? " [${_list[index].comments.length}]"
                                      : ""),
                                  style: const TextStyle(
                                      color: Colors.indigoAccent))
                            ]),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "${_list[index].profile_name} | ${"count_view".tr} ${_list[index].count_view} | ${"recommend".tr} ${_list[index].count_like}"),
                              Text(Utils.toConvertFireDateToCommentTimeToday(
                                  _list[index].created_at)),
                            ],
                          ),
                          onTap: () async {
                            // bool? isEdit = await Navigator.of(context)
                            //     .push(SwipeablePageRoute(
                            //   builder: (BuildContext context) =>
                            //       ArticleDetailPage(
                            //     article: _list[index],
                            //     boardInfo: _boardInfo,
                            //     isFromDash: false,
                            //   ),
                            // ));
                            // logger.w(isEdit);
                            _list[index] = _list[index].copyWith(
                              count_view: await App.articleCountViewUp(_list[index].key),
                            );

                            if (!mounted) return;
                            await GoRouter.of(context)
                                .push("/detail/${_list[index].key}");

                            // if (Utils.isValidateBool(isEdit)) {
                            await init();
                            // }
                          },
                          visualDensity: const VisualDensity(vertical: -4),
                        ),
                        Define.APP_DIVIDER,
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: SizedBox(
        height: Define.BOTTOM_SHEET_HEIGHT,
        child: Column(
          children: [
            Define.APP_DIVIDER,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BottomIconButton(LineIcons.home, "dash_board".tr, onTap: () {
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     SwipeablePageRoute(
                  //         builder: (BuildContext context) => DashBoardPage()),
                  //     (Route<dynamic> route) => false);
                  context.go("/");
                }),
                // BottomIconButton(
                //   viewType == ViewType.notice
                //       ? Icons.list
                //       : LineIcons.chalkboard,
                //   viewType == ViewType.notice ? "all_article".tr : "notice".tr,
                //   onTap: () async {
                //     viewType = viewType == ViewType.notice
                //         ? ViewType.normal
                //         : ViewType.notice;
                //     _boardInfo.isNotice = viewType == ViewType.notice;
                //     _boardInfo.isPopular = false;
                //     _list = await App.getArticleList(_boardInfo, "");
                //     setState(() {});
                //   },
                //   color:
                //       viewType == ViewType.notice ? Colors.blue : Colors.black,
                // ),
                // BottomIconButton(
                //     viewType == ViewType.popular
                //         ? Icons.list
                //         : Icons.star_border,
                //     viewType == ViewType.popular
                //         ? "all_article".tr
                //         : "popular".tr, onTap: () async {
                //   viewType = viewType == ViewType.popular
                //       ? ViewType.normal
                //       : ViewType.popular;
                //   _boardInfo.isNotice = false;
                //   _boardInfo.isPopular = viewType == ViewType.popular;
                //   _list = await App.getArticleList(_boardInfo, "");
                //   setState(() {});
                // },
                //     color: viewType == ViewType.popular
                //         ? Colors.blue
                //         : Colors.black),
                BottomIconButton(Icons.search, "search".tr, onTap: () async {
                  // await Navigator.of(context).push(SwipeablePageRoute(
                  //   builder: (BuildContext context) => ArticleSearchPage(
                  //     boardInfo: _boardInfo,
                  //   ),
                  // ));
                  GoRouter.of(context).push("/list/${_boardInfo.index}/search");
                }),
                BottomIconButton(LineIcons.pen, "write".tr, onTap: () async {
                  // await Navigator.of(context).push(SwipeablePageRoute(
                  //   builder: (BuildContext context) => ArticleEditPage(
                  //     boardInfo: _boardInfo,
                  //   ),
                  // ));
                  // await init();
                  await GoRouter.of(context)
                      .push("/list/${_boardInfo.index}/edit");
                  await init();
                }, disabled: !_boardInfo.isCanWrite),
              ],
            ),
          ],
        ),
      ),
      // drawer: LeftDrawer(),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
