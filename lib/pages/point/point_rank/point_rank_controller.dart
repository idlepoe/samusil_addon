import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../define/define.dart';
import '../../../models/profile.dart';
import '../../../utils/app.dart';
import '../../../utils/util.dart';

class PointRankController extends GetxController {
  var logger = Logger();
  final dataKey = GlobalKey();

  final Rx<Profile> profile = Profile.init().obs;
  final RxList<Profile> profileList = <Profile>[].obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    try {
      profile.value = await App.getProfile();
      profileList.value = await App.getProfileList();

      logger.i(profile.value.toString());

      // 내 프로필 위치로 스크롤
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
    } catch (e) {
      logger.e(e);
    }
  }

  void scrollToMyProfile() {
    if (dataKey.currentContext != null) {
      Scrollable.ensureVisible(
        dataKey.currentContext!,
        alignment: 0.5,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  bool isMyProfile(Profile profileItem) {
    return profileItem.uid == profile.value.uid;
  }

  String getProfileImageUrl(Profile profileItem) {
    return profileItem.profile_image_url;
  }

  String getProfileName(Profile profileItem) {
    return profileItem.name;
  }

  String getProfileCreatedAt(Profile profileItem) {
    return Utils.toConvertFireDateToCommentTime(profileItem.uid, bYear: true);
  }

  int getProfilePoint(Profile profileItem) {
    return profileItem.point.round();
  }
}
