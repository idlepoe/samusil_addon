import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../models/fish.dart';
import '../../models/fish_inventory.dart';
import '../../models/title_info.dart';

import '../../utils/fish_collection_service.dart';
import '../../utils/fish_inventory_service.dart';
import '../../utils/http_service.dart';
import '../../controllers/profile_controller.dart';

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

  // 참여비 관련
  static const int FISHING_FEE = 5; // 낚시 게임 참여비
  final RxBool hasInsufficientPoints = false.obs; // 포인트 부족 상태

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

  // 물고기 인벤토리 관련
  final FishInventoryService _inventoryService = FishInventoryService.instance;
  final RxList<FishInventory> fishInventory = <FishInventory>[].obs;

  // HTTP 서비스
  final HttpService _httpService = HttpService();

  @override
  void onInit() {
    super.onInit();
    _selectRandomFish();
    _loadCaughtFish();
    _loadFishInventory();
    _checkPointsAvailable();
    _setupPointListener();
  }

  /// 프로필 포인트 변화 감지 리스너 설정
  void _setupPointListener() {
    ever(ProfileController.to.profile, (_) {
      _checkPointsAvailable();
    });
  }

  /// 포인트 부족 상태 체크
  void _checkPointsAvailable() {
    if (ProfileController.to.isInitialized.value) {
      hasInsufficientPoints.value =
          ProfileController.to.currentPoint < FISHING_FEE;
    } else {
      // 프로필이 초기화되지 않았으면 잠시 후 다시 체크
      Future.delayed(const Duration(milliseconds: 500), _checkPointsAvailable);
    }
  }

  /// 잡은 물고기 목록 로드
  Future<void> _loadCaughtFish() async {
    final caught = await _collectionService.getCaughtFish();
    caughtFish.value = caught;
  }

  /// 물고기 인벤토리 로드
  Future<void> _loadFishInventory() async {
    try {
      final inventory = await _inventoryService.getAllInventory();
      fishInventory.value = inventory;
    } catch (e) {
      logger.e('인벤토리 로드 중 오류: $e');
    }
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

  /// 랜덤 물고기 선택 (오늘의 location과 현재 시간에 출현 가능한 물고기만)
  void _selectRandomFish() {
    final random = Random();

    // 오늘 출현 가능한 물고기만 필터링 (요일별 location + 시간 조건)
    final todayAvailable = Fish.getTodayAvailableFish();

    if (todayAvailable.isEmpty) {
      // 출현 가능한 물고기가 없으면 오늘의 location에서만 선택
      final todayLocation = Fish.getTodayLocation();
      final locationFish =
          availableFishes
              .where((fish) => fish.location == todayLocation)
              .toList();

      if (locationFish.isNotEmpty) {
        currentFish.value = locationFish[random.nextInt(locationFish.length)];
      } else {
        // 최후의 수단으로 전체에서 선택
        currentFish.value =
            availableFishes[random.nextInt(availableFishes.length)];
      }
    } else {
      currentFish.value = todayAvailable[random.nextInt(todayAvailable.length)];
    }
  }

  /// 게임 시작
  void startGame() {
    if (isGameActive.value) return;

    // 포인트 부족 시 게임 시작 차단
    if (hasInsufficientPoints.value) {
      Get.snackbar(
        '포인트 부족',
        '낚시 게임 참여비 ${FISHING_FEE}P가 부족합니다.\n현재 포인트: ${ProfileController.to.currentPointRounded}P',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.warning, color: Colors.white),
      );
      return;
    }

    // 낙관적 업데이트: 즉시 포인트 차감 (로컬)
    _deductPointsOptimistically();

    // 백그라운드에서 서버에 참여비 차감 요청
    _payFishingFeeToServer();

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

  /// 낙관적 업데이트로 포인트 차감 (로컬)
  void _deductPointsOptimistically() {
    final currentProfile = ProfileController.to.profile.value;
    final updatedProfile = currentProfile.copyWith(
      point: currentProfile.point - FISHING_FEE,
    );
    ProfileController.to.profile.value = updatedProfile;

    // 포인트 부족 상태 다시 체크
    _checkPointsAvailable();

    logger.i('낙관적 업데이트: 참여비 ${FISHING_FEE}P 차감');
  }

  /// 서버에 참여비 차감 요청
  Future<void> _payFishingFeeToServer() async {
    try {
      final response = await _httpService.payFishingFee(feeAmount: FISHING_FEE);

      if (response.success) {
        logger.i('서버 참여비 차감 성공');
      } else {
        logger.w('서버 참여비 차감 실패: ${response.error}');
        // 실패 시에도 게임은 계속 진행 (낙관적 업데이트)
      }
    } catch (e) {
      logger.e('참여비 차감 요청 중 오류: $e');
      // 에러 발생 시에도 게임은 계속 진행
    }
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
      // 성공 시 물고기 포획 처리
      final fish = currentFish.value;
      if (fish != null) {
        _processFishCatch(fish);
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

    // 포인트 상태 다시 체크
    _checkPointsAvailable();

    startGame();
  }

  /// 물고기 포획 처리 (로컬)
  Future<void> _processFishCatch(Fish fish) async {
    try {
      // 로컬 도감에 추가
      await _addCaughtFish(fish.name);

      // 로컬 인벤토리에 추가 (SharedPreferences 사용)
      await _addFishToInventory(fish);

      // 칭호 해금 조건 체크
      await _checkTitleUnlockConditions();

      logger.i('물고기 포획 성공: ${fish.name} (포인트는 판매 시 지급)');
    } catch (e) {
      logger.e('물고기 포획 처리 중 오류: $e');
    }
  }

  /// 로컬 인벤토리에 물고기 추가
  Future<void> _addFishToInventory(Fish fish) async {
    try {
      await _inventoryService.addFish(fish.id, fish.name);
      await _loadFishInventory(); // 인벤토리 새로고침
      logger.i('인벤토리에 물고기 추가: ${fish.name}');
    } catch (e) {
      logger.e('인벤토리 추가 중 오류: $e');
    }
  }

  /// 칭호 해금 조건 체크
  Future<void> _checkTitleUnlockConditions() async {
    try {
      final caughtCount = caughtFish.length;

      // 첫 물고기 칭호
      if (caughtCount == 1) {
        await _unlockTitle('first_fish');
      }

      // 낚시 초보 칭호
      if (caughtCount == 5) {
        await _unlockTitle('fishing_novice');
      }

      // 전설의 어부 칭호 (모든 물고기 포획)
      if (caughtCount >= Fish.allFish.length) {
        await _unlockTitle('legend_fisher');
      }

      // 위치별 칭호 체크
      await _checkLocationBasedTitles();
    } catch (e) {
      logger.e('칭호 해금 조건 체크 중 오류: $e');
    }
  }

  /// 위치별 칭호 체크
  Future<void> _checkLocationBasedTitles() async {
    final pondFish =
        Fish.allFish
            .where((f) => f.location == '연못')
            .map((f) => f.name)
            .toSet();
    final riverFish =
        Fish.allFish.where((f) => f.location == '강').map((f) => f.name).toSet();
    final seaFish =
        Fish.allFish
            .where((f) => f.location == '바다')
            .map((f) => f.name)
            .toSet();
    final deepSeaFish =
        Fish.allFish
            .where((f) => f.location == '바다(잠수)')
            .map((f) => f.name)
            .toSet();

    final caughtFishSet = caughtFish.value;

    // 연못 탐험가 (연못 물고기 3종)
    if (pondFish.intersection(caughtFishSet).length >= 3) {
      await _unlockTitle('pond_explorer');
    }

    // 강의 주인 (강 물고기 5종)
    if (riverFish.intersection(caughtFishSet).length >= 5) {
      await _unlockTitle('river_master');
    }

    // 바다 사냥꾼 (바다 물고기 10종)
    if (seaFish.intersection(caughtFishSet).length >= 10) {
      await _unlockTitle('sea_hunter');
    }

    // 심해 잠수부 (바다(잠수) 물고기 5종)
    if (deepSeaFish.intersection(caughtFishSet).length >= 5) {
      await _unlockTitle('deep_sea_diver');
    }

    // 희귀종 수집가 (희귀 등급 물고기 3종)
    final rareFish =
        Fish.allFish.where((f) => f.difficulty == 4).map((f) => f.name).toSet();
    if (rareFish.intersection(caughtFishSet).length >= 3) {
      await _unlockTitle('rare_collector');
    }
  }

  /// 칭호 해금 요청
  Future<void> _unlockTitle(String titleId) async {
    try {
      final titleInfo = TitleData.getTitleById(titleId);
      if (titleInfo == null) return;

      final response = await _httpService.unlockTitle(
        titleId: titleId,
        titleName: titleInfo.name,
        description: titleInfo.description,
      );

      if (response.success) {
        logger.i('칭호 해금 성공: ${titleInfo.name}');
        // TODO: 칭호 해금 알림 표시
      }
    } catch (e) {
      logger.e('칭호 해금 요청 중 오류: $e');
    }
  }

  /// 물고기 판매 (공통 포인트 API 사용)
  Future<void> sellFish(Fish fish, int sellCount) async {
    try {
      // 로컬 인벤토리에서 수량 확인
      final inventory = await _inventoryService.getFishInventory(fish.id);
      if (inventory == null || inventory.currentCount < sellCount) {
        throw Exception('보유량이 부족합니다.');
      }

      final totalPoints = sellCount * fish.reward;

      // 서버에 포인트 증가 요청 (공통 API 사용)
      final response = await _httpService.updatePoints(
        pointsChange: totalPoints.toDouble(),
        actionType: 'fish_sale',
        description: '물고기 판매: ${fish.name} x$sellCount',
        metadata: {
          'fishId': fish.id,
          'fishName': fish.name,
          'sellCount': sellCount,
          'pointPerFish': fish.reward,
          'totalPoints': totalPoints,
        },
      );

      if (response.success) {
        // 로컬 인벤토리 업데이트
        await _inventoryService.sellFish(fish.id, sellCount);
        await _loadFishInventory();

        // 포인트 백만장자 칭호 체크 (판매로 1000P 달성)
        // TODO: 총 판매 포인트 추적 기능 추가 필요

        logger.i('물고기 판매 성공: ${fish.name} ${sellCount}마리, +${totalPoints}P');

        // 성공 메시지 표시
        Get.snackbar(
          '판매 완료',
          '${fish.name} ${sellCount}마리를 ${totalPoints}P에 판매했습니다!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception(response.error ?? '판매에 실패했습니다.');
      }
    } catch (e) {
      logger.e('물고기 판매 중 오류: $e');
      Get.snackbar(
        '판매 실패',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// 특정 물고기의 현재 보유 수량 조회
  int getCurrentFishCount(String fishId) {
    final inventory = fishInventory.firstWhere(
      (fish) => fish.fishId == fishId,
      orElse:
          () => FishInventory(
            fishId: fishId,
            fishName: '',
            caughtCount: 0,
            currentCount: 0,
            lastCaughtAt: DateTime.now(),
          ),
    );
    return inventory.currentCount;
  }

  /// 현재 물고기 정보 가져오기 (UI에서 사용)
  String getResultMessage() {
    final fish = currentFish.value;
    if (fish == null) return '';

    if (gameResult.value) {
      return '${fish.catchMessage}\n${fish.name}을(를) 획득했습니다!\n(판매 시 ${fish.reward}P 획득 가능)\n(참여비: -${FISHING_FEE}P)';
    } else {
      return '낚시 실패!\n${fish.name}이(가) 도망갔습니다...\n(참여비: -${FISHING_FEE}P)';
    }
  }

  /// 포인트 부족 상태 확인
  bool get canPlayGame => !hasInsufficientPoints.value;

  /// 포인트 부족 메시지
  String get insufficientPointsMessage =>
      '포인트가 부족합니다!\n참여비: ${FISHING_FEE}P\n현재 포인트: ${ProfileController.to.currentPointRounded}P';
}
