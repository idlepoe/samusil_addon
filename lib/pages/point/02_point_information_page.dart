import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../define/define.dart';

class PointInformationPage extends StatelessWidget {
  const PointInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("point".tr,
            style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR)),
        backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
        iconTheme: const IconThemeData(
          color: Define.APP_BAR_TITLE_TEXT_COLOR,
        ),
        elevation: 0,
      ),
      body: Center(
          child: SingleChildScrollView(
            child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Text("${"wish".tr} : ${Define.POINT_WISH.toStringAsFixed(0)}P (${"point_streak".tr}+1P)",style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("${"article_write".tr} : ${Define.POINT_WRITE_ARTICLE.toStringAsFixed(0)}P",style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("${"article_comment".tr} : ${Define.POINT_WRITE_COMMENT.toStringAsFixed(0)}P",style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("${"like_receive".tr} : ${Define.POINT_RECEIVE_LIKE.toStringAsFixed(0)}P",style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("${"article_like".tr} : ${Define.POINT_LIKE.toStringAsFixed(0)}P",style: const TextStyle(fontSize: 20)),
        ],
      ),
          )),
    );
  }
}
