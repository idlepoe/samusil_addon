import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../define/arrays.dart';
import '../../../define/define.dart';
import '../../../models/article.dart';
import '../../../utils/util.dart';
import '../dash_board_controller.dart';

class AllArticlesWidget extends StatelessWidget {
  final DashBoardController controller;
  final List<Article> articleList;

  const AllArticlesWidget({
    super.key,
    required this.controller,
    required this.articleList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            GoRouter.of(context).push("/list/${Define.BOARD_ALL}");
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
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (articleList.isNotEmpty)
          Container(
            color: Colors.white,
            child: Column(
              children: List.generate(
                articleList.length <= 20 ? articleList.length : 20,
                (index) {
                  String image = "";
                  for (int i = 0; i < articleList[index].contents.length; i++) {
                    if (articleList[index].contents[i].isPicture) {
                      image = articleList[index].contents[i].contents;
                      break;
                    }
                  }

                  return Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          await controller.articleCountViewUp(
                            articleList[index].key,
                          );

                          if (!Get.context!.mounted) return;

                          await GoRouter.of(
                            context,
                          ).push("/detail/${articleList[index].key}");
                        },
                        leading: CachedNetworkImage(
                          imageUrl: image,
                          imageBuilder:
                              (context, imageProvider) => Container(
                                width: 60,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          placeholder:
                              (context, url) =>
                                  const CircularProgressIndicator(),
                          errorWidget:
                              (context, url, error) => SizedBox(
                                width: 60,
                                height: 40,
                                child: Image.asset(
                                  'assets/icon.png',
                                  color: Colors.grey,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                        ),
                        title: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          text: TextSpan(
                            text: articleList[index].title,
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text:
                                    articleList[index].count_comments > 0
                                        ? "[${articleList[index].count_comments}]"
                                        : "",
                                style: const TextStyle(
                                  color: Colors.indigoAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text(
                          "${Arrays.getBoardInfo(articleList[index].board_name).title.tr} | ${Utils.toConvertFireDateToCommentTime(articleList[index].created_at)}",
                        ),
                      ),
                      Define.APP_DIVIDER,
                    ],
                  );
                },
              ),
            ),
          ),
        InkWell(
          onTap: () async {
            GoRouter.of(context).push("/list/${Define.BOARD_ALL}");
          },
          child: ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: Text(
              "${"all_board".tr} >",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
