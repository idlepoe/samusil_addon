import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../models/profile.dart';
import '../utils/app.dart';
import '../main.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  final logger = Logger();

  // 프로필 데이터를 스트림으로 관리
  final Rx<Profile> profile = Profile.init().obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 컨트롤러 초기화 시 프로필 데이터 로드
    loadProfile();
  }

  /// 프로필 데이터를 로드합니다.
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final userProfile = await App.getProfile();
      profile.value = userProfile;
      logger.i('Profile loaded successfully: ${userProfile.name}');
    } catch (e) {
      logger.e('Error loading profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 프로필 데이터를 새로고침합니다.
  Future<void> refreshProfile() async {
    await loadProfile();
  }

  /// 프로필 이름을 업데이트합니다.
  Future<bool> updateProfileName(String newName) async {
    try {
      final updatedProfile = profile.value.copyWith(name: newName);
      final success = await App.updateProfileName(updatedProfile);
      if (success) {
        profile.value = updatedProfile;
        logger.i('Profile name updated successfully: $newName');
      }
      return success;
    } catch (e) {
      logger.e('Error updating profile name: $e');
      return false;
    }
  }

  /// 프로필 이미지를 업데이트합니다.
  Future<bool> updateProfileImage(String imageUrl) async {
    try {
      final updatedProfile = profile.value.copyWith(
        profile_image_url: imageUrl,
      );
      final success = await App.updateProfilePicture(updatedProfile);
      if (success) {
        profile.value = updatedProfile;
        logger.i('Profile image updated successfully');
      }
      return success;
    } catch (e) {
      logger.e('Error updating profile image: $e');
      return false;
    }
  }

  /// 프로필 한줄평을 업데이트합니다.
  Future<bool> updateProfileOneComment(String oneComment) async {
    try {
      final updatedProfile = profile.value.copyWith(one_comment: oneComment);
      final success = await App.updateProfileOneComment(updatedProfile);
      if (success) {
        profile.value = updatedProfile;
        logger.i('Profile one comment updated successfully');
      }
      return success;
    } catch (e) {
      logger.e('Error updating profile one comment: $e');
      return false;
    }
  }

  /// 현재 포인트를 반환합니다.
  double get currentPoint => profile.value.point;

  /// 현재 포인트를 정수로 반환합니다.
  int get currentPointInt => profile.value.point.toInt();

  /// 현재 포인트를 반올림하여 반환합니다.
  int get currentPointRounded => profile.value.point.round();

  /// 사용자 이름을 반환합니다.
  String get userName => profile.value.name;

  /// 프로필 이미지 URL을 반환합니다.
  String get profileImageUrl => profile.value.profile_image_url;

  /// 한줄평을 반환합니다.
  String get oneComment => profile.value.one_comment;

  /// 위시 스트릭을 반환합니다.
  int get wishStreak => profile.value.wish_streak;

  /// 알림 목록을 반환합니다.
  List<dynamic> get alarms => profile.value.alarms;

  /// 코인 잔고를 반환합니다.
  List<dynamic> get coinBalance => profile.value.coin_balance ?? [];

  /// 사용자 ID를 반환합니다.
  String get uid => profile.value.uid;
}
