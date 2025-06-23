import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/appTextField.dart';
import '../../../define/define.dart';
import '../../../models/article_contents.dart';
import '../../../utils/util.dart';
import 'article_search_controller.dart';

class ArticleSearchView extends GetView<ArticleSearchController> {
  const ArticleSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
        iconTheme: const IconThemeData(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        elevation: 0,
        title: Text(
          "검색",
          style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 10,
              left: 10,
              right: 10,
            ),
            child: AppTextField(
              "",
              controller.searchTextFieldController,
              focusNode: controller.focusNode,
              radius: 0,
              suffixIcon: IconButton(
                onPressed: () async {
                  await controller.getArticleList();
                },
                icon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getArticleList();
        },
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Obx(
              () => Column(
                children: [
                  Column(
                    children: List.generate(controller.list.length, (index) {
                      final article = controller.list[index];
                      bool hasPicture = article.contents.any(
                        (ac) => ac.isPicture,
                      );
                      bool noContents = article.contents.isEmpty;
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              (hasPicture
                                      ? controller.boardInfo.value.isPopular ??
                                              false
                                          ? "🌟"
                                          : "🖼 "
                                      : "") +
                                  article.title +
                                  (noContents ? " (내용 없음)" : "") +
                                  (article.count_comments > 0
                                      ? " [${article.count_comments}]"
                                      : ""),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${controller.boardInfo.value.board_name == Define.BOARD_ALL ? Utils.convertBoardNameToKorean(controller.boardInfo.value.board_name) : article.profile_name} | 조회수 ${article.count_view} | 추천 ${article.count_like}",
                                ),
                                Text(
                                  Utils.toConvertFireDateToCommentTime(
                                    DateFormat(
                                      'yyyyMMddHHmm',
                                    ).format(article.created_at),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              Get.toNamed("/detail/${article.id}");
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
      ),
    );
  }
}
