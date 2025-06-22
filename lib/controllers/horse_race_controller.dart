import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../models/horse_race.dart';
import '../models/coin.dart';
import '../utils/app.dart';
import '../utils/http_service.dart';
import '../define/define.dart';
import 'profile_controller.dart';

class HorseRaceController extends GetxController {
  final logger = Logger();
  
  final Rx<HorseRace?> currentRace = Rx<HorseRace?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isBetting = false.obs;
  final RxString selectedHorseId = ''.obs;
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
    final now = Timestamp.now();
    
    _raceSubscription = FirebaseFirestore.instance
        .collection('horse_races')
        .where('isFinished', isEqualTo: false)
        .where('endTime', isGreaterThan: now)
        .orderBy('endTime', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) async {
          if (snapshot.docs.isNotEmpty) {
            final raceData = snapshot.docs.first.data();
            currentRace.value = HorseRace.fromJson(raceData);
            await _checkIfBetPlaced(currentRace.value!.id);
          } else {
            currentRace.value = null;
            hasPlacedBet.value = false;
          }
          isLoading.value = false;
        }, onError: (error) {
          logger.e('경마 정보 구독 오류: $error');
          isLoading.value = false;
        });
  }
  
  Future<void> _checkIfBetPlaced(String raceId) async {
    final uid = ProfileController.to.uid;
    if (uid.isEmpty) return;
    
    final betDoc = await FirebaseFirestore.instance
      .collection('horse_races')
      .doc(raceId)
      .collection('bets')
      .doc(uid)
      .get();
      
    hasPlacedBet.value = betDoc.exists;
  }

  /// 경마 초기화
  Future<void> _initializeRace() async {
    try {
      isLoading.value = true;
      
      // 현재 시간 기준으로 경마 일정 확인
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      // 0시~1시: 베팅, 1시~4시: 경마 진행
      final bettingStartTime = today.add(const Duration(hours: 0));
      final bettingEndTime = today.add(const Duration(hours: 1));
      final raceStartTime = today.add(const Duration(hours: 1));
      final raceEndTime = today.add(const Duration(hours: 4));

      // 현재 경마 상태 확인
      if (now.isBefore(bettingEndTime)) {
        // 베팅 기간
        await _createOrGetCurrentRace(bettingStartTime, bettingEndTime, raceStartTime, raceEndTime);
      } else if (now.isBefore(raceEndTime)) {
        // 경마 진행 중
        await _getCurrentRace();
      } else {
        // 경마 종료
        await _getFinishedRace();
      }
    } catch (e) {
      logger.e('경마 초기화 오류: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 현재 경마 생성 또는 가져오기
  Future<void> _createOrGetCurrentRace(
    DateTime bettingStartTime,
    DateTime bettingEndTime,
    DateTime raceStartTime,
    DateTime raceEndTime,
  ) async {
    try {
      // 기존 경마 확인
      final raceDoc = await FirebaseFirestore.instance
          .collection('horse_races')
          .where('startTime', isEqualTo: raceStartTime)
          .limit(1)
          .get();

      if (raceDoc.docs.isNotEmpty) {
        // 기존 경마가 있으면 가져오기
        final raceData = raceDoc.docs.first.data();
        currentRace.value = HorseRace.fromJson(raceData);
      } else {
        // 새 경마 생성
        await _createNewRace(bettingStartTime, bettingEndTime, raceStartTime, raceEndTime);
      }
    } catch (e) {
      logger.e('경마 생성/가져오기 오류: $e');
    }
  }

  /// 새 경마 생성
  Future<void> _createNewRace(
    DateTime bettingStartTime,
    DateTime bettingEndTime,
    DateTime raceStartTime,
    DateTime raceEndTime,
  ) async {
    try {
      // 코인 목록 가져오기
      final coins = await _getCoinsForRace();
      
      // 말 생성
      final horses = coins.map((coin) => Horse(
        coinId: coin.id,
        name: coin.name,
        symbol: coin.symbol,
        currentPosition: 0.0,
        movements: [],
        lastPrice: coin.price_history?.last.price ?? 0.0,
        previousPrice: coin.price_history?.last.price ?? 0.0,
      )).toList();

      // 경마 생성
      final race = HorseRace(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        startTime: raceStartTime,
        endTime: raceEndTime,
        bettingEndTime: bettingEndTime,
        horses: horses,
        bets: [],
        isActive: false,
        isFinished: false,
        currentRound: 0,
        totalRounds: 12, // 3시간 = 12라운드
      );

      // Firestore에 저장
      await FirebaseFirestore.instance
          .collection('horse_races')
          .doc(race.id)
          .set(race.toJson());

      currentRace.value = race;
      logger.i('새 경마 생성 완료: ${race.id}');
    } catch (e) {
      logger.e('새 경마 생성 오류: $e');
    }
  }

  /// 경마용 코인 목록 가져오기
  Future<List<Coin>> _getCoinsForRace() async {
    try {
      final response = await HttpService().get('/getCoinList');
      if (response.data['success']) {
        final List<dynamic> coinData = response.data['data'];
        return coinData.take(6).map((data) => Coin.fromJson(data)).toList();
      }
    } catch (e) {
      logger.e('코인 목록 가져오기 오류: $e');
    }
    return [];
  }

  /// 현재 경마 가져오기
  Future<void> _getCurrentRace() async {
    try {
      final raceDoc = await FirebaseFirestore.instance
          .collection('horse_races')
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (raceDoc.docs.isNotEmpty) {
        final raceData = raceDoc.docs.first.data();
        currentRace.value = HorseRace.fromJson(raceData);
      }
    } catch (e) {
      logger.e('현재 경마 가져오기 오류: $e');
    }
  }

  /// 완료된 경마 가져오기
  Future<void> _getFinishedRace() async {
    try {
      final today = DateTime.now();
      final raceStartTime = DateTime(today.year, today.month, today.day, 1, 0);
      
      final raceDoc = await FirebaseFirestore.instance
          .collection('horse_races')
          .where('startTime', isEqualTo: raceStartTime)
          .limit(1)
          .get();

      if (raceDoc.docs.isNotEmpty) {
        final raceData = raceDoc.docs.first.data();
        currentRace.value = HorseRace.fromJson(raceData);
      }
    } catch (e) {
      logger.e('완료된 경마 가져오기 오류: $e');
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
      final HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'asia-northeast3').httpsCallable('placeBet');
      final response = await callable.call(<String, dynamic>{
        'raceId': currentRace.value!.id,
        'horseId': selectedHorseId.value,
        'betType': selectedBetType.value,
        'amount': selectedBetAmount.value,
      });

      if (response.data['success']) {
        Get.snackbar('성공', '베팅이 완료되었습니다!');
        hasPlacedBet.value = true;
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
    
    if (now.isBefore(race.bettingEndTime)) return '베팅 중';
    if (now.isBefore(race.endTime)) return '경주 중';
    return '경주 종료';
  }

  /// 남은 시간 계산
  Duration getRemainingTime() {
    if (currentRace.value == null) return Duration.zero;
    
    final now = DateTime.now();
    final race = currentRace.value!;
    
    if (now.isBefore(race.bettingEndTime)) return race.bettingEndTime.difference(now);
    if (now.isBefore(race.endTime)) return race.endTime.difference(now);
    return Duration.zero;
  }

  /// 베팅 배당률 계산
  double getBetMultiplier(String type) {
    return {'winner': 5.0, 'top2': 2.0, 'top3': 1.5}[type] ?? 1.0;
  }

  /// 예상 획득 포인트 계산
  int getExpectedPoints() {
    return (selectedBetAmount.value * getBetMultiplier(selectedBetType.value)).round();
  }
} 