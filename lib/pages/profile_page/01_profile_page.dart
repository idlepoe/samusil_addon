import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:samusil_addon/components/appButton.dart';

import '../../components/appTextField.dart';
import '../../define/arrays.dart';
import '../../define/define.dart';
import '../../define/enum.dart';
import '../../models/profile.dart';
import '../../utils/app.dart';
import '../../utils/news.dart';
import '../../utils/util.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var logger = Logger();

  // user info
  Profile _profile = Profile.init();
  bool _isMaster = false;

  // name
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _oneCommentTextEditingController =
      TextEditingController();
  final TextEditingController _changeNameTextFieldController =
      TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _oneCommentFocusNode = FocusNode();
  final FocusNode _changeNameFocusNode = FocusNode();

  // picture
  final ImagePicker _picker = ImagePicker();
  XFile? _updateReadyImageXFile;
  ImageProvider<Object>? _updateReadyImage;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _profile = await App.getProfile();
    _nameTextEditingController.text = _profile.name;
    _oneCommentTextEditingController.text = _profile.one_comment;
    if (mounted) {
      // Utils.showSnackBar(
      //     context,
      //     _profile.key.isNotEmpty ? SnackType.success : SnackType.error,
      //     _profile.key.isNotEmpty
      //         ? "success_get_profile".tr
      //         : "error_get_profile".tr);
    }
    _isMaster = await App.isMaster();
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
          Arrays.getBoardInfoByIndex(Define.INDEX_PROFILE_PAGE).title.tr,
          style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              CircleAvatar(
                radius: 80,
                backgroundImage:
                    _updateReadyImage ??
                    (Utils.isValidNilEmptyStr(_profile.profile_image_url)
                        ? NetworkImage(_profile.profile_image_url)
                        : null),
                child: InkWell(
                  onTap: () async {
                    final pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      logger.i(pickedFile);
                      _updateReadyImageXFile = pickedFile;
                      ImageProvider<Object> image = await Utils.xFileToImage(
                        pickedFile,
                      );
                      setState(() {
                        _updateReadyImage = image;
                      });
                      String imageUrl = await Utils.uploadFileToStorage(
                        _updateReadyImageXFile,
                        "${Utils.getDateTimeKey()}.${pickedFile.path.split(".").last}",
                      );
                      _profile = _profile.copyWith(profile_image_url: imageUrl);
                      bool result = await App.updateProfilePicture(_profile);
                      if (mounted) {
                        // Utils.showSnackBar(
                        //   context,
                        //   result ? SnackType.success : SnackType.error,
                        //   result
                        //       ? "success_change_profile_picture".tr
                        //       : "error_change_profile_picture".tr,
                        // );
                        Fluttertoast.showToast(
                          msg:
                              result
                                  ? "success_change_profile_picture".tr
                                  : "error_change_profile_picture".tr,
                        );
                      }
                    }
                  },
                  child:
                      _profile.profile_image_url.isEmpty &&
                              _updateReadyImage == null
                          ? Stack(
                            alignment: Alignment.center,
                            children: [
                              const CircleAvatar(
                                radius: 80,
                                backgroundImage: AssetImage(
                                  'assets/anon_icon.jpg',
                                ),
                              ),
                              Text(
                                "image_add".tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  backgroundColor: Colors.black.withOpacity(
                                    0.5,
                                  ),
                                ),
                              ),
                            ],
                          )
                          : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameTextEditingController,
                focusNode: _nameFocusNode,
                decoration: InputDecoration(
                  labelText: "name".tr,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  suffixIcon: IconButton(
                    onPressed: updateName,
                    icon: const Icon(Icons.edit),
                  ),
                ),
                maxLength: 20,
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
                onChanged: (s) {
                  setState(() {});
                },
                onSubmitted: (s) async {
                  await updateName();
                },
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _oneCommentTextEditingController,
                focusNode: _oneCommentFocusNode,
                decoration: InputDecoration(
                  labelText: "one_comment".tr,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  suffixIcon: IconButton(
                    onPressed: updateOneComment,
                    icon: const Icon(Icons.edit),
                  ),
                ),
                maxLength: 20,
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
                onChanged: (s) {
                  setState(() {});
                },
                onSubmitted: (s) async {
                  await updateOneComment();
                },
              ),
              const SizedBox(height: 30),
              AppButton(
                context,
                "profile_change".tr,
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("profile_change".tr),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppTextField(
                              "change_profile_key_input".tr,
                              _changeNameTextFieldController,
                              focusNode: _changeNameFocusNode,
                              textInputType: TextInputType.number,
                              maxLength: 17,
                            ),
                            const SizedBox(height: 10),
                            AppButton(
                              context,
                              "confirm".tr,
                              onTap: () async {
                                bool isCheck = await App.checkDBProfile(
                                  _changeNameTextFieldController.text,
                                );
                                if (isCheck) {
                                  Profile profile = Profile(
                                    key: _changeNameTextFieldController.text,
                                    name: _nameTextEditingController.text,
                                    profile_image_url: "",
                                    wish_last_date: "",
                                    wish_streak: 0,
                                    point: 0,
                                    alarms: [],
                                    coin_balance: [],
                                    one_comment: "",
                                  );
                                  await App.setLocaleProfile(profile);
                                  await init();
                                }
                                _changeNameTextFieldController.text = "";
                                if (mounted) {
                                  // Utils.showSnackBar(context, SnackType.success,
                                  //     "success_change_profile".tr);
                                  Fluttertoast.showToast(
                                    msg: "success_change_profile".tr,
                                  );
                                }
                                Navigator.pop(context);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                disable: _nameTextEditingController.text.isEmpty,
                backgroundColor: Colors.amber,
                textColor: Colors.black,
                pBtnWidth: 0.8,
              ),
              const SizedBox(height: 30),
              AutoSizeText(
                "※${"profile_change".tr} KEY",
                style: const TextStyle(fontSize: 20),
                maxLines: 1,
              ),
              SelectableText(
                _profile.key,
                style: const TextStyle(fontSize: 20),
                maxLines: 1,
              ),
              const SizedBox(height: 30),
              if (_isMaster)
                AppButton(
                  context,
                  "get_news".tr,
                  backgroundColor: Colors.teal,
                  onTap: () async {
                    await App.checkUser();
                    await News.getGameNewsList(context);
                    await News.getITWorldNewsList(context);
                    // await App.getCoinListFromPaprika(context);
                    // await App.getCoinPriceFromPaprika(context);
                  },
                  pBtnWidth: 0.8,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateName() async {
    if (_nameTextEditingController.text.isEmpty) {
      return;
    }
    _profile = _profile.copyWith(name: _nameTextEditingController.text);
    bool result = await App.updateProfileName(_profile);
    if (mounted) {
      Fluttertoast.showToast(
        msg: result ? "success_change_name".tr : "error_change_name".tr,
      );
      _nameFocusNode.unfocus();
    }
  }

  Future<void> updateOneComment() async {
    if (_oneCommentTextEditingController.text.isEmpty) {
      return;
    }
    _profile = _profile.copyWith(
      one_comment: _oneCommentTextEditingController.text,
    );
    bool result = await App.updateProfileOneComment(_profile);
    if (mounted) {
      Utils.showSnackBar(
        context,
        result ? SnackType.success : SnackType.error,
        result
            ? "success_change_one_comment".tr
            : "error_change_one_comment".tr,
      );
      _oneCommentFocusNode.unfocus();
    }
  }
}
