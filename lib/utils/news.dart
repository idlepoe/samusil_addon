// import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:samusil_addon/define/arrays.dart';
import 'package:samusil_addon/define/define.dart';
import 'package:samusil_addon/models/article_contents.dart';
import 'package:samusil_addon/utils/util.dart';

import '../define/enum.dart';
import '../models/article.dart';
import 'app.dart';

class News {
  static Future<void> getGameNewsList(BuildContext context) async {
    var logger = Logger();

    Utils.showSnackBar(
      context,
      SnackType.info,
      "${"process_start".tr} : ${"game_news_board".tr}",
    );

    List<Article> duplicateList = await App.getArticleList(
      Arrays.getBoardInfoByIndex(Define.INDEX_BOARD_GAME_NEWS_PAGE),
      "",
      Define.DEFAULT_BOARD_GET_LENGTH,
    );

    List<Article> addNewsArticleList = [];

    final response = await get(Uri.parse("https://www.gamemeca.com/news.php"));

    switch (response.statusCode) {
      case 200:
        dom.Document document = parse(response.bodyBytes);
        dom.Element? element = document.querySelector('.list_news');
        if (element == null) {
          logger.w("list_news == null");
          break;
        }

        List<dom.Element> elementList = element.querySelectorAll('li');

        String newsKey = Utils.getDateTimeKey();
        int index = 0;
        for (var row in elementList.reversed.toList()) {
          Article target = const Article(
            key: "",
            board_name: "",
            profile_key: "",
            profile_name: "",
            count_view: 0,
            count_like: 0,
            count_unlike: 0,
            count_comments: 0,
            title: "",
            contents: [],
            created_at: "",
            is_notice: false,
          );
          List<dom.Element> contentsList = row.querySelectorAll('div');
          target = target.copyWith(
            title: contentsList[0].text
                .replaceAll("	", "")
                .replaceAll("\n", ""),
          );

          String link =
              contentsList[0].querySelector("a")!.attributes["href"] ?? "";

          final response1 = await get(
            Uri.parse("https://www.gamemeca.com$link"),
          );

          if (response1.statusCode != 200) {
            logger.w("element == null");
            break;
          }

          dom.Document document = parse(response1.bodyBytes);
          dom.Element? element = document.querySelector('.article');
          if (element == null) {
            logger.w("article == null");
            break;
          }

          List<ArticleContent> contents = [];
          List<dom.Element> element1List = element.querySelectorAll('div');
          for (dom.Element row1 in element1List) {
            String contents1 =
                row1.text.replaceAll("	", "").replaceAll("\n", "").trim();
            if (contents1.isNotEmpty && !contents1.contains("영상출처")) {
              contents.add(
                ArticleContent(isPicture: false, contents: contents1),
              );
            }
            List<dom.Element> element2List = row1.querySelectorAll('div');
            for (dom.Element row2 in element2List) {
              dom.Element? image = row2.querySelector('img');
              if (image == null) {
                String contents2 =
                    row2.text.replaceAll("	", "").replaceAll("\n", "").trim();
                if (contents2.isNotEmpty && !contents2.contains("영상출처")) {
                  contents.add(
                    ArticleContent(isPicture: false, contents: contents2),
                  );
                }
              } else {
                String imageUrl = image.attributes["src"] ?? "";
                String imageDescription = image.attributes["alt"] ?? "";
                contents.add(
                  ArticleContent(
                    isPicture: true,
                    isOriginal: true,
                    contents: imageUrl,
                  ),
                );
                contents.add(
                  ArticleContent(isPicture: false, contents: imageDescription),
                );
              }
            }
          }

          target = target.copyWith(
            key: (int.parse(newsKey) + index).toString(),
            board_name: Define.BOARD_GAME_NEWS,
            profile_key: "00000000000000000",
            profile_name: "게임뉴스봇",
            contents: contents,
          );

          Article? isExist = duplicateList.firstWhereOrNull(
            (i) => i.title == target.title,
          );
          if (isExist != null) {
            continue;
          }
          addNewsArticleList.add(target);
          index++;
        }
        break;
      case 401:
        break;
      default:
        break;
    }

    // 이미지 처리 전에 불필요한 내용 제거
    for (int i = 0; i < addNewsArticleList.length; i++) {
      Article row = addNewsArticleList[i];
      List<ArticleContent> filteredContents = [];

      for (int j = 0; j < row.contents.length; j++) {
        if (j > 0 && row.contents[j].isPicture) {
          // 이미지인 경우 이전 항목과 현재 항목을 건너뛰기
          continue;
        }
        if (j < row.contents.length - 1 && row.contents[j + 1].isPicture) {
          // 다음 항목이 이미지인 경우 현재 항목을 건너뛰기
          continue;
        }
        filteredContents.add(row.contents[j]);
      }

      addNewsArticleList[i] = row.copyWith(contents: filteredContents);
    }

    for (int j = 0; j < addNewsArticleList.length; j++) {
      Utils.showSnackBar(
        context,
        SnackType.info,
        "${"process_end".tr} : ${"game_news_board".tr}${((j / addNewsArticleList.length) * 100).round()}%",
      );
      Article row = addNewsArticleList[j];
      List<ArticleContent> updatedContents = [];

      for (int i = 0; i < row.contents.length; i++) {
        if (row.contents[i].isPicture && row.contents[i].isOriginal != null) {
          String myImageUrl = await App.uploadImageToStorage(
            row.contents[i].contents,
          );
          if (myImageUrl.isNotEmpty) {
            updatedContents.add(
              ArticleContent(
                isPicture: true,
                isOriginal: false,
                contents: myImageUrl,
              ),
            );
          } else {
            updatedContents.add(row.contents[i]);
          }
          // if (!Utils.isValidNilEmptyStr(row.thumbnail)) {
          //   File thumbnailFile = await App.compressImageFromURL(myImageUrl);
          //   row.thumbnail = await Utils.uploadFileToStorage(
          //       XFile(thumbnailFile.path),
          //       "_thumbnail_" + row.contents[i].contents);
          // }
        } else {
          updatedContents.add(row.contents[i]);
        }
      }

      row = row.copyWith(contents: updatedContents);
      await App.createArticle(row);
    }

    if (context.mounted) {
      Utils.showSnackBar(
        context,
        SnackType.info,
        "${"process_end".tr} : ${"game_news_board".tr}",
      );
    }
  }

  static Future<void> getITNewsList(BuildContext context) async {
    var logger = Logger();

    Utils.showSnackBar(
      context,
      SnackType.info,
      "${"process_start".tr} : ${"it_news_board".tr}",
    );

    List<Article> duplicateList = await App.getArticleList(
      Arrays.getBoardInfoByIndex(Define.INDEX_BOARD_IT_NEWS_PAGE),
      "",
      Define.DEFAULT_BOARD_GET_LENGTH,
    );

    List<Article> addNews = [];

    final response = await get(
      Uri.parse("https://www.cwn.kr/news/articleList.html?view_type=sm"),
    );

    switch (response.statusCode) {
      case 200:
        dom.Document document = parse(response.bodyBytes);
        dom.Element? element = document.querySelector("#section-list");
        if (element == null) {
          logger.w("list_news == null");
          break;
        }

        List<dom.Element> elementList = element.querySelectorAll(".view-cont");

        String newsKey = Utils.getDateTimeKey();
        int index = 0;
        for (dom.Element row1 in elementList.reversed.toList()) {
          Article target = const Article(
            key: "",
            board_name: "",
            profile_key: "",
            profile_name: "",
            count_view: 0,
            count_like: 0,
            count_unlike: 0,
            count_comments: 0,
            title: "",
            contents: [],
            created_at: "",
            is_notice: false,
          );

          String link = row1.querySelector("a")!.attributes["href"] ?? "";

          final response1 = await get(Uri.parse("https://www.cwn.kr/$link"));

          if (response1.statusCode != 200) {
            logger.w("element == null");
            break;
          }
          dom.Document document1 = parse(response1.bodyBytes);
          target = target.copyWith(
            title: document1.querySelector(".heading")!.text,
          );

          dom.Element? contents = document1.querySelector(
            "#article-view-content-div",
          );

          List<ArticleContent> articleContents = [];
          dom.Element? imageElement = contents!.querySelector("img");
          if (imageElement != null) {
            String titleImage = imageElement.attributes["src"] ?? "";
            articleContents.add(
              ArticleContent(
                isPicture: true,
                isOriginal: true,
                contents: titleImage,
              ),
            );
          }

          List<dom.Element> elementList1 = contents.querySelectorAll("p");
          for (dom.Element row2 in elementList1) {
            articleContents.add(
              ArticleContent(
                isPicture: false,
                isOriginal: false,
                contents: row2.text,
              ),
            );
          }

          target = target.copyWith(
            key: (int.parse(newsKey) + index).toString(),
            board_name: Define.BOARD_IT_NEWS,
            profile_key: "00000000000000000",
            profile_name: "IT뉴스봇",
            contents: articleContents,
          );

          Article? isExist = duplicateList.firstWhereOrNull(
            (i) => i.title == target.title,
          );
          if (isExist != null) {
            continue;
          }
          addNews.add(target);
          index++;
        }
        break;
      case 401:
        break;
      default:
        break;
    }

    for (int j = 0; j < addNews.length; j++) {
      Utils.showSnackBar(
        context,
        SnackType.info,
        "${"process_end".tr} : ${"it_news_board".tr}${((j / addNews.length) * 100).round()}%",
      );
      Article row = addNews[j];
      List<ArticleContent> updatedContents = [];

      for (int i = 0; i < row.contents.length; i++) {
        if (row.contents[i].isPicture && row.contents[i].isOriginal != null) {
          String myImageUrl = await App.uploadImageToStorage(
            row.contents[i].contents,
          );
          if (myImageUrl.isNotEmpty) {
            updatedContents.add(
              ArticleContent(
                isPicture: true,
                isOriginal: false,
                contents: myImageUrl,
              ),
            );
          } else {
            updatedContents.add(row.contents[i]);
          }
          // if (!Utils.isValidNilEmptyStr(row.thumbnail)) {
          //   File thumbnailFile = await App.compressImageFromURL(myImageUrl);
          //   row.thumbnail = await Utils.uploadFileToStorage(
          //       XFile(thumbnailFile.path),
          //       "_thumbnail_" + row.contents[i].contents);
          // }
        } else {
          updatedContents.add(row.contents[i]);
        }
      }

      row = row.copyWith(contents: updatedContents);
      await App.createArticle(row);
    }

    Utils.showSnackBar(
      context,
      SnackType.info,
      "${"process_end".tr} : ${"it_news_board".tr}",
    );

    logger.i("getITNewList success:${addNews.length}");
  }

  static Future<void> getITWorldNewsList(BuildContext context) async {
    var logger = Logger();

    Utils.showSnackBar(
      context,
      SnackType.info,
      "${"process_start".tr} : ${"it_news_board".tr}",
    );

    List<Article> duplicateList = await App.getArticleList(
      Arrays.getBoardInfoByIndex(Define.INDEX_BOARD_IT_NEWS_PAGE),
      "",
      Define.DEFAULT_BOARD_GET_LENGTH,
    );

    List<Article> addNews = [];

    final response = await get(Uri.parse("https://www.itworld.co.kr/news/"));

    switch (response.statusCode) {
      case 200:
        logger.w("200");

        dom.Document document = parse(response.bodyBytes);
        dom.Element? element = document.querySelector(".section-content");
        if (element == null) {
          logger.w("list_news == null");
          break;
        }
        logger.w("111");

        List<dom.Element> elementList = element.querySelectorAll(
          ".card-article",
        );

        String newsKey = Utils.getDateTimeKey();
        int index = 0;
        for (dom.Element row1 in elementList.reversed.toList()) {
          Article target = const Article(
            key: "",
            board_name: "",
            profile_key: "",
            profile_name: "",
            count_view: 0,
            count_like: 0,
            count_unlike: 0,
            count_comments: 0,
            title: "",
            contents: [],
            created_at: "",
            is_notice: false,
          );

          String link = row1.querySelector("a")!.attributes["href"] ?? "";

          final response1 = await get(
            Uri.parse("https://www.itworld.co.kr/$link"),
          );
          logger.w("https://www.itworld.co.kr/$link");

          if (response1.statusCode != 200) {
            logger.w("element == null");
            break;
          }
          dom.Document document1 = parse(response1.bodyBytes);
          target = target.copyWith(
            title: document1.querySelector(".node-title")!.text,
          );
          logger.w(target.title);

          dom.Element? contents = document1.querySelector(".node-body");

          List<String> list = Utils.multiSplit(contents!.innerHtml, [
            "<br>",
            "\n",
            "&nbsp;",
          ]);

          List<ArticleContent> articleContents = [];
          for (String row2 in list) {
            if (Utils.containFromArray(row2, ["<figure", "<img"])) {
              var document3 = parse(row2);
              dom.Element? link = document3.querySelector('img');
              String imageLink = link != null ? link.attributes['src']! : '';
              logger.i("https://www.itworld.co.kr$imageLink");
              articleContents.add(
                ArticleContent(
                  isPicture: true,
                  isOriginal: true,
                  contents: "https://www.itworld.co.kr$imageLink",
                ),
              );
              continue;
            }

            ArticleContent articleContent = ArticleContent(
              isPicture: false,
              isOriginal: false,
              contents: "",
            );
            String contents =
                row2
                    .replaceAll("&nbsp;", "")
                    .replaceAll(""", "")
                .replaceAll(""", "")
                    // .replaceAll("<li>", "")
                    // .replaceAll("</li>", "")
                    // .replaceAll("</h2>", "")
                    // .replaceAll("<strong>", "")
                    // .replaceAll("</strong>", "")
                    // .replaceAll("<ul>", "")
                    // .replaceAll("</ul>", "")
                    .trim();
            if (contents.isEmpty) {
              continue;
            }
            articleContent = articleContent.copyWith(
              isBold: Utils.containFromArray(row2, ["</strong>", "</h2>"]),
              contents: contents,
            );
            logger.i(contents);
            articleContents.add(articleContent);
          }

          // dom.Element? image_element = contents!.querySelector("img");
          // if (image_element != null) {
          //   String title_image = image_element.attributes["src"] ?? "";
          //   target.contents.add(ArticleContent(true, true, title_image));
          // }

          // List<dom.Element> elementList1 = contents!.querySelectorAll("p");
          // for (dom.Element row2 in elementList1) {
          //   target.contents.add(ArticleContent(false, false, row2.text));
          // }
          //
          target = target.copyWith(
            key: (int.parse(newsKey) + index).toString(),
            board_name: Define.BOARD_IT_NEWS,
            profile_key: "00000000000000000",
            profile_name: "IT뉴스봇",
            contents: articleContents,
          );
          //
          Article? isExist = duplicateList.firstWhereOrNull(
            (i) => i.title == target.title,
          );
          if (isExist != null) {
            continue;
          }
          addNews.add(target);
          index++;
        }
        break;
      case 401:
        break;
      default:
        break;
    }

    // for (int j = 0; j < addNews.length; j++) {
    // logger.i(addNews[j].toString());
    // }

    for (int j = 0; j < addNews.length; j++) {
      Utils.showSnackBar(
        context,
        SnackType.info,
        "${"process_end".tr} : ${"it_news_board".tr}${((j / addNews.length) * 100).round()}%",
      );
      Article row = addNews[j];
      List<ArticleContent> updatedContents = [];

      for (int i = 0; i < row.contents.length; i++) {
        if (row.contents[i].isPicture && row.contents[i].isOriginal != null) {
          String myImageUrl = await App.uploadImageToStorage(
            row.contents[i].contents,
          );
          if (myImageUrl.isNotEmpty) {
            updatedContents.add(
              ArticleContent(
                isPicture: true,
                isOriginal: false,
                contents: myImageUrl,
              ),
            );
          } else {
            updatedContents.add(row.contents[i]);
          }
          // if (!Utils.isValidNilEmptyStr(row.thumbnail)) {
          //   File thumbnailFile = await App.compressImageFromURL(myImageUrl);
          //   row.thumbnail = await Utils.uploadFileToStorage(
          //       XFile(thumbnailFile.path),
          //       "_thumbnail_" + row.contents[i].contents);
          // }
        } else {
          updatedContents.add(row.contents[i]);
        }
      }

      row = row.copyWith(contents: updatedContents);
      await App.createArticle(row);
    }

    Utils.showSnackBar(
      context,
      SnackType.info,
      "${"process_end".tr} : ${"it_news_board".tr}",
    );

    logger.i("getITNewList success:${addNews.length}");
  }

  // static Future<File> compressImage(File f) async {
  //   ReceivePort receivePort = ReceivePort();
  //
  //   await Isolate.spawn(getCompressedImage, receivePort.sendPort);
  //   SendPort sendPort = await receivePort.first;
  //
  //   ReceivePort receivePort2 = ReceivePort();
  //
  //   sendPort.send([
  //     f.path,
  //     f.uri.pathSegments.last,
  //     (await getTemporaryDirectory()).path,
  //     receivePort2.sendPort,
  //   ]);
  //
  //   var msg = await receivePort2.first;
  //
  //   return new File(msg);
  // }
  //
  // static Future<void> getCompressedImage(SendPort sendPort) async {
  //   ReceivePort receivePort = ReceivePort();
  //
  //   sendPort.send(receivePort.sendPort);
  //   List msg = (await receivePort.first) as List;
  //
  //   String srcPath = msg[0];
  //   String name = msg[1];
  //   String destDirPath = msg[2];
  //   SendPort replyPort = msg[3];
  //
  //   var image = decodeImage(await File(srcPath).readAsBytes());
  //
  //   if (image!.width > 500 || image.height > 500) {
  //     image = copyResize(image, width: 500);
  //   }
  //
  //   File destFile = new File(destDirPath + '/' + name);
  //   await destFile.writeAsBytes(encodeJpg(image, quality: 30));
  //
  //   replyPort.send(destFile.path);
  // }

  static bool containFromArray(String target, List<String> list) {
    bool isExist = false;
    for (String s in list) {
      if (target.toLowerCase().contains(s.toLowerCase())) {
        isExist = true;
      }
    }
    return isExist;
  }
}
