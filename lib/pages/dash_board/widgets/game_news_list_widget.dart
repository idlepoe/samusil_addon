import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../define/define.dart';
import '../../../models/article.dart';
import '../dash_board_controller.dart';

class GameNewsListWidget extends StatelessWidget {
  final DashBoardController controller;
  final List<Article> gameList;

  const GameNewsListWidget({
    super.key,
    required this.controller,
    required this.gameList,
  });

  @override
  Widget build(BuildContext context) {
    if (gameList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            Column(
              children: List.generate(
                gameList.length > 2 ? 3 : gameList.length,
                (index) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          GoRouter.of(
                            context,
                          ).push("/detail/${gameList[index].key}");

                          await controller.articleCountViewUp(
                            gameList[index].key,
                          );
                        },
                        visualDensity: const VisualDensity(
                          horizontal: 0,
                          vertical: -4,
                        ),
                        title: Text(
                          gameList[index].title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Define.APP_DIVIDER,
                    ],
                  );
                },
              ),
            ),
            InkWell(
              onTap: () async {
                GoRouter.of(
                  context,
                ).push("/list/${Define.INDEX_BOARD_GAME_NEWS_PAGE}");
              },
              child: ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                title: Text(
                  "${"game_news_board".tr} >",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
