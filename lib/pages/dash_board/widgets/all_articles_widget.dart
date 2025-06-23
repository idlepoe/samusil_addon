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

class AllArticlesWidget extends StatelessWidget {
  final DashBoardController controller;
  final logger = Logger();

  AllArticlesWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingAllArticles.value) {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: AppCircularProgress()),
        );
      }

      if (controller.allArticles.isEmpty) {
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
                    '게시글이 없습니다',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '첫 번째 게시글을 작성해보세요!',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // 게시글 목록 화면으로 이동하고 작성 bottom sheet 표시
                      Get.toNamed(
                        "/list/${Define.BOARD_FREE}",
                        arguments: {'showWriteSheet': true},
                      );
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('게시글 작성하기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0064FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      final articleList = controller.allArticles;

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
                        "잡담 게시판",
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
                        int imageCount = 0;
                        int additionalImageCount = 0;

                        // 이미지 개수 계산
                        for (
                          int i = 0;
                          i < articleList[index].contents.length;
                          i++
                        ) {
                          if (articleList[index].contents[i].isPicture) {
                            imageCount++;
                            if (image.isEmpty) {
                              image = articleList[index].contents[i].contents;
                            }
                          }
                        }

                        // 추가 이미지 개수 계산 (첫 번째 이미지 제외)
                        if (imageCount > 1) {
                          additionalImageCount = imageCount - 1;
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
                                // 이미지 섹션 (왼쪽)
                                if (image.isNotEmpty)
                                  ArticleImageWidget(
                                    imageUrl: image,
                                    width: 50,
                                    height: 50,
                                    borderRadius: BorderRadius.circular(6),
                                    showLoadingIndicator: false,
                                    additionalImageCount:
                                        additionalImageCount > 0
                                            ? additionalImageCount
                                            : null,
                                  )
                                else
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.grey[400],
                                      size: 20,
                                    ),
                                  ),
                                const SizedBox(width: 12),
                                // 제목과 정보 (오른쪽)
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
                                            padding: const EdgeInsets.symmetric(
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
                                            articleList[index].profile_name,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            DateFormat('MM/dd').format(
                                              articleList[index].created_at,
                                            ),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.remove_red_eye_outlined,
                                            size: 14,
                                            color: Colors.grey[500],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${articleList[index].count_view}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Icon(
                                            Icons.favorite_outline,
                                            size: 14,
                                            color: Colors.grey[500],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${articleList[index].count_like}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Icon(
                                            Icons.chat_bubble_outline,
                                            size: 14,
                                            color: Colors.grey[500],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${articleList[index].count_comments}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                            ),
                                          ),
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
