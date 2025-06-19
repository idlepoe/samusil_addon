import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:samusil_addon/models/board_info.dart';

import '../../components/appTextField.dart';
import '../../define/arrays.dart';
import '../../define/define.dart';
import '../../models/article.dart';
import '../../models/article_contents.dart';
import '../../utils/app.dart';
import '../../utils/util.dart';

class ArticleSearchPage extends StatefulWidget {
  final BoardInfo boardInfo;

  const ArticleSearchPage({super.key, required this.boardInfo});

  @override
  State<ArticleSearchPage> createState() => _ArticleSearchPageState();
}

class _ArticleSearchPageState extends State<ArticleSearchPage> {
  var logger = Logger();
  BoardInfo _boardInfo = BoardInfo.init();
  List<Article> _list = [];

  final TextEditingController _searchTextFieldController =
      TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _boardInfo = widget.boardInfo;
    await getArticleList();
  }

  Future<void> getArticleList() async {
    _list = await App.getArticleList(_boardInfo,_searchTextFieldController.text,Define.DEFAULT_BOARD_GET_LENGTH);
    if (mounted) {
      // Utils.showSnackBar(context,SnackType.success,"success_get_article_list".tr);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
        iconTheme: const IconThemeData(
          color: Define.APP_BAR_TITLE_TEXT_COLOR,
        ),
        elevation: 0,
        title: Text("search".tr,
            style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR)),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 5, bottom: 10, left: 10, right: 10),
              child: AppTextField("", _searchTextFieldController,
                focusNode: _focusNode,
                radius: 0,
                suffixIcon: IconButton(onPressed: () async {
                  await getArticleList();
                }, icon: const Icon(Icons.search))),
            )),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getArticleList();
        },
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              children: [
                Column(
                  children: List.generate(_list.length, (index) {
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
                          title: Text((hasPicture
                                  ? _boardInfo.isPopular ?? false
                                      ? "🌟"
                                      : "🖼 "
                                  : "") +
                              _list[index].title +
                              (noContents ? " (${"no_contents".tr})" : "") +
                              (_list[index].comments.isNotEmpty
                                  ? " [${_list[index].comments.length}]"
                                  : "")),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "${_boardInfo.index == 9 ? Arrays.getBoardInfo(_list[index].board_index).title : _list[index].profile_name} | ${"count_view".tr} ${_list[index].count_view} | ${"recommend".tr} ${_list[index].count_like}"),
                              Text(Utils.toConvertFireDateToCommentTime(
                                  _list[index].created_at))
                            ],
                          ),
                          onTap: () async {
                            // await Navigator.of(context).push(SwipeablePageRoute(
                            //   builder: (BuildContext context) =>
                            //       ArticleDetailPage(
                            //     article: _list[index],
                            //     boardInfo: _boardInfo,isFromDash: false,
                            //   ),
                            // ));
                            GoRouter.of(context).push("/detail/${_list[index].key}");
                            _list[index] = _list[index].copyWith(
                              count_view: await App.articleCountViewUp(_list[index].key),
                            );
                            // await getArticleList();
                            if (mounted) {
                              setState(() {});
                            }
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
    );
  }
}
