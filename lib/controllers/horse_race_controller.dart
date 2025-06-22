import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../models/horse_race.dart';
import '../models/coin.dart';
import '../utils/app.dart';
import '../define/define.dart';
import 'profile_controller.dart';

class HorseRaceController extends GetxController {
  final logger = Logger();

  final Rx<HorseRace?> currentRace = Rx<HorseRace?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isBetting = false.obs;
  final RxString selectedHorseId = ''.obs;
  final Rx<String?> betOnHorseId = Rx<String?>(null);
  final RxInt selectedBetAmount = 10.obs;
  final RxString selectedBetType = 'winner'.obs;
  final RxBool hasPlacedBet = false.obs;

  // 베팅 금액 옵션
  final List<int> betAmountOptions = [10, 20, 50, 100];
  StreamSubscription? _raceSubscription;

  @override
  void onInit() {
    super.onInit();
    _subscribeToCurrentRace();
  }

  @override
  void onClose() {
    _raceSubscription?.cancel();
    super.onClose();
  }

  void _subscribeToCurrentRace() {
    isLoading.value = true;

    // 타임아웃 설정 (10초)
    Timer(const Duration(seconds: 10), () {
      if (isLoading.value) {
        logger.w('경마 정보 구독 타임아웃');
        isLoading.value = false;
      }
    });

    // main_stadium에서 직접 현재 경마 정보를 구독합니다.
    _raceSubscription = FirebaseFirestore.instance
        .collection('horse_race_stadiums')
        .doc('main_stadium')
        .snapshots()
        .listen(
          (stadiumSnapshot) async {
            if (stadiumSnapshot.exists) {
              final stadiumData = stadiumSnapshot.data();

              // 경마가 종료되었거나 데이터가 비정상적일 경우
              if (stadiumData == null ||
                  stadiumData['isFinished'] == true ||
                  stadiumData['id'] == null) {
                currentRace.value = null;
                hasPlacedBet.value = false;
                selectedHorseId.value = '';
                betOnHorseId.value = null;
                isLoading.value = false;
                return;
              }

              // 새로운 경마인 경우 베팅 상태 초기화
              if (currentRace.value?.id != stadiumData['id']) {
                hasPlacedBet.value = false;
                selectedHorseId.value = '';
                betOnHorseId.value = null;
              }

              currentRace.value = HorseRace.fromJson(stadiumData);
              await _checkIfBetPlaced(currentRace.value!.id);
            } else {
              // 문서가 없는 경우 (최초 상태 등)
              currentRace.value = null;
              hasPlacedBet.value = false;
              selectedHorseId.value = '';
              betOnHorseId.value = null;
              isLoading.value = false;
            }
            isLoading.value = false;
          },
          onError: (error) {
            logger.e('경마장 정보 구독 오류: $error');
            isLoading.value = false;
          },
        );
  }

  Future<void> _checkIfBetPlaced(String raceId) async {
    final uid = ProfileController.to.uid;
    if (uid.isEmpty) return;

    try {
      final betDoc =
          await FirebaseFirestore.instance
              .collection('horse_races')
              .doc(raceId)
              .collection('bets')
              .doc(uid)
              .get();

      if (betDoc.exists) {
        hasPlacedBet.value = true;
        betOnHorseId.value = betDoc.data()?['horseId'] as String?;
      } else {
        hasPlacedBet.value = false;
        betOnHorseId.value = null;
      }
    } catch (e) {
      logger.e('베팅 확인 오류: $e');
      hasPlacedBet.value = false;
      betOnHorseId.value = null;
    }
  }

  /// 베팅하기
  Future<void> placeBet() async {
    if (isBetting.value) return;
    if (currentRace.value == null || selectedHorseId.value.isEmpty) {
      Get.snackbar('알림', '말을 선택해주세요.');
      return;
    }

    final profileController = ProfileController.to;
    if (profileController.currentPoint < selectedBetAmount.value) {
      Get.snackbar('알림', '포인트가 부족합니다.');
      return;
    }

    isBetting.value = true;
    try {
      final HttpsCallable callable = FirebaseFunctions.instanceFor(
        region: 'asia-northeast3',
      ).httpsCallable('placeBet');
      final response = await callable.call(<String, dynamic>{
        'raceId': currentRace.value!.id,
        'horseId': selectedHorseId.value,
        'betType': selectedBetType.value,
        'amount': selectedBetAmount.value,
      });

      if (response.data['success']) {
        Get.snackbar('성공', '베팅이 완료되었습니다!');
        hasPlacedBet.value = true;
        // 선택된 말 초기화
        selectedHorseId.value = '';
        // 프로필 컨트롤러의 포인트 업데이트
        await ProfileController.to.refreshProfile();
      } else {
        Get.snackbar('오류', response.data['message'] ?? '베팅 중 오류 발생');
      }
    } catch (e) {
      logger.e('베팅 함수 호출 오류: $e');
      Get.snackbar('오류', '베팅 중 심각한 오류가 발생했습니다.');
    } finally {
      isBetting.value = false;
    }
  }

  /// 베팅 금액 변경
  void changeBetAmount(int amount) {
    selectedBetAmount.value = amount;
  }

  /// 베팅 타입 변경
  void changeBetType(String type) {
    selectedBetType.value = type;
  }

  /// 말 선택
  void selectHorse(String horseId) {
    if (getRaceStatus() != '베팅 중' || hasPlacedBet.value) return;
    selectedHorseId.value = horseId;
  }

  /// 현재 경마 상태 확인
  String getRaceStatus() {
    if (currentRace.value == null) return '경마 없음';

    final now = DateTime.now();
    final race = currentRace.value!;

    if (race.isFinished) return '경주 종료';
    if (now.isBefore(race.bettingEndTime)) return '베팅 중';
    if (race.isActive) return '경주 중';
    return '대기 중';
  }

  /// 남은 시간 계산
  Duration getRemainingTime() {
    final now = DateTime.now();

    // 현재 진행중인 경마가 있고, 아직 끝나지 않았을 경우
    if (currentRace.value != null && !currentRace.value!.isFinished) {
      final race = currentRace.value!;
      if (now.isBefore(race.bettingEndTime)) {
        return race.bettingEndTime.difference(now); // 베팅 마감까지
      } else if (now.isBefore(race.startTime)) {
        return race.startTime.difference(now); // 경주 시작까지
      } else if (now.isBefore(race.endTime)) {
        return race.endTime.difference(now); // 경주 종료까지
      }
    }

    // 현재 진행중인 경마가 없거나, 종료된 경우 다음 경마까지 남은 시간 계산
    final DateTime nextRaceTime;
    if (now.minute < 30) {
      // 현재 시간이 30분 미만이면, 다음 경주는 현재 시간의 30분
      nextRaceTime = DateTime(now.year, now.month, now.day, now.hour, 30);
    } else {
      // 현재 시간이 30분 이상이면, 다음 경주는 다음 시간 정각
      nextRaceTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
      ).add(const Duration(hours: 1));
    }

    return nextRaceTime.difference(now);
  }

  /// 베팅 배당률 계산
  double getBetMultiplier(String type) {
    return {'winner': 5.0, 'top2': 2.0, 'top3': 1.5}[type] ?? 1.0;
  }

  /// 예상 획득 포인트 계산
  int getExpectedPoints() {
    return (selectedBetAmount.value * getBetMultiplier(selectedBetType.value))
        .round();
  }

  /// 경마 새로고침
  Future<void> refreshRace() async {
    if (currentRace.value != null) {
      await _checkIfBetPlaced(currentRace.value!.id);
    }
  }
}
