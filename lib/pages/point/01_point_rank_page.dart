import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../define/define.dart';
import '../../models/profile.dart';
import '../../utils/app.dart';
import '../../utils/util.dart';

class PointRankPage extends StatefulWidget {
  const PointRankPage({super.key});

  @override
  State<PointRankPage> createState() => _PointRankPageState();
}

class _PointRankPageState extends State<PointRankPage> {
  var logger = Logger();
  final dataKey = GlobalKey();
  Profile _profile = Profile.init();
  List<Profile> _list = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _profile = await App.getProfile();
    _list = await App.getProfileList();

    logger.i(_profile.toString());
    setState(() {});

    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (dataKey.currentContext != null) {
        Scrollable.ensureVisible(
          dataKey.currentContext!,
          alignment: 0.5,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("point_rank".tr,
            style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR)),
        backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
        iconTheme: const IconThemeData(
          color: Define.APP_BAR_TITLE_TEXT_COLOR,
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Scrollable.ensureVisible(
                  dataKey.currentContext!,
                  alignment: 0.5,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
              icon: const Icon(Icons.perm_contact_calendar_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            children: List.generate(_list.length, (index) {
          bool me = _list[index].key == _profile.key;
          return ListTile(
            key: me ? dataKey : null,
            tileColor: me ? Colors.teal : null,
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text((index + 1).toString(),
                    style: TextStyle(color: me ? Colors.white : Colors.black)),
              ],
            ),
            title: Row(
              children: [
                if (Utils.isValidNilEmptyStr(_list[index].profile_image_url))
                  CachedNetworkImage(
                    imageUrl: _list[index].profile_image_url,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      backgroundImage: AssetImage('assets/anon_icon.jpg'),
                    ),
                  ),
                if (!Utils.isValidNilEmptyStr(_list[index].profile_image_url))
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/anon_icon.jpg'),
                  ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_list[index].name,
                        style:
                            TextStyle(color: me ? Colors.white : Colors.black)),
                    Text(
                        Utils.toConvertFireDateToCommentTime(_list[index].key,
                            bYear: true),
                        style: TextStyle(
                            color: me ? Colors.white : Colors.grey,
                            fontSize: 12))
                  ],
                ),
              ],
            ),
            trailing: Text(
                "${(_list[index].point).round()}P",
                style: TextStyle(color: me ? Colors.white : Colors.black)),
          );
        })),
      ),
    );
  }
}
