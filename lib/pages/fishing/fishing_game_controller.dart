import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../models/fish.dart';
import '../../controllers/profile_controller.dart';
import '../../utils/fish_collection_service.dart';

class FishingGameController extends GetxController
    with GetTickerProviderStateMixin {
  final logger = Logger();

  // 게임 상태
  final RxBool isGameActive = false.obs;
  final RxBool isButtonPressed = false.obs;
  final RxDouble playerBarPosition = 0.5.obs; // 0.0 ~ 1.0 (하단 ~ 상단)
  final RxDouble fishPosition = 0.5.obs; // 물고기 위치
  final RxDouble successGauge = 0.0.obs; // 성공 게이지 0.0 ~ 1.0
  final Rx<Fish?> currentFish = Rx<Fish?>(null);
  final RxBool gameResult = false.obs; // true: 성공, false: 실패
  final RxBool showResult = false.obs;
  final RxBool showResultMessage = false.obs; // 결과 메시지 표시 여부
  final RxBool isButtonDisabled = false.obs; // 버튼 비활성화 상태

  // 게임 설정
  static const double barSize = 0.08; // 플레이어 바 크기 (모든 물고기보다 작게)
  static const double gravity = 0.8; // 중력 (바가 아래로 떨어지는 속도)
  static const double jumpPower = 1.2; // 버튼 누를 때 위로 올라가는 속도
  static const double gaugeIncreaseSpeed =
      0.2; // 게이지 증가 속도 (0.6 → 0.2, 3배 더 느리게)
  static const double gaugeDecreaseSpeed = 0.25; // 게이지 감소 속도 (0.8 → 0.25)

  // 타이머
  Timer? _gameTimer;
  Timer? _fishMovementTimer;

  // 물고기 움직임 관련
  int _movementCounter = 0; // 움직임 카운터 (패턴 생성용)

  // 물고기 목록
  final List<Fish> availableFishes = Fish.getDummyFishes();

  // 물고기 도감 관련
  final RxSet<String> caughtFish = <String>{}.obs;
  final FishCollectionService _collectionService =
      FishCollectionService.instance;

  @override
  void onInit() {
    super.onInit();
    _selectRandomFish();
    _loadCaughtFish();
  }

  /// 잡은 물고기 목록 로드
  Future<void> _loadCaughtFish() async {
    final caught = await _collectionService.getCaughtFish();
    caughtFish.value = caught;
  }

  /// 잡은 물고기 추가
  Future<void> _addCaughtFish(String fishName) async {
    await _collectionService.addCaughtFish(fishName);
    caughtFish.add(fishName);
  }

  /// 특정 물고기를 잡았는지 확인
  bool isFishCaught(String fishName) {
    return caughtFish.contains(fishName);
  }

  /// 특정 물고기를 잡은 개수 가져오기
  Future<int> getFishCount(String fishName) async {
    return await _collectionService.getFishCount(fishName);
  }

  @override
  void onClose() {
    _stopGame();
    super.onClose();
  }

  /// 랜덤 물고기 선택 (현재 시간에 출현 가능한 물고기만)
  void _selectRandomFish() {
    final random = Random();

    // 현재 시간에 출현 가능한 물고기만 필터링
    final availableNow =
        availableFishes.where((fish) => fish.isAvailableNow()).toList();

    if (availableNow.isEmpty) {
      // 출현 가능한 물고기가 없으면 전체에서 선택 (예외 상황)
      currentFish.value =
          availableFishes[random.nextInt(availableFishes.length)];
    } else {
      currentFish.value = availableNow[random.nextInt(availableNow.length)];
    }
  }

  /// 게임 시작
  void startGame() {
    if (isGameActive.value) return;

    _selectRandomFish();
    isGameActive.value = true;
    showResult.value = false;
    showResultMessage.value = false; // 결과 메시지 숨김
    isButtonPressed.value = false; // 버튼 상태 초기화
    playerBarPosition.value = 0.5;
    fishPosition.value = 0.5;
    successGauge.value = 0.3; // 30%로 시작
    gameResult.value = false;
    _movementCounter = 0; // 움직임 카운터 초기화

    _startGameLoop();
    _startFishMovement();
  }

  /// 게임 중지
  void _stopGame() {
    isGameActive.value = false;
    _gameTimer?.cancel();
    _fishMovementTimer?.cancel();
  }

  /// 게임 루프 시작
  void _startGameLoop() {
    _gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!isGameActive.value) {
        timer.cancel();
        return;
      }

      _updatePlayerBarPosition();
      _updateSuccessGauge();
      _checkGameEnd();
    });
  }

  /// 물고기 움직임 시작
  void _startFishMovement() {
    final fish = currentFish.value;
    if (fish == null) return;

    _fishMovementTimer = Timer.periodic(
      Duration(milliseconds: (100 / fish.speed).round()),
      (timer) {
        if (!isGameActive.value) {
          timer.cancel();
          return;
        }

        _updateFishPosition();
      },
    );
  }

  /// 플레이어 바 위치 업데이트
  void _updatePlayerBarPosition() {
    double newPosition = playerBarPosition.value;

    if (isButtonPressed.value) {
      // 버튼을 누르고 있으면 위로
      newPosition += jumpPower * 0.016; // 60fps 기준
    } else {
      // 버튼을 떼면 아래로 (중력)
      newPosition -= gravity * 0.016;
    }

    // 범위 제한
    playerBarPosition.value = newPosition.clamp(0.0, 1.0);
  }

  /// 물고기 위치 업데이트 (복잡한 움직임 패턴)
  void _updateFishPosition() {
    final random = Random();
    final fish = currentFish.value;
    if (fish == null) return;

    _movementCounter++;
    double movement = 0;

    // 난이도별 다른 움직임 패턴
    switch (fish.difficulty) {
      case 1: // 쉬움 - 단순한 랜덤 움직임
        movement = (random.nextDouble() - 0.5) * fish.movementPattern;
        break;

      case 2: // 보통 - 약간의 주기성이 있는 움직임
        double randomComponent =
            (random.nextDouble() - 0.5) * fish.movementPattern * 0.7;
        double periodicComponent =
            sin(_movementCounter * 0.1) * fish.movementPattern * 0.3;
        movement = randomComponent + periodicComponent;
        break;

      case 3: // 어려움 - 불규칙한 방향 전환
        if (_movementCounter % 8 == 0) {
          // 가끔 급격한 방향 전환
          movement = (random.nextDouble() - 0.5) * fish.movementPattern * 2;
        } else {
          movement = (random.nextDouble() - 0.5) * fish.movementPattern;
        }
        break;

      case 4: // 희귀 - 복합적인 패턴
        double randomComponent =
            (random.nextDouble() - 0.5) * fish.movementPattern * 0.6;
        double sineComponent =
            sin(_movementCounter * 0.15) * fish.movementPattern * 0.3;
        double cosineComponent =
            cos(_movementCounter * 0.08) * fish.movementPattern * 0.1;
        movement = randomComponent + sineComponent + cosineComponent;
        break;

      case 5: // 전설 - 매우 예측하기 어려운 패턴
        double randomComponent =
            (random.nextDouble() - 0.5) * fish.movementPattern * 0.5;
        double complexSine =
            sin(_movementCounter * 0.2 + random.nextDouble()) *
            fish.movementPattern *
            0.3;
        double complexCosine =
            cos(_movementCounter * 0.12 + random.nextDouble()) *
            fish.movementPattern *
            0.2;

        // 가끔 순간 이동 같은 효과
        if (_movementCounter % 15 == 0) {
          movement = (random.nextDouble() - 0.5) * fish.movementPattern * 3;
        } else {
          movement = randomComponent + complexSine + complexCosine;
        }
        break;
    }

    double newPosition = fishPosition.value + movement;

    // 범위 제한 (물고기 크기의 절반만큼 여유 공간 확보)
    double minPos = fish.size / 2;
    double maxPos = 1.0 - fish.size / 2;
    fishPosition.value = newPosition.clamp(minPos, maxPos);
  }

  /// 성공 게이지 업데이트
  void _updateSuccessGauge() {
    final fish = currentFish.value;
    if (fish == null) return;

    // 플레이어 바가 물고기 범위에 있는지 확인
    bool isInRange = _isPlayerBarInFishRange();

    if (isInRange) {
      // 범위 안에 있으면 게이지 증가
      successGauge.value += gaugeIncreaseSpeed * 0.016;
    } else {
      // 범위 밖에 있으면 게이지 감소
      successGauge.value -= gaugeDecreaseSpeed * 0.016;
    }

    // 범위 제한
    successGauge.value = successGauge.value.clamp(0.0, 1.0);
  }

  /// 플레이어 바가 물고기 범위에 있는지 확인
  bool _isPlayerBarInFishRange() {
    final fish = currentFish.value;
    if (fish == null) return false;

    double playerTop = playerBarPosition.value + barSize / 2;
    double playerBottom = playerBarPosition.value - barSize / 2;
    double fishTop = fishPosition.value + fish.size / 2;
    double fishBottom = fishPosition.value - fish.size / 2;

    return playerBottom < fishTop && playerTop > fishBottom;
  }

  /// 게임 종료 체크
  void _checkGameEnd() {
    if (successGauge.value >= 1.0) {
      // 성공
      gameResult.value = true;
      _endGame();
    } else if (successGauge.value <= 0.0) {
      // 실패
      gameResult.value = false;
      _endGame();
    }
  }

  /// 게임 종료
  void _endGame() {
    _stopGame();
    showResult.value = true;

    // 버튼 상태 초기화 (게임 종료 시 버튼이 눌린 상태일 수 있음)
    isButtonPressed.value = false;

    // 버튼 비활성화
    isButtonDisabled.value = true;

    // 결과 메시지 표시
    showResultMessage.value = true;

    // 1초 후 버튼 활성화
    Timer(const Duration(seconds: 1), () {
      isButtonDisabled.value = false;
    });

    if (gameResult.value) {
      // 성공 시 포인트 지급 및 물고기 도감에 추가
      final fish = currentFish.value;
      if (fish != null) {
        // TODO: ProfileController에 addPoints 메서드 추가 필요
        // ProfileController.to.addPoints(fish.reward);

        // 물고기 도감에 추가
        _addCaughtFish(fish.name);
      }
    }
  }

  /// 버튼 누름
  void onButtonPressed() {
    if (!isGameActive.value) return;
    isButtonPressed.value = true;
  }

  /// 버튼 뗌
  void onButtonReleased() {
    if (!isGameActive.value) return;
    isButtonPressed.value = false;
  }

  /// 게임 재시작
  void restartGame() {
    showResultMessage.value = false;
    isButtonDisabled.value = false;
    startGame();
  }

  /// 현재 물고기 정보 가져오기 (UI에서 사용)
  String getResultMessage() {
    final fish = currentFish.value;
    if (fish == null) return '';

    if (gameResult.value) {
      return '${fish.catchMessage}\n+${fish.reward}P 획득!';
    } else {
      return '낚시 실패!\n${fish.name}이(가) 도망갔습니다...';
    }
  }
}
