import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:samusil_addon/models/article_contents.dart';

import '../../define/define.dart';
import '../../utils/util.dart';

class DetailPageViewPage extends StatefulWidget {
  final List<ArticleContent> list;
  final int index;

  const DetailPageViewPage({Key? key, required this.list, required this.index})
      : super(key: key);

  @override
  State<DetailPageViewPage> createState() => _DetailPageViewPageState();
}

class MouseDraggableScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class _DetailPageViewPageState extends State<DetailPageViewPage> {
  var logger = Logger();
  final PageController _controller = PageController();
  List<ArticleContent> _list = [];
  int _index = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    setState(() {
      _list = widget.list;
      _index = widget.index;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      logger.i(_controller.page);
      _controller.jumpToPage(_index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: List.generate(_list.length, (index) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: AutoSizeText(
              "image".tr + index.toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR),
            ),
            backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
            iconTheme: const IconThemeData(
              color: Define.APP_BAR_TITLE_TEXT_COLOR,
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    List<String> saveList = [];
                    saveList.add(_list[index].contents);
                    bool result = await Utils.saveNetworkImage(saveList);
                    if (mounted && result) {
                      // Utils.showSnackBar(
                      //     context, SnackType.success, "success_image_save".tr);
                      Fluttertoast.showToast(msg: "success_image_save".tr);
                    } else {
                      Fluttertoast.showToast(msg: "error_image_save".tr);
                    }
                  },
                  icon: const Icon(Icons.save_alt))
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              Navigator.pop(context);
            },
            child: Center(
              child: ExtendedImage.network(
                _list[index].contents,
                fit: BoxFit.contain,
                mode: ExtendedImageMode.gesture,
                initEditorConfigHandler: (state) {
                  return EditorConfig(
                    maxScale: 8.0,
                    cropRectPadding: const EdgeInsets.all(20.0),
                    hitTestSize: 20.0,
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
