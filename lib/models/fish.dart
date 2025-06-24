class Fish {
  final String id;
  final String name;
  final String emoji;
  final int difficulty; // 1: 쉬움, 2: 보통, 3: 어려움, 4: 희귀, 5: 전설
  final double speed; // 물고기 이동 속도
  final double size; // 물고기 범위 크기 (0.15 ~ 0.3)
  final int reward; // 성공 시 포인트 보상 (가격/100)
  final String description;
  final String catchMessage; // 포획 메시지
  final double movementPattern; // 움직임 패턴 강도 (0.05 ~ 0.2)
  final List<int> appearanceHours; // 출현 시간 (24시간 형식, 빈 리스트면 24시간)
  final String location; // 출현 장소
  final int price; // 판매 가격 (벨)

  Fish({
    required this.id,
    required this.name,
    required this.emoji,
    required this.difficulty,
    required this.speed,
    required this.size,
    required this.reward,
    required this.description,
    required this.catchMessage,
    required this.movementPattern,
    required this.appearanceHours,
    required this.location,
    required this.price,
  });

  /// 현재 시간에 출현 가능한지 확인
  bool isAvailableNow() {
    if (appearanceHours.isEmpty) return true; // 24시간 출현
    final now = DateTime.now();
    return appearanceHours.contains(now.hour);
  }

  /// 출현 시간 텍스트
  String get appearanceTimeText {
    if (appearanceHours.isEmpty) return '24시간';
    if (appearanceHours.length == 24) return '24시간';

    // 특정 시간대 패턴 체크
    if (appearanceHours.length == 7 &&
        appearanceHours.contains(9) &&
        appearanceHours.contains(15)) {
      return '9시~16시';
    }

    if (appearanceHours.length > 12) {
      // 야간 시간대 (16시~9시)
      if (appearanceHours.contains(16) && appearanceHours.contains(8)) {
        return '16시~9시';
      }
    }

    if (appearanceHours.length == 7 &&
        appearanceHours.contains(21) &&
        appearanceHours.contains(3)) {
      return '21시~4시';
    }

    if (appearanceHours.length > 15 &&
        appearanceHours.contains(4) &&
        appearanceHours.contains(20)) {
      return '4시~21시';
    }

    // 기본적으로 첫 시간과 마지막 시간으로 범위 표시
    final sortedHours = List<int>.from(appearanceHours)..sort();
    return '${sortedHours.first}시~${sortedHours.last}시';
  }

  static List<Fish> get allFish => getDummyFishes();

  static List<Fish> getDummyFishes() {
    return [
      // === 민물고기 (동물의 숲 실제 데이터) ===

      // 쉬움 (100-500벨)
      Fish(
        id: 'tadpole',
        name: '올챙이',
        emoji: '🪱',
        difficulty: 1,
        speed: 0.15,
        size: 0.3,
        reward: 1, // 100벨/100
        price: 100,
        description: '3월~7월에 연못에서 볼 수 있는 작은 생물',
        catchMessage: '올챙이를 잡았다! 언제 커서 개구리가 될까?',
        movementPattern: 0.05,
        appearanceHours: [], // 24시간
        location: '연못',
      ),
      Fish(
        id: 'frog',
        name: '개구리',
        emoji: '🐸',
        difficulty: 1,
        speed: 0.18,
        size: 0.28,
        reward: 1, // 120벨/100
        price: 120,
        description: '5월~8월에 연못에서 볼 수 있는 양서류',
        catchMessage: '개구리를 잡았다! 폴짝폴짝!',
        movementPattern: 0.06,
        appearanceHours: [], // 24시간
        location: '연못',
      ),
      Fish(
        id: 'crucian_carp',
        name: '붕어',
        emoji: '🐟',
        difficulty: 1,
        speed: 0.2,
        size: 0.25,
        reward: 1, // 160벨/100
        price: 160,
        description: '1년 내내 강에서 볼 수 있는 흔한 물고기',
        catchMessage: '붕어를 잡았다! 붕어다! 붕어야!',
        movementPattern: 0.07,
        appearanceHours: [], // 24시간
        location: '강',
      ),
      Fish(
        id: 'bluegill',
        name: '블루길',
        emoji: '🐠',
        difficulty: 1,
        speed: 0.25,
        size: 0.24,
        reward: 1, // 180벨/100
        price: 180,
        description: '1년 내내 강에서 볼 수 있는 외래종',
        catchMessage: '블루길을 잡았다! 파란 붕어 같아!',
        movementPattern: 0.08,
        appearanceHours: [9, 10, 11, 12, 13, 14, 15], // 9시~16시
        location: '강',
      ),
      Fish(
        id: 'pale_chub',
        name: '피라미',
        emoji: '🐡',
        difficulty: 1,
        speed: 0.22,
        size: 0.26,
        reward: 2, // 200벨/100
        price: 200,
        description: '1년 내내 강에서 볼 수 있는 작은 물고기',
        catchMessage: '피라미를 잡았다! 흠흠, 조어라고도 한다지?',
        movementPattern: 0.08,
        appearanceHours: [9, 10, 11, 12, 13, 14, 15], // 9시~16시
        location: '강',
      ),

      // 보통 (200-1000벨)
      Fish(
        id: 'dace',
        name: '황어',
        emoji: '🐟',
        difficulty: 2,
        speed: 0.35,
        size: 0.22,
        reward: 2, // 240벨/100
        price: 240,
        description: '1년 내내 강에서 볼 수 있는 야행성 물고기',
        catchMessage: '황어를 잡았다! 왠지 마이너해!',
        movementPattern: 0.1,
        appearanceHours: [
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
        ], // 16시~9시
        location: '강',
      ),
      Fish(
        id: 'carp',
        name: '잉어',
        emoji: '🐠',
        difficulty: 2,
        speed: 0.32,
        size: 0.23,
        reward: 3, // 300벨/100
        price: 300,
        description: '1년 내내 연못에서 볼 수 있는 큰 물고기',
        catchMessage: '잉어를 잡았다! 엄청 멋있다!',
        movementPattern: 0.09,
        appearanceHours: [], // 24시간
        location: '연못',
      ),
      Fish(
        id: 'killifish',
        name: '송사리',
        emoji: '🐟',
        difficulty: 2,
        speed: 0.38,
        size: 0.21,
        reward: 3, // 300벨/100
        price: 300,
        description: '4월~8월에 연못에서 볼 수 있는 작은 물고기',
        catchMessage: '송사리를 잡았다! 아직 애송이로군!',
        movementPattern: 0.1,
        appearanceHours: [], // 24시간
        location: '연못',
      ),
      Fish(
        id: 'catfish',
        name: '메기',
        emoji: '😸',
        difficulty: 2,
        speed: 0.4,
        size: 0.2,
        reward: 8, // 800벨/100
        price: 800,
        description: '5월~10월에 연못에서 볼 수 있는 야행성 물고기',
        catchMessage: '메기를 잡았다! 멋진 수염이군~!',
        movementPattern: 0.11,
        appearanceHours: [
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
        ], // 16시~9시
        location: '연못',
      ),
      Fish(
        id: 'sweetfish',
        name: '은어',
        emoji: '🐠',
        difficulty: 2,
        speed: 0.42,
        size: 0.19,
        reward: 9, // 900벨/100
        price: 900,
        description: '7월~9월에 강에서 볼 수 있는 여름 물고기',
        catchMessage: '은어를 잡았다! 소금에 구워서 먹고 싶어~!!',
        movementPattern: 0.12,
        appearanceHours: [], // 24시간
        location: '강',
      ),

      // 어려움 (1000-5000벨)
      Fish(
        id: 'goldfish',
        name: '금붕어',
        emoji: '🐠',
        difficulty: 3,
        speed: 0.45,
        size: 0.18,
        reward: 13, // 1300벨/100
        price: 1300,
        description: '1년 내내 연못에서 볼 수 있는 관상어',
        catchMessage: '금붕어를 잡았다! 새빨간 꼬까옷이다!',
        movementPattern: 0.13,
        appearanceHours: [], // 24시간
        location: '연못',
      ),
      Fish(
        id: 'king_salmon',
        name: '왕연어',
        emoji: '🐟',
        difficulty: 3,
        speed: 0.5,
        size: 0.17,
        reward: 18, // 1800벨/100
        price: 1800,
        description: '9월에 하구에서 볼 수 있는 대형 연어',
        catchMessage: '예이~~~! 왕연어를 잡았다! 왕! 왕! 왕연어다~!',
        movementPattern: 0.14,
        appearanceHours: [], // 24시간
        location: '하구',
      ),
      Fish(
        id: 'soft_shelled_turtle',
        name: '자라',
        emoji: '🐢',
        difficulty: 3,
        speed: 0.48,
        size: 0.18,
        reward: 37, // 3750벨/100
        price: 3750,
        description: '8월~9월에 강에서 볼 수 있는 거북',
        catchMessage: '자라를 잡았다! 자라야, 빨리 자라라!',
        movementPattern: 0.13,
        appearanceHours: [
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
        ], // 16시~9시
        location: '강',
      ),
      Fish(
        id: 'char',
        name: '열목어',
        emoji: '🐟',
        difficulty: 3,
        speed: 0.52,
        size: 0.17,
        reward: 38, // 3800벨/100
        price: 3800,
        description: '3월~6월, 9월~11월에 절벽 위에서 볼 수 있는 귀한 물고기',
        catchMessage: '열목어를 잡았다! 과연 몇살일까?',
        movementPattern: 0.14,
        appearanceHours: [
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
        ], // 16시~9시
        location: '절벽 위',
      ),
      Fish(
        id: 'koi',
        name: '비단잉어',
        emoji: '🌈',
        difficulty: 3,
        speed: 0.46,
        size: 0.18,
        reward: 40, // 4000벨/100
        price: 4000,
        description: '1년 내내 연못에서 볼 수 있는 아름다운 잉어',
        catchMessage: '비단잉어를 잡았다! 비, 비싸보여!',
        movementPattern: 0.13,
        appearanceHours: [
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
        ], // 16시~9시
        location: '연못',
      ),

      // 희귀 (5000-10000벨)
      Fish(
        id: 'snapping_turtle',
        name: '늑대거북',
        emoji: '🐢',
        difficulty: 4,
        speed: 0.6,
        size: 0.16,
        reward: 50, // 5000벨/100
        price: 5000,
        description: '4월~10월에 강에서 볼 수 있는 위험한 거북',
        catchMessage: '늑대거북을 잡았다! 물리지 않게 조심하자',
        movementPattern: 0.16,
        appearanceHours: [21, 22, 23, 0, 1, 2, 3], // 21시~4시
        location: '강',
      ),
      Fish(
        id: 'giant_snakehead',
        name: '가물치',
        emoji: '🐍',
        difficulty: 4,
        speed: 0.65,
        size: 0.15,
        reward: 55, // 5500벨/100
        price: 5500,
        description: '6월~8월에 연못에서 볼 수 있는 포악한 물고기',
        catchMessage: '가물치를 잡았다! 머리가 뱀같이 생겼어~!',
        movementPattern: 0.17,
        appearanceHours: [9, 10, 11, 12, 13, 14, 15], // 9시~16시
        location: '연못',
      ),
      Fish(
        id: 'gar',
        name: '가아',
        emoji: '🐊',
        difficulty: 4,
        speed: 0.68,
        size: 0.15,
        reward: 60, // 6000벨/100
        price: 6000,
        description: '6월~9월에 연못에서 볼 수 있는 고대어',
        catchMessage: '가아를 잡았다! 코가 길~어!!',
        movementPattern: 0.17,
        appearanceHours: [
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
        ], // 16시~9시
        location: '연못',
      ),
      Fish(
        id: 'arowana',
        name: '아로와나',
        emoji: '🐲',
        difficulty: 4,
        speed: 0.7,
        size: 0.15,
        reward: 100, // 10000벨/100
        price: 10000,
        description: '6월~9월에 강에서 볼 수 있는 럭셔리한 물고기',
        catchMessage: '아로와나가 잡혔다! 너무 럭셔리해!!',
        movementPattern: 0.18,
        appearanceHours: [
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
        ], // 16시~9시
        location: '강',
      ),
      Fish(
        id: 'arapaima',
        name: '피라루쿠',
        emoji: '🐋',
        difficulty: 4,
        speed: 0.72,
        size: 0.15,
        reward: 100, // 10000벨/100
        price: 10000,
        description: '6월~9월에 강에서 볼 수 있는 아마존의 거대한 민물고기',
        catchMessage: '피라루쿠를 잡았다! 너무 커서 깜짝!!',
        movementPattern: 0.18,
        appearanceHours: [
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
        ], // 16시~9시
        location: '강',
      ),
      Fish(
        id: 'sturgeon',
        name: '철갑상어',
        emoji: '🐟',
        difficulty: 4,
        speed: 0.75,
        size: 0.15,
        reward: 100, // 10000벨/100
        price: 10000,
        description: '9월~3월에 하구에서 볼 수 있는 고급 물고기',
        catchMessage: '철갑상어를 잡았다! 캐비아, 캐비아!',
        movementPattern: 0.19,
        appearanceHours: [], // 24시간
        location: '하구',
      ),

      // 전설 (15000벨)
      Fish(
        id: 'golden_trout',
        name: '금송어',
        emoji: '🌟',
        difficulty: 5,
        speed: 0.8,
        size: 0.15,
        reward: 150, // 15000벨/100
        price: 15000,
        description: '3월~5월, 9월~11월에 절벽 위에서 볼 수 있는 눈부신 송어',
        catchMessage: '금송어를 잡았다! 눈부시게 아름다워!',
        movementPattern: 0.2,
        appearanceHours: [
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
        ], // 16시~9시
        location: '절벽 위',
      ),
      Fish(
        id: 'stringfish',
        name: '일본연어',
        emoji: '⭐',
        difficulty: 5,
        speed: 0.85,
        size: 0.15,
        reward: 150, // 15000벨/100
        price: 15000,
        description: '12월~3월에 절벽 위에서 볼 수 있는 전설의 거대 물고기',
        catchMessage: '우와~~~앗!! 일본연어를 잡았다! 전설의 물고기~~~!!',
        movementPattern: 0.2,
        appearanceHours: [
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
        ], // 16시~9시
        location: '절벽 위',
      ),
      Fish(
        id: 'dorado',
        name: '도라도',
        emoji: '✨',
        difficulty: 5,
        speed: 0.82,
        size: 0.15,
        reward: 150, // 15000벨/100
        price: 15000,
        description: '6월~9월에 강에서 볼 수 있는 황금빛 전설의 물고기',
        catchMessage: '우왓?! 황금물고기...?! 이게 말로만 듣던 도라도? 이섬에서도 잡히는구나~!',
        movementPattern: 0.2,
        appearanceHours: [
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
        ], // 4시~21시
        location: '강',
      ),
    ];
  }
}
