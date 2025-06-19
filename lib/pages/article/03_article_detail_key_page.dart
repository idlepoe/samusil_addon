import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:logger/logger.dart';
import 'package:samusil_addon/components/appButton.dart';
import 'package:samusil_addon/define/enum.dart';
import 'package:samusil_addon/models/article.dart';
import 'package:samusil_addon/models/main_comment.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../define/arrays.dart';
import '../../define/define.dart';
import '../../models/alarm.dart';
import '../../models/board_info.dart';
import '../../models/profile.dart';
import '../../utils/app.dart';
import '../../utils/util.dart';

class ArticleDetailKeyPage extends StatefulWidget {
  final String articleKey;

  const ArticleDetailKeyPage({super.key, required this.articleKey});

  @override
  State<ArticleDetailKeyPage> createState() => _ArticleDetailKeyPageState();
}

class _ArticleDetailKeyPageState extends State<ArticleDetailKeyPage> {
  var logger = Logger();

  String _articleKey = "";
  BoardInfo _boardInfo = BoardInfo.init();
  Article _article = Article.init();
  Profile _profile = Profile.init();
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool _isAlreadyVote = false;
  MainComment? _subComment;

  int _imageCount = 1;

  final bool _isFromDash = true;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _articleKey = widget.articleKey;
    _article = await App.getArticle(_articleKey);
    _boardInfo = Arrays.getBoardInfo(_article.board_index);
    _profile = await App.getProfile();
    _isAlreadyVote = await Utils.checkAlreadyVote(_article.key);
    _article.comments.sort((a, b) =>
        (a.parents_key.isNotEmpty ? a.parents_key : a.key)
            .compareTo((b.parents_key.isNotEmpty ? b.parents_key : b.key)));

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
          iconTheme: const IconThemeData(
            color: Define.APP_BAR_TITLE_TEXT_COLOR,
          ),
          elevation: 0,
          title: Text(
            _boardInfo.title.tr,
            style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Share.share(
                      'https://nippon-life.web.app/#/detail/$_articleKey',
                      subject: _article.title);
                },
                icon: const Icon(Icons.share))
          ]),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_article.title, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("👤${_article.profile_name}"),
                      Text(
                        Utils.toConvertFireDateToCommentTime(
                            _article.created_at,
                            bYear: true),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "${"count_view".tr} ${_article.count_view} | ${"comment".tr} ${_article.comments.length}",
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: List.generate(_article.contents.length, (index) {
                if (_article.contents[index].isPicture) {
                  _imageCount++;
                }
                return ListTile(
                  title: _article.contents[index].isPicture
                      ? InkWell(
                          onLongPress: () async {
                            // showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return AlertDialog(
                            //         content: Column(
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: [
                            //             ListTile(
                            //               title: Text("image_download".tr),
                            //               onTap: () async {
                            //                 Navigator.pop(context);
                            //                 bool result =
                            //                     await Utils.saveNetworkImage([
                            //                   _article
                            //                       .contents[index].contents
                            //                 ]);
                            //                 if (mounted && result) {
                            //                   // Utils.showSnackBar(
                            //                   //     context,
                            //                   //     SnackType.success,
                            //                   //     "success_image_save".tr);
                            //                   Fluttertoast.showToast(
                            //                       msg: "success_image_save"
                            //                           .tr);
                            //                 }else{
                            //                   Fluttertoast.showToast(
                            //                       msg: "error_image_save"
                            //                           .tr);
                            //                 }
                            //               },
                            //             ),
                            //             ListTile(
                            //               title: Text("image_view".tr),
                            //               onTap: () {
                            //                 Navigator.pop(context);
                            //                 List<ArticleContent> imageList =
                            //                     [];
                            //                 for (ArticleContent row
                            //                     in _article.contents) {
                            //                   if (row.isPicture) {
                            //                     imageList.add(row);
                            //                   }
                            //                 }
                            //                 Navigator.of(context)
                            //                     .push(SwipeablePageRoute(
                            //                   canOnlySwipeFromEdge: true,
                            //                   builder:
                            //                       (BuildContext context) =>
                            //                           DetailPageViewPage(
                            //                               list: imageList,
                            //                               index: index),
                            //                 ));
                            //               },
                            //             ),
                            //           ],
                            //         ),
                            //       );
                            //     });

                            bool result = await Utils.saveNetworkImage(
                                [_article.contents[index].contents]);
                            if (mounted && result) {
                              Fluttertoast.showToast(
                                  msg: "success_image_save".tr);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "error_image_save".tr);
                            }
                          },
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ExtendedImage.network(
                                        _article.contents[index].contents,
                                        fit: BoxFit.contain,
                                        //enableLoadState: false,
                                        mode: ExtendedImageMode.gesture,
                                        initGestureConfigHandler: (state) {
                                          return GestureConfig(
                                            minScale: 0.9,
                                            animationMinScale: 0.7,
                                            maxScale: 3.0,
                                            animationMaxScale: 3.5,
                                            speed: 1.0,
                                            inertialSpeed: 100.0,
                                            initialScale: 1.0,
                                            inPageView: false,
                                            initialAlignment:
                                                InitialAlignment.center,
                                          );
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                          child: CachedNetworkImage(
                            fit: BoxFit.fitWidth,
                            imageUrl: _article.contents[index].contents,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Container(
                                    child: Center(
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress))),
                            errorWidget: (context, url, error) {
                              return const Icon(Icons.error);
                            },
                          ),
                        )
                      : Html(
                          data: _article.contents[index].contents,
                          onLinkTap: (url, __, ___) async {
                            await canLaunchUrlString(url!)
                                ? await launchUrlString(url)
                                : Fluttertoast.showToast(msg: "error_link".tr);
                          },
                        ),
                );
              }),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton.icon(
                  icon: const Icon(Icons.thumb_up),
                  label:
                      Text("${"like".tr} : ${_article.count_like}"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: _isPressed || _isAlreadyVote
                      ? null
                      : () async {
                          setState(() {
                            _isPressed = true;
                          });
                          _article = _article.copyWith(
                            count_like: await App.articleCountLikeUp(_article.key),
                          );
                          await Utils.setAlreadyVote(_article.key);
                          _isAlreadyVote = true;
                          await App.pointUpdate(
                              _article.profile_key, Define.POINT_RECEIVE_LIKE);
                          await App.pointUpdate(
                              _profile.key, Define.POINT_LIKE);
                          if (mounted) {
                            // Utils.showSnackBar(
                            //   context,
                            //   SnackType.success,
                            //   "success_article_like".tr,
                            // );
                            Fluttertoast.showToast(
                                msg: "success_article_like".tr);
                          }
                          setState(() {
                            _isPressed = false;
                          });
                        }),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                  icon: const Icon(Icons.thumb_down),
                  label: Text(
                      "${"unlike".tr} : ${_article.count_unlike}"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade500),
                  onPressed: _isPressed || _isAlreadyVote
                      ? null
                      : () async {
                          setState(() {
                            _isPressed = true;
                          });
                          _article = _article.copyWith(
                            count_unlike: await App.articleCountUnLikeUp(_article.key),
                          );
                          await Utils.setAlreadyVote(_article.key);
                          _isAlreadyVote = true;
                          if (mounted) {
                            // Utils.showSnackBar(
                            //   context,
                            //   SnackType.success,
                            //   "success_article_unlike".tr,
                            // );
                            Fluttertoast.showToast(
                                msg: "success_article_unlike".tr);
                          }
                          setState(() {
                            _isPressed = false;
                          });
                        }),
            ]),
            const SizedBox(height: 20),
            if (_article.profile_key == _profile.key ||
                _profile.key == Define.MASTER_USER_KEY)
              Column(
                children: [
                  AppButton(context, "article_delete".tr,
                      textColor: Colors.red,
                      backgroundColor: Colors.white,
                      isBold: true,
                      pBtnWidth: 0.65, onTap: () async {
                    bool isDeleted =
                        await _showArticleDeleteDialog(context, _article);
                    if (mounted && isDeleted) {
                      Navigator.pop(context, true);
                    }
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            if (_isFromDash)
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        logger.i(Arrays.getBoardInfo(_boardInfo.index));
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   SwipeablePageRoute(
                        //       builder: (BuildContext context) =>
                        //           ArticleListPage(
                        //               Arrays.getBoardInfo(_boardInfo.index))),
                        //   (route) => false,
                        // );
                        context.go('/list/${_boardInfo.index}');
                      },
                      child: Text(_boardInfo.title.tr + "board_to_move".tr)),
                ],
              ),
            Container(
              height: 40,
              padding: const EdgeInsets.only(left: 10, right: 10),
              width: double.infinity,
              color: Colors.grey.shade300,
              alignment: Alignment.centerLeft,
              child: Row(children: [
                Text("${"comment".tr} ${_article.comments.length}"),
                IconButton(
                    onPressed: () async {
                      List<MainComment> comments =
                          await App.getComments(_article.key);
                      comments.sort((a, b) =>
                          (a.parents_key.isNotEmpty ? a.parents_key : a.key)
                              .compareTo((b.parents_key.isNotEmpty
                                  ? b.parents_key
                                  : b.key)));
                      _article = _article.copyWith(comments: comments);
                      if (mounted) {
                        // Utils.showSnackBar(
                        //   context,
                        //   SnackType.success,
                        //   "success_get_comment".tr,
                        // );
                        Fluttertoast.showToast(msg: "success_get_comment".tr);
                      }
                    },
                    icon: const Icon(Icons.refresh))
              ]),
            ),
            Column(
              children: List.generate(_article.comments.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: (_article.comments[index].is_sub ? 15 : 0)),
                  child: ListTile(
                    onTap: () {
                      _subComment = _article.comments[index];
                      _commentFocusNode.requestFocus();
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("👤${_article.comments[index].profile_name}",
                                style: const TextStyle(fontSize: 13)),
                            if (_article.comments[index].profile_key ==
                                _profile.key)
                              IconButton(
                                icon: const Icon(LineIcons.trash),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  _showDeleteDialog(
                                      context, _article.comments[index]);
                                },
                              )
                          ],
                        ),
                        Text(_article.comments[index].contents),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                    subtitle: Text(Utils.toConvertFireDateToCommentTime(
                        _article.comments[index].created_at,
                        bYear: true)),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade300, width: 0.5),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: Define.BOTTOM_SHEET_HEIGHT - 15)
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.5, color: Define.APP_MAIN_COLOR),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_subComment != null)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("👤${_subComment!.profile_name}"),
                          Text(
                            "to_comment".tr,
                            style: TextStyle(color: Colors.grey.shade500),
                          )
                        ],
                      ),
                      IconButton(
                          padding: const EdgeInsets.only(top: 2, bottom: 2),
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            _subComment = null;
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: Colors.grey.shade400,
                          ))
                    ],
                  ),
                  Define.APP_DIVIDER,
                ],
              ),
            TextField(
              controller: _commentController,
              focusNode: _commentFocusNode,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (text) {
                if (mounted) {
                  setState(() {});
                }
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(200),
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "comment_input".tr,
                suffixIcon: Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    child: AppButton(context, "write_comment".tr,
                        disable: _commentController.text.isEmpty || _isPressed,
                        pBtnWidth: 0.2, onTap: () async {
                      setState(() {
                        _isPressed = true;
                      });

                      String commentKey = Utils.getDateTimeKey();

                      List<MainComment> afterList = await App.createComment(
                        _article,
                        MainComment(
                          key: commentKey,
                          contents: _commentController.text,
                          profile_key: _profile.key,
                          profile_name: _profile.name,
                          created_at: commentKey,
                          is_sub: _subComment != null,
                          parents_key: _subComment != null ? _subComment!.key : "",
                        ),
                      );
                      afterList.sort((a, b) =>
                          (a.parents_key.isNotEmpty ? a.parents_key : a.key)
                              .compareTo((b.parents_key.isNotEmpty
                                  ? b.parents_key
                                  : b.key)));
                      _article = _article.copyWith(comments: afterList);

                      await App.pointUpdate(_profile.key, 1);

                      if (_subComment == null) {
                        Alarm alarm = Alarm(
                          key: commentKey,
                          my_contents: _commentController.text,
                          is_read: false,
                          target_article_key: _article.key,
                          target_contents: _article.title,
                          target_info:
                              "${_boardInfo.title} | ${_article.profile_name} | ${Utils.toConvertFireDateToCommentTime(_article.created_at)}",
                          target_key_type: AlarmTargetKeyType.article.index,
                        );
                        await App.createAlarm(_article.profile_key, alarm);
                      }

                      _commentController.clear();
                      _commentFocusNode.unfocus();
                      _subComment = null;

                      if (mounted) {
                        // Utils.showSnackBar(context, SnackType.success,
                        //     "success_create_comment".tr);
                        Fluttertoast.showToast(
                            msg: "success_create_comment".tr);
                      }

                      setState(() {
                        _isPressed = false;
                      });
                    })),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showDeleteDialog(
      BuildContext context, MainComment comment) async {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: Text('title_delete_confirm'.tr),
          content: Text('msg_delete_confirm'.tr),
          actions: [
            CupertinoDialogAction(
              onPressed: () async {
                List<MainComment> afterList =
                    await App.deleteComment(_article.key, comment);
                afterList.sort((a, b) => (a.parents_key.isNotEmpty
                        ? a.parents_key
                        : a.key)
                    .compareTo(
                        (b.parents_key.isNotEmpty ? b.parents_key : b.key)));
                _article = _article.copyWith(comments: afterList);
                if (mounted) {
                  // Utils.showSnackBar(
                  //     context, SnackType.success, "success_delete_comment".tr);
                  Fluttertoast.showToast(msg: "success_delete_comment".tr);
                }
                setState(() {});
                Navigator.of(context).pop();
              },
              isDefaultAction: true,
              isDestructiveAction: true,
              child: Text("yes".tr),
            ),
            // The "No" button
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              isDefaultAction: false,
              isDestructiveAction: false,
              child: Text("no".tr),
            )
          ],
        );
      },
    );
  }

  Future<bool> _showArticleDeleteDialog(
      BuildContext context, Article article) async {
    bool result = false;
    await showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: Text('title_delete_confirm'.tr),
          content: Text('msg_delete_confirm'.tr),
          actions: [
            CupertinoDialogAction(
              onPressed: () async {
                await App.deleteArticle(_article);
                result = true;
                if (mounted) {
                  // Utils.showSnackBar(
                  //     context, SnackType.success, "success_delete_article".tr);
                  Fluttertoast.showToast(msg: "success_delete_article".tr);
                }
                Navigator.of(context).pop();
              },
              isDefaultAction: true,
              isDestructiveAction: true,
              child: Text("yes".tr),
            ),
            // The "No" button
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              isDefaultAction: false,
              isDestructiveAction: false,
              child: Text("no".tr),
            )
          ],
        );
      },
    );
    return result;
  }
}
