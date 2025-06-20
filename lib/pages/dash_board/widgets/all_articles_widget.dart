import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../define/arrays.dart';
import '../../../define/define.dart';
import '../../../models/article.dart';
import '../../../utils/app.dart';
import '../../../utils/util.dart';
import '../dash_board_controller.dart';

class AllArticlesWidget extends StatelessWidget {
  final DashBoardController controller;
  final logger = Logger();

  AllArticlesWidget({super.key, required this.controller});

  Future<List<Article>> _loadAllArticles() async {
    try {
      return await App.getArticleList(
        boardInfo: Arrays.getBoardInfo(Define.BOARD_FREE),
        search: "",
        limit: Define.DEFAULT_DASH_BOARD_GET_LENGTH,
      );
    } catch (e) {
      logger.e("Error loading all articles: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: _loadAllArticles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.error_outline, color: Colors.grey[600], size: 48),
                  const SizedBox(height: 16),
                  Text(
                    '게시글을 불러올 수 없습니다',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
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
                    '게시글이 없습니다',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        final articleList = snapshot.data!;

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
              // 섹션 헤더
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C851),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed("/list/${Define.BOARD_FREE}");
                        },
                        child: Text(
                          "자유게시판",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF191F28),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed("/list/${Define.BOARD_FREE}");
                      },
                      child: Text(
                        "더보기",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    if (articleList.isNotEmpty)
                      ...List.generate(
                        articleList.length <= 20 ? articleList.length : 20,
                        (index) {
                          String image = "";
                          for (
                            int i = 0;
                            i < articleList[index].contents.length;
                            i++
                          ) {
                            if (articleList[index].contents[i].isPicture) {
                              image = articleList[index].contents[i].contents;
                              break;
                            }
                          }

                          return InkWell(
                            onTap: () async {
                              if (!Get.context!.mounted) return;
                              Get.toNamed("/detail/${articleList[index].id}");
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 섬네일
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedNetworkImage(
                                      imageUrl: image,
                                      width: 60,
                                      height: 45,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) => Container(
                                            width: 60,
                                            height: 45,
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                      errorWidget:
                                          (context, url, error) => Container(
                                            width: 60,
                                            height: 45,
                                            color: Colors.grey[200],
                                            child: Icon(
                                              Icons.image,
                                              color: Colors.grey[400],
                                              size: 20,
                                            ),
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // 제목과 정보
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          articleList[index].title,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF191F28),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFF0064FF,
                                                ).withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                Arrays.getBoardInfo(
                                                  articleList[index].board_name,
                                                ).title.tr,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF0064FF),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              Utils.toConvertFireDateToCommentTime(
                                                DateFormat(
                                                  'yyyyMMddHHmm',
                                                ).format(
                                                  articleList[index].created_at,
                                                ),
                                              ),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (articleList[index]
                                                    .count_comments >
                                                0) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 1,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF00C851,
                                                  ).withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                                child: Text(
                                                  "${articleList[index].count_comments}",
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF00C851),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 40,
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.article_outlined,
                              color: Colors.grey[400],
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '게시글이 없습니다',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '첫 번째 게시글을 작성해보세요!',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
