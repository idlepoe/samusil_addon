import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../models/profile.dart';
import '../../utils/app.dart';
import '../../controllers/profile_controller.dart';

class SplashController extends GetxController {
  final logger = Logger();

  final RxBool isLoading = true.obs;
  final Rx<Profile> profile = Profile.init().obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      logger.i('앱 초기화 시작');

      // Firebase Auth 사용자 확인 및 프로필 생성/조회
      profile.value = await App.checkUser();

      logger.i('프로필 로드 완료: ${profile.value.name}');

      // FCM 토픽 구독
      await _subscribeToNotificationTopic();

      // ProfileController 초기화
      await _initializeProfileController();

      // 잠시 대기 (스플래시 화면 표시)
      await Future.delayed(const Duration(seconds: 2));

      // 대시보드로 전환
      Get.offAllNamed('/');
    } catch (e) {
      logger.e('앱 초기화 오류: $e');

      // 오류 발생 시에도 대시보드로 전환
      Get.offAllNamed('/');
    } finally {
      isLoading.value = false;
    }
  }

  /// FCM 토픽 구독을 설정합니다.
  Future<void> _subscribeToNotificationTopic() async {
    try {
      if (profile.value.uid.isNotEmpty) {
        // 사용자의 UID를 토픽으로 구독
        await FirebaseMessaging.instance.subscribeToTopic(profile.value.uid);
        logger.i('FCM 토픽 구독 완료: ${profile.value.uid}');
      }
    } catch (e) {
      logger.e('FCM 토픽 구독 오류: $e');
    }
  }

  /// ProfileController를 초기화합니다.
  Future<void> _initializeProfileController() async {
    try {
      // ProfileController가 이미 등록되어 있는지 확인
      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        await profileController.initializeWithProfile(profile.value);
      } else {
        logger.w('ProfileController가 등록되지 않았습니다. 대시보드에서 초기화됩니다.');
      }
    } catch (e) {
      logger.e('ProfileController 초기화 오류: $e');
    }
  }
}
