import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:samusil_addon/components/appButton.dart';

import '../../define/arrays.dart';
import '../../define/define.dart';
import '../../models/profile.dart';
import '../../models/wish.dart';
import '../../utils/app.dart';
import '../../utils/util.dart';

class WishPage extends StatefulWidget {
  const WishPage({super.key});

  @override
  State<WishPage> createState() => _WishPageState();
}

class _WishPageState extends State<WishPage> {
  var logger = Logger();

  Profile _profile = Profile.init();
  List<Wish> _list = [];

  bool _alreadyWished = true;
  bool isPressed = false;

  // wish
  final TextEditingController _commentTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await App.checkUser();
    _profile = await App.getProfile();
    _alreadyWished = await Utils.getAlreadyWish();
    _list = await App.getWishList();
    if (mounted) {
      // Utils.showSnackBar(
      //     context, SnackType.success, "success_get_wish_list".tr);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
        iconTheme: const IconThemeData(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        elevation: 0,
        title: Text(
          Arrays.getBoardInfo(Define.INDEX_WISH_PAGE).title.tr,
          style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _list = await App.getWishList();
          setState(() {});
        },
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                        backgroundImage: AssetImage("assets/wish_of_stone.jpg"),
                        radius: 150),
                    Center(
                      child: Column(
                        children: [
                          AutoSizeText("wish".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  backgroundColor: Colors.black.withOpacity(0.3)),
                              maxLines: 1),
                          const SizedBox(height: 5),
                          AutoSizeText(Utils.getStringToday(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  backgroundColor: Colors.black.withOpacity(0.3)),
                              maxLines: 1),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("${"wish_point".tr}: 5"),
                const SizedBox(
                  height: 10,
                ),
                Text("${"wish_steak_point".tr}: ${_profile.wish_streak}"),
                const SizedBox(
                  height: 30,
                ),
                _alreadyWished
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          controller: _commentTextEditingController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20),
                          ],
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          maxLength: 20,
                          textInputAction: TextInputAction.send,
                          onSubmitted: isPressed ? null : createWish,
                          onChanged: (s) {
                            setState(() {});
                          },
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                _alreadyWished
                    ? const SizedBox()
                    : Column(
                        children: [
                          AppButton(context,"wish".tr, onTap: () async {
                            await createWish(_commentTextEditingController.text);
                            await App.pointUpdate(_profile.key,
                                Define.POINT_WISH + _profile.wish_streak - 1);
                            // _audioPlayer.play(AssetSource("wish_complete.mp3"));
                          },
                              pBtnWidth: 0.8,
                              disable: isPressed ||
                                  _commentTextEditingController.text.isEmpty),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                Column(
                  children: List.generate(_list.length, (index) {
                    return ListTile(
                      leading:
                          Text("${_list[index].index} ${"place".tr}"),
                      title: Text(_list[index].comments),
                      subtitle: Text("${_list[index].nick_name}(${_list[index].streak}${"streak".tr})"),
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createWish(String wish) async {
    if (wish.isEmpty) {
      return;
    }
    setState(() {
      isPressed = true;
    });
    List<Wish> wishList = await App.updateWish(_profile, wish);
    setState(() {
      _list = wishList;
    });
    await Utils.setAlreadyWish(Utils.getStringToday());
    _alreadyWished = true;
    _profile = _profile.copyWith(wish_streak: _profile.wish_streak + 1);

    if (mounted) {
      // Utils.showSnackBar(context, SnackType.success, "success_create_wish".tr);
      Fluttertoast.showToast(msg:"success_create_wish".tr );
    }

    setState(() {
      isPressed = false;
    });
  }
}
