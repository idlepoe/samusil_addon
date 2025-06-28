import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../components/appSnackbar.dart';
import '../../define/define.dart';
import '../../models/profile.dart';
import '../../models/wish.dart';
import '../../utils/app.dart';
import '../../utils/util.dart';

class WishController extends GetxController {
  var logger = Logger();

  // 상태 변수들
  final profile = Profile.init().obs;
  final wishList = <Wish>[].obs;
  final alreadyWished = true.obs;
  final isPressed = false.obs;
  final isLoading = false.obs;
  final hasText = false.obs;

  // 텍스트 컨트롤러
  final TextEditingController commentController = TextEditingController();

  // Focus 관리
  final FocusNode commentFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();

    init();
  }

  @override
  void onClose() {
    commentController.dispose();
    commentFocusNode.dispose();
    super.onClose();
  }

  Future<void> init() async {
    isLoading.value = true;

    try {
      await App.checkUser();
      profile.value = await App.getProfile();
      alreadyWished.value = await Utils.getAlreadyWish();

      // Wish 목록 조회
      final wishes = await App.getWish();
      // 인덱스 기준으로 내림차순 정렬 (높은 숫자가 위로)
      wishes.sort((a, b) => b.index.compareTo(a.index));
      wishList.value = wishes;
    } catch (e) {
      logger.e("Error in init: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    isLoading.value = true;

    try {
      profile.value = await App.getProfile();
      alreadyWished.value = await Utils.getAlreadyWish();

      // Wish 목록 새로고침
      final wishes = await App.getWish();
      // 인덱스 기준으로 내림차순 정렬 (높은 숫자가 위로)
      wishes.sort((a, b) => b.index.compareTo(a.index));
      wishList.value = wishes;
    } catch (e) {
      logger.e("Error in refresh: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createWish(String wish) async {
    if (wish.isEmpty || isPressed.value) {
      return;
    }

    isPressed.value = true;

    try {
      // Cloud Function을 통해 Wish 생성
      final result = await App.createWish(comment: wish);

      if (result.isNotEmpty && result['success'] == true) {
        // 성공 시 로컬 상태 업데이트
        await Utils.setAlreadyWish(Utils.getStringToday());
        alreadyWished.value = true;

        // Cloud Function 응답에서 프로필 업데이트
        if (result['data'] != null && result['data']['profile'] != null) {
          profile.value = Profile.fromJson(result['data']['profile']);
        } else {
          // 프로필 새로고침
          profile.value = await App.getProfile();
        }

        // Wish 목록 새로고침
        final wishes = await App.getWish();
        // 인덱스 기준으로 내림차순 정렬 (높은 숫자가 위로)
        wishes.sort((a, b) => b.index.compareTo(a.index));
        wishList.value = wishes;

        // 입력 필드 초기화
        commentController.clear();

        // focus 유지
        commentFocusNode.requestFocus();

        // 성공 메시지 표시
        final pointsEarned = result['data']?['pointsEarned'] ?? 0;
        final basePoints = result['data']?['basePoints'] ?? 0;
        final streakBonus = result['data']?['streakBonus'] ?? 0;
        final newStreak = result['data']?['newStreak'] ?? 1;

        String message = '소원이 생성되었습니다! +${pointsEarned}포인트';
        if (streakBonus > 0) {
          message += '\n(기본 ${basePoints}P + 연승보너스 ${streakBonus}P)';
          message += '\n🔥 ${newStreak}일 연속 소원빌기!';
        } else {
          message += '\n✨ 내일도 연속으로 빌면 보너스 포인트!';
        }

        AppSnackbar.success(message);
      } else {
        // 에러 메시지 표시
        String errorMessage = result['error'] ?? '소원 생성에 실패했습니다.';
        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      logger.e("Error creating wish: $e");
      AppSnackbar.error('소원 생성 중 오류가 발생했습니다.');
    } finally {
      isPressed.value = false;
    }
  }

  bool get canCreateWish =>
      !alreadyWished.value && hasText.value && !isPressed.value;

  void onTextChanged(String text) {
    hasText.value = text.trim().isNotEmpty;
  }

  // 본인의 소원인지 확인하는 메서드
  bool isMyWish(Wish wish) {
    return wish.uid == profile.value.uid;
  }
}
