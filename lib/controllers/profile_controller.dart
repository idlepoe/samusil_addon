import 'dart:async';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/profile.dart';
import '../utils/app.dart';
import '../main.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  final logger = Logger();

  // 프로필 데이터를 스트림으로 관리
  final Rx<Profile> profile = Profile.init().obs;
  final RxBool isLoading = false.obs;

  // Firestore 스트림 구독을 위한 변수
  StreamSubscription<DocumentSnapshot>? _profileStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    // Firestore 스트림 초기화
    _initProfileStream();
  }

  @override
  void onClose() {
    _profileStreamSubscription?.cancel();
    super.onClose();
  }

  /// Firestore 프로필 스트림 초기화
  void _initProfileStream() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        logger.w('User not authenticated, cannot initialize profile stream');
        return;
      }

      final profileRef = FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid);

      _profileStreamSubscription = profileRef.snapshots().listen(
        (DocumentSnapshot snapshot) async {
          if (snapshot.exists) {
            try {
              final profileData = snapshot.data() as Map<String, dynamic>;
              final userProfile = Profile.fromJson(profileData);
              profile.value = userProfile;
              logger.i('Profile updated via stream: ${userProfile.name}');
            } catch (e) {
              logger.e('Error parsing profile data from stream: $e');
            }
          } else {
            logger.w('Profile document does not exist');
            // 프로필이 없으면 초기 프로필 생성
            await _createInitialProfile(user.uid);
          }
        },
        onError: (error) {
          logger.e('Profile stream error: $error');
        },
      );
    } catch (e) {
      logger.e('Error initializing profile stream: $e');
    }
  }

  /// 초기 프로필 생성
  Future<void> _createInitialProfile(String uid) async {
    try {
      final initialProfile = Profile(
        uid: uid,
        name: '익명${uid.substring(0, 5)}',
        profile_image_url: '',
        photo_url: '',
        wish_last_date: '',
        wish_streak: 0,
        point: 0.0,
        alarms: [],
        coin_balance: [],
        one_comment: '',
      );

      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(uid)
          .set(initialProfile.toJson());

      profile.value = initialProfile;
      logger.i('Initial profile created: ${initialProfile.name}');
    } catch (e) {
      logger.e('Error creating initial profile: $e');
    }
  }

  /// 프로필 데이터를 로드합니다. (스트림이 실패할 경우를 위한 백업)
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
