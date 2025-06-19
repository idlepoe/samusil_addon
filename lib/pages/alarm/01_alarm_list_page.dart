import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:samusil_addon/define/arrays.dart';
import 'package:samusil_addon/models/board_info.dart';

import '../../define/define.dart';
import '../../models/article.dart';
import '../../models/profile.dart';
import '../../utils/app.dart';
import '../../main.dart';

class AlarmListPage extends StatefulWidget {
  const AlarmListPage({super.key});

  @override
  State<AlarmListPage> createState() => _AlarmListPageState();
}

class _AlarmListPageState extends State<AlarmListPage> {
  Profile _profile = Profile.init();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await getAlarmList();
  }

  Future<void> getAlarmList() async {
    _profile = await App.getProfile();
    await App.readAlarm(_profile);
    if(mounted){
      // Utils.showSnackBar(context,SnackType.success,"success_read_alarm".tr);
      Fluttertoast.showToast(msg:"success_read_alarm".tr );
    }
    setState(() {});
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
          "alarm".tr,
          style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await App.deleteAlarm(_profile);
                _profile = _profile.copyWith(alarms: []);
                setState(() {});
              },
              icon: const Icon(LineIcons.trash))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getAlarmList();
        },
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              children: [
                // Container(
                //   height: 80,
                //   width: double.infinity,
                //   color: Colors.teal,
                //   child: Center(
                //     child: Text(
                //       "ad_banner",
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ),
                // ),
                Column(
                  children:
                      List.generate((_profile.alarms).length, (index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                              "'${_profile.alarms[index].my_contents}' ${"new_comment".tr}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_profile.alarms[index].target_contents),
                              Text(_profile.alarms[index].target_info),
                            ],
                          ),
                          onTap: () async {
                            Article targetArticle = await App.getArticle(
                                _profile.alarms[index].target_article_key);
                            if (mounted) {
                              // await Navigator.of(context)
                              //     .push(SwipeablePageRoute(
                              //   builder: (BuildContext context) =>
                              //       ArticleDetailPage(
                              //     article: targetArticle,
                              //     boardInfo: targetBoard,isFromDash: false,
                              //   ),
                              // ));

                              targetArticle = targetArticle.copyWith(
                                count_view: await App.articleCountViewUp(
                                    targetArticle.key),
                              );

                              if(!mounted)return;

                              await GoRouter.of(context).push("/detail/${targetArticle.key}");

                              // Navigator.of(context).pushNamed("/article", arguments: {"key":_list[index].key});


                            }
                          },
                        ),
                        Define.APP_DIVIDER,
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
