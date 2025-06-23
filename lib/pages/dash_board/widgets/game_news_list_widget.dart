import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:office_lounge/components/article_image_widget.dart';

import '../../../components/appCircularProgress.dart';
import '../../../define/arrays.dart';
import '../../../define/define.dart';
import '../../../models/article.dart';
import '../../../utils/app.dart';
import '../../../utils/util.dart';
import '../dash_board_controller.dart';

class GameNewsListWidget extends StatelessWidget {
  final DashBoardController controller;
  final logger = Logger();

  GameNewsListWidget({super.key, required this.controller});

  String _getThumbnailUrl(Article article) {
    for (int i = 0; i < article.contents.length; i++) {
      if (article.contents[i].isPicture) {
        return article.contents[i].contents;
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingGameNews.value) {
        return const Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: AppCircularProgress()),
            ),
          ),
        );
      }

      if (controller.gameNews.isEmpty) {
        return Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.article_outlined,
                    color: Colors.grey[600],
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '게임 뉴스가 없습니다',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '새로운 게임 소식을 기다려주세요!',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      final gameList = controller.gameNews;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 섹션 헤더 (전체가 클릭 가능)
            InkWell(
              onTap: () {
                Get.toNamed("/list/${Define.BOARD_GAME_NEWS}");
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0064FF),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "게임뉴스",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191F28),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "더보기",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Column(
                children: [
                  // 첫 번째 게시글 (섬네일 포함)
                  if (gameList.isNotEmpty)
                    InkWell(
                      onTap: () async {
                        Get.toNamed("/detail/${gameList[0].id}");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 섬네일
                            ArticleImageWidget(
                              imageUrl: _getThumbnailUrl(gameList[0]),
                              width: 80,
                              height: 60,
                              borderRadius: BorderRadius.circular(8),
                              showLoadingIndicator: false,
                            ),
                            const SizedBox(width: 12),
                            // 제목과 날짜
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    gameList[0].title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF191F28),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      DateFormat(
                                        'MM-dd',
                                      ).format(gameList[0].created_at),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // 나머지 게시글들
                  ...List.generate(
                    gameList.length > 1 ? gameList.length - 1 : 0,
                    (index) {
                      final actualIndex = index + 1;
                      return InkWell(
                        onTap: () async {
                          Get.toNamed("/detail/${gameList[actualIndex].id}");
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  gameList[actualIndex].title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF191F28),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat(
                                  'MM-dd',
                                ).format(gameList[actualIndex].created_at),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
