import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../models/profile.dart';
import '../../utils/app.dart';

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
}
