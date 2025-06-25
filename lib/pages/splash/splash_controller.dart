import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../models/profile.dart';
import '../../utils/app.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/horse_race_controller.dart';

class SplashController extends GetxController {
  final logger = Logger();

  final RxBool isLoading = true.obs;
  final Rx<Profile> profile = Profile.init().obs;

  // 랜덤 문구 리스트
  final List<String> _subtitles = [
    '오늘도 화이팅! 🎯',
    '커피 한 잔의 여유 ☕',
    '새로운 하루를 시작해요! 🌅',
    '동료들과 함께하는 시간 👥',
    '점심 메뉴 고민 해결! 🍽️',
    '오피스 라이프를 즐겨보세요 🏢',
    '소원을 빌어보세요 ⭐',
    '오늘의 BGM은? 🎵',
    '잠깐의 휴식 시간 🌸',
    '함께라서 더 즐거운 하루 💫',
  ];

  final List<String> _loadingTexts = [
    '오피스 라운지 준비 중... ☕',
    '맛있는 점심 메뉴 찾는 중... 🍱',
    '좋은 음악 준비 중... 🎧',
    '동료들과 연결 중... 👋',
    '오늘의 운세 확인 중... 🔮',
    '신선한 콘텐츠 로딩 중... 📱',
    '즐거운 하루 준비 중... 🌟',
    '커피 내리는 중... ☕',
  ];

  // 선택된 랜덤 문구들
  late final String randomSubtitle;
  late final String randomLoadingText;

  @override
  void onInit() {
    super.onInit();
    _selectRandomTexts();
    _initializeApp();
  }

  /// 랜덤 문구들을 선택합니다.
  void _selectRandomTexts() {
    final random = Random();
    randomSubtitle = _subtitles[random.nextInt(_subtitles.length)];
    randomLoadingText = _loadingTexts[random.nextInt(_loadingTexts.length)];
    logger.i('랜덤 문구 선택: $randomSubtitle, $randomLoadingText');
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

      // HorseRaceController 초기화
      // if (!Get.isRegistered<HorseRaceController>()) {
      //   Get.put(HorseRaceController());
      //   logger.i('HorseRaceController 초기화 완료');
      // }
    } catch (e) {
      logger.e('ProfileController 초기화 오류: $e');
    }
  }
}
