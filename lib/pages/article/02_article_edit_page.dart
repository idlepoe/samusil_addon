import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:logger/logger.dart';
import 'package:samusil_addon/components/showSimpleDialog.dart';
import 'package:samusil_addon/models/article_contents.dart';

import '../../components/appButton.dart';
import '../../define/define.dart';
import '../../models/article.dart';
import '../../models/board_info.dart';
import '../../models/profile.dart';
import '../../utils/app.dart';
import '../../utils/util.dart';

class ArticleEditPage extends StatefulWidget {
  final BoardInfo boardInfo;

  const ArticleEditPage({super.key, required this.boardInfo});

  @override
  State<ArticleEditPage> createState() => _ArticleEditPageState();
}

class Contents {
  bool isPicture;
  String contents;
  ImageProvider<Object>? picture;
  XFile? file;
  TextEditingController? textEditingController;
  FocusNode? focusNode;

  Contents(
    this.isPicture,
    this.contents,
    this.picture,
    this.file,
    this.textEditingController,
    this.focusNode,
  );
}

class _ArticleEditPageState extends State<ArticleEditPage> {
  var logger = Logger();
  bool isPressed = false;
  BoardInfo _boardInfo = BoardInfo.init();

  final List<Contents> _list = [];

  // picture
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _titleTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    _boardInfo = widget.boardInfo;
    _list.add(
      Contents(false, "", null, null, TextEditingController(), FocusNode()),
    );
    setState(() {});
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          color: Colors.grey,
          shadowColor: Colors.grey,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
        iconTheme: const IconThemeData(
          color: Define.APP_BAR_TITLE_TEXT_COLOR, //change your color here
        ),
        elevation: 0,
        title: Text(
          "${"write".tr} (${_boardInfo.title.tr})",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: AppButton(
              context,
              "write_article".tr,
              onTap: () async {
                await writeArticle();
              },
              pBtnWidth: 0.2,
            ),
          ),
        ],
      ),
      body:
          isPressed
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  TextField(
                    controller: _titleTextEditingController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 15),
                      hintText: "title".tr,
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                  ),
                  Define.APP_DIVIDER,
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        for (int i = _list.length - 1; i > -1; i--) {
                          if (!_list[i].isPicture) {
                            _list[i].focusNode!.requestFocus();
                            break;
                          }
                        }
                      },
                      child: ReorderableListView(
                        proxyDecorator: proxyDecorator,
                        children: List.generate(_list.length, (index) {
                          return ListTile(
                            key: Key('$index'),
                            title:
                                !_list[index].isPicture
                                    ? TextField(
                                      controller:
                                          _list[index].textEditingController,
                                      focusNode: _list[index].focusNode,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintText: "contents".tr,
                                        border: InputBorder.none,
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                    : Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          height: 200,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            image: DecorationImage(
                                              image: _list[index].picture!,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.black
                                                .withOpacity(0.5),
                                            child: IconButton(
                                              onPressed: () {
                                                _list.remove(_list[index]);
                                                setState(() {});
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                          );
                        }),
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            dynamic item = _list.removeAt(oldIndex);
                            _list.insert(newIndex, item);
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.grey),
                          onPressed: () {},
                        ),
                        IconButton(
                          onPressed: () async {
                            _list.add(
                              Contents(
                                false,
                                "",
                                null,
                                null,
                                TextEditingController(),
                                FocusNode(),
                              ),
                            );
                            setState(() {});
                          },
                          icon: const Icon(LineIcons.font),
                        ),
                        IconButton(
                          onPressed: () async {
                            final pickedFileList =
                                await _picker.pickMultiImage();
                            int index = 0;
                            for (XFile pickedFile in pickedFileList) {
                              if (pickedFileList.isNotEmpty) {
                                ImageProvider<Object> image =
                                    await Utils.xFileToImage(pickedFile);
                                logger.i(image);
                                setState(() {
                                  _list.insert(
                                    index,
                                    Contents(
                                      true,
                                      "${Utils.getDateTimeKey()}.${pickedFile.path.split(".").last}",
                                      image,
                                      pickedFile,
                                      null,
                                      null,
                                    ),
                                  );
                                });
                                index++;
                              }
                            }
                          },
                          icon: const Icon(LineIcons.image),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Future<void> writeArticle() async {
    if (_titleTextEditingController.text.isEmpty) {
      await showSimpleDialog(context, "title_input_please".tr);
      return;
    }
    if (isPressed) {
      return;
    }
    setState(() {
      isPressed = true;
    });
    Article updateTarget = const Article(
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
    Profile profile = await App.getProfile();

    String thumbnail = "";
    List<ArticleContent> updateContents = [];
    for (int i = 0; i < _list.length; i++) {
      String contents = "";
      if (_list[i].isPicture) {
        contents = await Utils.uploadImageToStorage(
          _list[i].file,
          folder: 'articles',
          fileName:
              '${Utils.getDateTimeKey()}_${i}_${Utils.getRandomString(4)}.jpg',
        );
        // if (thumbnail.isEmpty) {
        //   File thumbnailFile =
        //       await News.compressImage(File(_list[i].file!.path));
        //   thumbnail = await Utils.uploadImageToStorage(
        //       XFile(thumbnailFile.path),
        //       folder: 'thumbnails',
        //       fileName: 'thumbnail_${Utils.getDateTimeKey()}_${i}.jpg'
        //   );
        // }
      } else {
        contents = _list[i].textEditingController!.text;
        if (contents.isEmpty) {
          continue;
        }
      }
      ArticleContent target = ArticleContent(
        isPicture: _list[i].isPicture,
        contents: contents,
      );
      logger.w(target.toString());
      updateContents.add(target);
    }
    updateTarget = updateTarget.copyWith(
      key: Utils.getDateTimeKey(),
      title: _titleTextEditingController.text,
      board_name: _boardInfo.title,
      contents: updateContents,
      profile_key: profile.key,
      profile_name: profile.name,
      thumbnail: thumbnail,
    );
    await App.createArticle(updateTarget);
    await App.pointUpdate(profile.key, Define.POINT_WRITE_ARTICLE);

    if (mounted) {
      // Utils.showSnackBar(
      //     context, SnackType.success, "success_create_article".tr);
      Fluttertoast.showToast(msg: "success_create_article".tr);
    }

    setState(() {
      isPressed = false;
    });

    if (!mounted) return;
    print("_boardInfo.board_name${_boardInfo.board_name}");
    Navigator.pop(context);
  }
}
