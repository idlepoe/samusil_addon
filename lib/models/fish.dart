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

      // === 바닷물고기 (동물의 숲 실제 데이터) ===

      // 쉬움 (150-650벨)
      Fish(
        id: 'horse_mackerel',
        name: '전갱이',
        emoji: '🐟',
        difficulty: 1,
        speed: 0.2,
        size: 0.25,
        reward: 1, // 150벨/100
        price: 150,
        description: '1년 내내 바다에서 볼 수 있는 흔한 물고기',
        catchMessage: '전갱이를 잡았다! 과연 맛은 어떨는지?',
        movementPattern: 0.07,
        appearanceHours: [], // 24시간
        location: '바다',
      ),
      Fish(
        id: 'anchovy',
        name: '멸치',
        emoji: '🐠',
        difficulty: 1,
        speed: 0.25,
        size: 0.24,
        reward: 2, // 200벨/100
        price: 200,
        description: '1년 내내 바다에서 볼 수 있는 작은 물고기',
        catchMessage: '멸치를 잡았다! 생멸치는 별로 안 짜네!',
        movementPattern: 0.08,
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
        location: '바다',
      ),
      Fish(
        id: 'puffer_fish',
        name: '가시복',
        emoji: '🐡',
        difficulty: 1,
        speed: 0.22,
        size: 0.26,
        reward: 2, // 250벨/100
        price: 250,
        description: '7월~9월에 바다에서 볼 수 있는 가시 물고기',
        catchMessage: '가시복을 잡았다! 아얏~!',
        movementPattern: 0.08,
        appearanceHours: [], // 24시간
        location: '바다',
      ),
      Fish(
        id: 'zebra_turkeyfish',
        name: '쏠배감펭',
        emoji: '🐠',
        difficulty: 1,
        speed: 0.28,
        size: 0.22,
        reward: 5, // 500벨/100
        price: 500,
        description: '4월~11월에 바다에서 볼 수 있는 독가시 물고기',
        catchMessage: '쏠배감팽을 잡았다! 예쁜 가시 안에는 독이 있어서 만지면 안 돼!',
        movementPattern: 0.09,
        appearanceHours: [], // 24시간
        location: '바다',
      ),
      Fish(
        id: 'clown_fish',
        name: '흰동가리',
        emoji: '🐠',
        difficulty: 1,
        speed: 0.26,
        size: 0.23,
        reward: 6, // 650벨/100
        price: 650,
        description: '4월~9월에 바다에서 볼 수 있는 귀여운 물고기',
        catchMessage: '흰동가리를 잡았다! 말미잘과 단짝!',
        movementPattern: 0.09,
        appearanceHours: [], // 24시간
        location: '바다',
      ),

      // 보통 (300-1100벨)
      Fish(
        id: 'dab',
        name: '가자미',
        emoji: '🐟',
        difficulty: 2,
        speed: 0.35,
        size: 0.22,
        reward: 3, // 300벨/100
        price: 300,
        description: '10월~4월에 바다에서 볼 수 있는 납작한 물고기',
        catchMessage: '가자미를 잡았다! 봤어? 내 화려한 낚시 솜씨!',
        movementPattern: 0.1,
        appearanceHours: [], // 24시간
        location: '바다',
      ),
      Fish(
        id: 'squid',
        name: '오징어',
        emoji: '🦑',
        difficulty: 2,
        speed: 0.4,
        size: 0.2,
        reward: 5, // 500벨/100
        price: 500,
        description: '12월~8월에 바다에서 볼 수 있는 연체동물',
        catchMessage: '오징어를 잡았다! 오징어야, 잘 부탁해',
        movementPattern: 0.11,
        appearanceHours: [], // 24시간
        location: '바다',
      ),
      Fish(
        id: 'ribbon_eel',
        name: '리본장어',
        emoji: '🐍',
        difficulty: 2,
        speed: 0.42,
        size: 0.19,
        reward: 6, // 600벨/100
        price: 600,
        description: '6월~10월에 바다에서 볼 수 있는 리본같은 장어',
        catchMessage: '리본장어를 잡았다! 모래 속에서 빼꼼!',
        movementPattern: 0.12,
        appearanceHours: [], // 24시간
        location: '바다',
      ),
      Fish(
        id: 'olive_flounder',
        name: '넙치',
        emoji: '🐟',
        difficulty: 2,
        speed: 0.38,
        size: 0.21,
        reward: 8, // 800벨/100
        price: 800,
        description: '1년 내내 바다에서 볼 수 있는 큰 가자미',
        catchMessage: '가자미를 잡았다! 그런데, 응? 응? 이건 잘 보니 넙치...? 넙치야?',
        movementPattern: 0.1,
        appearanceHours: [], // 24시간
        location: '바다',
      ),
      Fish(
        id: 'surgeonfish',
        name: '블루탱',
        emoji: '🐠',
        difficulty: 2,
        speed: 0.4,
        size: 0.2,
        reward: 10, // 1000벨/100
        price: 1000,
        description: '4월~9월에 바다에서 볼 수 있는 코발트블루 물고기',
        catchMessage: '블루탱을 잡았다! 코발트블루의 색이 너무 예뻐!',
        movementPattern: 0.11,
        appearanceHours: [], // 24시간
        location: '바다',
      ),
      Fish(
        id: 'butterfly_fish',
        name: '나비고기',
        emoji: '🐠',
        difficulty: 2,
        speed: 0.42,
        size: 0.19,
        reward: 10, // 1000벨/100
        price: 1000,
        description: '4월~9월에 바다에서 볼 수 있는 나비같은 물고기',
        catchMessage: '나비고기를 잡았다! 나풀나풀 나비처럼 헤엄치는 물고기!',
        movementPattern: 0.12,
        appearanceHours: [], // 24시간
        location: '바다',
      ),
      Fish(
        id: 'sea_butterfly',
        name: '클리오네',
        emoji: '🪼',
        difficulty: 2,
        speed: 0.38,
        size: 0.21,
        reward: 10, // 1000벨/100
        price: 1000,
        description: '12월~3월에 바다에서 볼 수 있는 바다천사',
        catchMessage: '클리오네를 잡았다! 천사가 된 기분이야!',
        movementPattern: 0.1,
        appearanceHours: [], // 24시간
        location: '바다',
      ),
      Fish(
        id: 'sea_horse',
        name: '해마',
        emoji: '🐴',
        difficulty: 2,
        speed: 0.35,
        size: 0.22,
        reward: 11, // 1100벨/100
        price: 1100,
        description: '4월~11월에 바다에서 볼 수 있는 아기 드래곤',
        catchMessage: '해마를 잡았다! 아기 드래곤!',
        movementPattern: 0.1,
        appearanceHours: [], // 24시간
        location: '바다',
      ),

      // 어려움 (1500-5000벨)
      Fish(
        id: 'suckerfish',
        name: '빨판상어',
        emoji: '🦈',
        difficulty: 3,
        speed: 0.45,
        size: 0.18,
        reward: 15, // 1500벨/100
        price: 1500,
        description: '6월~9월에 바다에서 볼 수 있는 상어류',
        catchMessage: '빨판상어를 잡았다! 근데 상어가 아니구나!',
        movementPattern: 0.13,
        appearanceHours: [], // 24시간
        location: '바다',
      ),
      Fish(
        id: 'moray_eel',
        name: '곰치',
        emoji: '🐍',
        difficulty: 3,
        speed: 0.5,
        size: 0.17,
        reward: 20, // 2000벨/100
        price: 2000,
        description: '8월~10월에 바다에서 볼 수 있는 위험한 장어',
        catchMessage: '곰치를 잡았다! 물리면 큰일 나!',
        movementPattern: 0.14,
        appearanceHours: [], // 24시간
        location: '바다',
      ),
      Fish(
        id: 'football_fish',
        name: '초롱아귀',
        emoji: '🐟',
        difficulty: 3,
        speed: 0.52,
        size: 0.17,
        reward: 25, // 2500벨/100
        price: 2500,
        description: '11월~3월에 바다에서 볼 수 있는 심해어',
        catchMessage: '초롱아귀를 잡았다! 어인 일로 깊은 바다 속에서 이런 곳까지!',
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
        location: '바다',
      ),
      Fish(
        id: 'red_snapper',
        name: '도미',
        emoji: '🐟',
        difficulty: 3,
        speed: 0.48,
        size: 0.18,
        reward: 30, // 3000벨/100
        price: 3000,
        description: '1년 내내 바다에서 볼 수 있는 붉은 생선',
        catchMessage: '도미를 잡았다! 레는 어디로 갔지?',
        movementPattern: 0.13,
        appearanceHours: [], // 24시간
        location: '바다',
      ),
      Fish(
        id: 'ray',
        name: '가오리',
        emoji: '🐟',
        difficulty: 3,
        speed: 0.5,
        size: 0.17,
        reward: 30, // 3000벨/100
        price: 3000,
        description: '8월~11월에 바다에서 볼 수 있는 납작한 물고기',
        catchMessage: '가오리를 잡았다! 아싸 가오리!',
        movementPattern: 0.14,
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
        location: '바다',
      ),
      Fish(
        id: 'ocean_sunfish',
        name: '개복치',
        emoji: '🐟',
        difficulty: 3,
        speed: 0.46,
        size: 0.18,
        reward: 40, // 4000벨/100
        price: 4000,
        description: '7월~9월에 바다에서 볼 수 있는 거대한 물고기',
        catchMessage: '개복치를 잡았다! 와! 개복치다!',
        movementPattern: 0.13,
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
        location: '바다',
      ),
      Fish(
        id: 'giant_trevally',
        name: '무명갈전갱이',
        emoji: '🐟',
        difficulty: 3,
        speed: 0.52,
        size: 0.17,
        reward: 45, // 4500벨/100
        price: 4500,
        description: '5월~10월에 부둣가에서 볼 수 있는 험악한 물고기',
        catchMessage: '무명갈전갱이를 잡았다! 얼굴이 험악한데?',
        movementPattern: 0.14,
        appearanceHours: [], // 24시간
        location: '부둣가',
      ),
      Fish(
        id: 'blowfish',
        name: '복어',
        emoji: '🐡',
        difficulty: 3,
        speed: 0.48,
        size: 0.18,
        reward: 50, // 5000벨/100
        price: 5000,
        description: '11월~2월에 바다에서 볼 수 있는 독성 물고기',
        catchMessage: '복어를 잡았다! 먹을 땐 전문가와 상담하세요!',
        movementPattern: 0.13,
        appearanceHours: [21, 22, 23, 0, 1, 2, 3], // 21시~4시
        location: '바다',
      ),
      Fish(
        id: 'barred_knifejaw',
        name: '돌돔',
        emoji: '🐟',
        difficulty: 3,
        speed: 0.5,
        size: 0.17,
        reward: 50, // 5000벨/100
        price: 5000,
        description: '3월~11월에 바다에서 볼 수 있는 바다의 왕자',
        catchMessage: '돌돔을 잡았다! 거친 바다의 왕자!',
        movementPattern: 0.14,
        appearanceHours: [], // 24시간
        location: '바다',
      ),

      // 희귀 (6000-13000벨)
      Fish(
        id: 'mahi_mahi',
        name: '만새기',
        emoji: '🐟',
        difficulty: 4,
        speed: 0.6,
        size: 0.16,
        reward: 60, // 6000벨/100
        price: 6000,
        description: '5월~10월에 부둣가에서 볼 수 있는 마히마히',
        catchMessage: '만새기를 잡았다! 마히마히라는 이름도 있어!',
        movementPattern: 0.16,
        appearanceHours: [], // 24시간
        location: '부둣가',
      ),
      Fish(
        id: 'tuna',
        name: '다랑어',
        emoji: '🐟',
        difficulty: 4,
        speed: 0.65,
        size: 0.15,
        reward: 70, // 7000벨/100
        price: 7000,
        description: '11월~4월에 부둣가에서 볼 수 있는 빠른 물고기',
        catchMessage: '다랑어를 잡았다! 헤엄치다 지쳤나?',
        movementPattern: 0.17,
        appearanceHours: [], // 24시간
        location: '부둣가',
      ),
      Fish(
        id: 'hammerhead_shark',
        name: '귀상어',
        emoji: '🦈',
        difficulty: 4,
        speed: 0.68,
        size: 0.15,
        reward: 80, // 8000벨/100
        price: 8000,
        description: '6월~9월에 바다에서 볼 수 있는 망치머리 상어',
        catchMessage: '귀상어를 잡았다! 머리가 망치같아!',
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
        location: '바다',
      ),
      Fish(
        id: 'oarfish',
        name: '산갈치',
        emoji: '🐟',
        difficulty: 4,
        speed: 0.7,
        size: 0.15,
        reward: 90, // 9000벨/100
        price: 9000,
        description: '12월~5월에 바다에서 볼 수 있는 긴 물고기',
        catchMessage: '산갈치를 잡았다! 여긴 바다인데?',
        movementPattern: 0.18,
        appearanceHours: [], // 24시간
        location: '바다',
      ),
      Fish(
        id: 'blue_marlin',
        name: '청새치',
        emoji: '🐟',
        difficulty: 4,
        speed: 0.72,
        size: 0.15,
        reward: 100, // 10000벨/100
        price: 10000,
        description: '7월~9월, 11월~4월에 부둣가에서 볼 수 있는 창 물고기',
        catchMessage: '청새치를 단숨에 잡았다! 이즘이야 뭐!',
        movementPattern: 0.18,
        appearanceHours: [], // 24시간
        location: '부둣가',
      ),
      Fish(
        id: 'napoleonfish',
        name: '나폴레옹피시',
        emoji: '🐟',
        difficulty: 4,
        speed: 0.75,
        size: 0.15,
        reward: 100, // 10000벨/100
        price: 10000,
        description: '7월~8월에 바다에서 볼 수 있는 모자 물고기',
        catchMessage: '나폴레옹피시를 잡았다! 머리 위에 모자가 멋진걸!',
        movementPattern: 0.19,
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
        location: '바다',
      ),
      Fish(
        id: 'saw_shark',
        name: '톱상어',
        emoji: '🦈',
        difficulty: 4,
        speed: 0.78,
        size: 0.15,
        reward: 120, // 12000벨/100
        price: 12000,
        description: '6월~9월에 바다에서 볼 수 있는 톱날 상어',
        catchMessage: '톱상어를 잡았다! 낚싯줄은 끊지 마!',
        movementPattern: 0.19,
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
        location: '바다',
      ),
      Fish(
        id: 'whale_shark',
        name: '고래상어',
        emoji: '🐋',
        difficulty: 4,
        speed: 0.8,
        size: 0.15,
        reward: 130, // 13000벨/100
        price: 13000,
        description: '6월~9월에 바다에서 볼 수 있는 거대한 상어',
        catchMessage: '오옷~! 고래상어를 잡았다! 엄청 크다!',
        movementPattern: 0.2,
        appearanceHours: [], // 24시간
        location: '바다',
      ),

      // 전설 (15000벨)
      Fish(
        id: 'great_white_shark',
        name: '상어',
        emoji: '🦈',
        difficulty: 5,
        speed: 0.85,
        size: 0.15,
        reward: 150, // 15000벨/100
        price: 15000,
        description: '6월~9월에 바다에서 볼 수 있는 백상아리',
        catchMessage: '상어를 잡았다! 다이너마이트급이야!',
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
        location: '바다',
      ),
      Fish(
        id: 'barreleye',
        name: '데메니기스',
        emoji: '👁️',
        difficulty: 5,
        speed: 0.82,
        size: 0.15,
        reward: 150, // 15000벨/100
        price: 15000,
        description: '1년 내내 바다에서 볼 수 있는 투명머리 물고기',
        catchMessage: '데메니기스를 잡았다! 와~ 머리가 투명해~!',
        movementPattern: 0.2,
        appearanceHours: [21, 22, 23, 0, 1, 2, 3], // 21시~4시
        location: '바다',
      ),
      Fish(
        id: 'coelacanth',
        name: '실러캔스',
        emoji: '🐟',
        difficulty: 5,
        speed: 0.8,
        size: 0.15,
        reward: 150, // 15000벨/100
        price: 15000,
        description: '비 오는 날에만 바다에서 볼 수 있는 살아있는 화석',
        catchMessage: '꺄아! 실러캔스를 잡았다! 이런 게 있었구나!',
        movementPattern: 0.2,
        appearanceHours: [], // 24시간 (단, 비 오는 날만)
        location: '바다',
      ),

      // 추가 바다 물고기
      Fish(
        id: 'sea_bass',
        name: '농어',
        emoji: '🐟',
        difficulty: 2,
        speed: 0.3,
        size: 0.23,
        reward: 4, // 400벨/100
        price: 400,
        description: '1년 내내 바다에서 볼 수 있는 흔한 대형 물고기',
        catchMessage: '농어를 잡았다! 안농, 농어야~!',
        movementPattern: 0.09,
        appearanceHours: [], // 24시간
        location: '바다',
      ),

      // === 해산물 (동물의 숲 실제 데이터) ===

      // 쉬움 (500-900벨)
      Fish(
        id: 'sea_cucumber',
        name: '해삼',
        emoji: '🥒',
        difficulty: 1,
        speed: 0.2,
        size: 0.25,
        reward: 5, // 500벨/100
        price: 500,
        description: '11월~4월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '해삼을 잡았다! 오독오독 독특한 식감!',
        movementPattern: 0.07,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'sea_star',
        name: '불가사리',
        emoji: '⭐',
        difficulty: 1,
        speed: 0.22,
        size: 0.26,
        reward: 5, // 500벨/100
        price: 500,
        description: '1년 내내 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '불가사리를 잡았다! 바다의 별님!',
        movementPattern: 0.07,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'sea_anemone',
        name: '말미잘',
        emoji: '🌺',
        difficulty: 1,
        speed: 0.18,
        size: 0.28,
        reward: 5, // 500벨/100
        price: 500,
        description: '1년 내내 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '말미잘을 잡았다! 촉수에 독이 있다구~',
        movementPattern: 0.06,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'seaweed',
        name: '미역',
        emoji: '🌿',
        difficulty: 1,
        speed: 0.15,
        size: 0.3,
        reward: 6, // 600벨/100
        price: 600,
        description: '10월~7월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '미역을 건졌다! 미네랄이 풍부해!',
        movementPattern: 0.05,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'moon_jellyfish',
        name: '보름달물해파리',
        emoji: '🪼',
        difficulty: 1,
        speed: 0.25,
        size: 0.24,
        reward: 6, // 600벨/100
        price: 600,
        description: '7월~9월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '보름달물해파리를 잡았다! 아주 조금 독이 있대!',
        movementPattern: 0.08,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'sea_slug',
        name: '갯민숭달팽이',
        emoji: '🐌',
        difficulty: 1,
        speed: 0.28,
        size: 0.22,
        reward: 6, // 600벨/100
        price: 600,
        description: '1년 내내 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '갯민숭달팽이를 잡았다! 와우~ 컬러풀!',
        movementPattern: 0.09,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'acorn_barnacle',
        name: '따개비',
        emoji: '🦪',
        difficulty: 1,
        speed: 0.2,
        size: 0.25,
        reward: 6, // 600벨/100
        price: 600,
        description: '1년 내내 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '따개비를 땄다! 사실은 새우의 친척이라구~',
        movementPattern: 0.07,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'flatworm',
        name: '납작벌레',
        emoji: '🪱',
        difficulty: 1,
        speed: 0.3,
        size: 0.2,
        reward: 7, // 700벨/100
        price: 700,
        description: '8월~9월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '납작벌레를 잡았다! 우와~ 진짜 납작해~',
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
        location: '바다(잠수)',
      ),
      Fish(
        id: 'sea_grapes',
        name: '바다포도',
        emoji: '🍇',
        difficulty: 1,
        speed: 0.26,
        size: 0.23,
        reward: 9, // 900벨/100
        price: 900,
        description: '6월~9월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '바다포도를 땄다! 톡톡 터지는 식감에 중독되겠어!',
        movementPattern: 0.08,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),

      // 보통 (1000-1900벨)
      Fish(
        id: 'whelk',
        name: '수랑',
        emoji: '🐚',
        difficulty: 2,
        speed: 0.35,
        size: 0.22,
        reward: 10, // 1000벨/100
        price: 1000,
        description: '1년 내내 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '수랑을 잡았다! 어디서 많이 본 생김새인데?',
        movementPattern: 0.1,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'turban_shell',
        name: '소라',
        emoji: '🐚',
        difficulty: 2,
        speed: 0.38,
        size: 0.21,
        reward: 10, // 1000벨/100
        price: 1000,
        description: '3월~5월, 9월~12월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '소라를 잡았다! 뚜껑이 붙어 있는 고둥이랍니다!',
        movementPattern: 0.1,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'oyster',
        name: '굴',
        emoji: '🦪',
        difficulty: 2,
        speed: 0.32,
        size: 0.23,
        reward: 11, // 1100벨/100
        price: 1100,
        description: '9월~2월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '굴을 땄다! 영양 만점 바다의 우유!',
        movementPattern: 0.09,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'spotted_garden_eel',
        name: '가든일',
        emoji: '🐍',
        difficulty: 2,
        speed: 0.4,
        size: 0.2,
        reward: 11, // 1100벨/100
        price: 1100,
        description: '5월~10월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '가든일을 잡았다! 구멍에서 쏙 나와 "안녕하세요!"',
        movementPattern: 0.11,
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
        location: '바다(잠수)',
      ),
      Fish(
        id: 'scallop',
        name: '가리비',
        emoji: '🦪',
        difficulty: 2,
        speed: 0.36,
        size: 0.22,
        reward: 12, // 1200벨/100
        price: 1200,
        description: '1년 내내 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '가리비를 잡았다! 관자가 무지 커!',
        movementPattern: 0.1,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'octopus',
        name: '문어',
        emoji: '🐙',
        difficulty: 2,
        speed: 0.42,
        size: 0.19,
        reward: 12, // 1200벨/100
        price: 1200,
        description: '1년 내내 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '문어를 잡았다! 갑자기 뿜는 먹물을 조심해!',
        movementPattern: 0.12,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'firefly_squid',
        name: '반딧불오징어',
        emoji: '🦑',
        difficulty: 2,
        speed: 0.44,
        size: 0.18,
        reward: 14, // 1400벨/100
        price: 1400,
        description: '3월~6월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '반딧불오징어를 잡았다! 신비하게 빛나고 있어~',
        movementPattern: 0.12,
        appearanceHours: [21, 22, 23, 0, 1, 2, 3], // 21시~4시
        location: '바다(잠수)',
      ),
      Fish(
        id: 'sweet_shrimp',
        name: '북쪽분홍새우',
        emoji: '🦐',
        difficulty: 2,
        speed: 0.46,
        size: 0.17,
        reward: 14, // 1400벨/100
        price: 1400,
        description: '9월~2월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '북쪽분홍새우를 잡았다! 부끄러워서 온몸이 빨개졌나?',
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
        location: '바다(잠수)',
      ),
      Fish(
        id: 'mussel',
        name: '지중해담치',
        emoji: '🦪',
        difficulty: 2,
        speed: 0.38,
        size: 0.21,
        reward: 15, // 1500벨/100
        price: 1500,
        description: '6월~12월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '지중해담치를 잡았다! 음~ 파에야 먹고 싶어!',
        movementPattern: 0.1,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'sea_pineapple',
        name: '멍게',
        emoji: '🍍',
        difficulty: 2,
        speed: 0.4,
        size: 0.2,
        reward: 15, // 1500벨/100
        price: 1500,
        description: '4월~8월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '멍게를 잡았다! 삐죽삐죽 험상궂게 생겼어!',
        movementPattern: 0.11,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'sea_urchin',
        name: '성게',
        emoji: '🔘',
        difficulty: 2,
        speed: 0.35,
        size: 0.22,
        reward: 17, // 1700벨/100
        price: 1700,
        description: '5월~9월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '성게를 잡았다! 맛있는 것에는 가시가 있기 마련!',
        movementPattern: 0.1,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'chambered_nautilus',
        name: '앵무조개',
        emoji: '🐚',
        difficulty: 2,
        speed: 0.42,
        size: 0.19,
        reward: 18, // 1800벨/100
        price: 1800,
        description: '3월~6월, 9월~11월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '앵무조개를 잡았다! 문어와 오징어의 친척이야!',
        movementPattern: 0.12,
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
        location: '바다(잠수)',
      ),
      Fish(
        id: 'dungeness_crab',
        name: '던지니스크랩',
        emoji: '🦀',
        difficulty: 2,
        speed: 0.45,
        size: 0.18,
        reward: 19, // 1900벨/100
        price: 1900,
        description: '11월~5월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '던지니스크랩을 잡았다! 대짜은행게라고도 불린데!',
        movementPattern: 0.13,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),

      // 어려움 (2000-2800벨)
      Fish(
        id: 'slate_pencil_urchin',
        name: '연필성게',
        emoji: '✏️',
        difficulty: 3,
        speed: 0.48,
        size: 0.18,
        reward: 20, // 2000벨/100
        price: 2000,
        description: '5월~9월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '연필성게를 잡았다! 가시가 두껍고 뭉툭해!',
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
        location: '바다(잠수)',
      ),
      Fish(
        id: 'abalone',
        name: '전복',
        emoji: '🐚',
        difficulty: 3,
        speed: 0.5,
        size: 0.17,
        reward: 20, // 2000벨/100
        price: 2000,
        description: '6월~1월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '전복을 잡았다! 고급 식재료야!',
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
        location: '바다(잠수)',
      ),
      Fish(
        id: 'gazami_crab',
        name: '꽃게',
        emoji: '🦀',
        difficulty: 3,
        speed: 0.52,
        size: 0.17,
        reward: 22, // 2200벨/100
        price: 2200,
        description: '6월~11월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '꽃게를 잡았다! 어디어디? 어디가 예쁘길래 꽃이래?',
        movementPattern: 0.14,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'mantis_shrimp',
        name: '갯가재',
        emoji: '🦐',
        difficulty: 3,
        speed: 0.55,
        size: 0.16,
        reward: 25, // 2500벨/100
        price: 2500,
        description: '1년 내내 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '갯가재를 잡았다! 펀치의 힘이 장난 아냐!',
        movementPattern: 0.15,
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
        location: '바다(잠수)',
      ),
      Fish(
        id: 'horseshoe_crab',
        name: '투구게',
        emoji: '🦀',
        difficulty: 3,
        speed: 0.48,
        size: 0.18,
        reward: 25, // 2500벨/100
        price: 2500,
        description: '7월~9월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '투구게를 잡았다! 살아있는 화석이야!',
        movementPattern: 0.13,
        appearanceHours: [21, 22, 23, 0, 1, 2, 3], // 21시~4시
        location: '바다(잠수)',
      ),
      Fish(
        id: 'pearl_oyster',
        name: '진주조개',
        emoji: '🦪',
        difficulty: 3,
        speed: 0.46,
        size: 0.18,
        reward: 28, // 2800벨/100
        price: 2800,
        description: '1년 내내 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '진주조개를 잡았다! 진주를 만드는 조개야!',
        movementPattern: 0.13,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),

      // 희귀 (3000-6000벨)
      Fish(
        id: 'tiger_prawn',
        name: '보리새우',
        emoji: '🦐',
        difficulty: 4,
        speed: 0.6,
        size: 0.16,
        reward: 30, // 3000벨/100
        price: 3000,
        description: '6월~9월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '보리새우를 잡았다! 마구마구 잡아보리~',
        movementPattern: 0.16,
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
        location: '바다(잠수)',
      ),
      Fish(
        id: 'lobster',
        name: '바닷가재',
        emoji: '🦞',
        difficulty: 4,
        speed: 0.65,
        size: 0.15,
        reward: 45, // 4500벨/100
        price: 4500,
        description: '4월~6월, 12월~1월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '바닷가재를 잡았다! 새우계의 슈퍼스타!',
        movementPattern: 0.17,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'venus_flower_basket',
        name: '해로동혈',
        emoji: '🌸',
        difficulty: 4,
        speed: 0.68,
        size: 0.15,
        reward: 50, // 5000벨/100
        price: 5000,
        description: '10월~2월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '해로동혈을 잡았다! 비너스의 꽃바구니야!',
        movementPattern: 0.17,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'spiny_lobster',
        name: '닭새우',
        emoji: '🦞',
        difficulty: 4,
        speed: 0.7,
        size: 0.15,
        reward: 50, // 5000벨/100
        price: 5000,
        description: '10월~12월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '닭새우를 잡았다! 새우의 왕 납시오~',
        movementPattern: 0.18,
        appearanceHours: [21, 22, 23, 0, 1, 2, 3], // 21시~4시
        location: '바다(잠수)',
      ),
      Fish(
        id: 'snow_crab',
        name: '대게',
        emoji: '🦀',
        difficulty: 4,
        speed: 0.72,
        size: 0.15,
        reward: 60, // 6000벨/100
        price: 6000,
        description: '11월~4월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '대게를 잡았다! 깊은 바닷에 사는 겨울철 진미!',
        movementPattern: 0.18,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'umbrella_octopus',
        name: '우무문어',
        emoji: '🐙',
        difficulty: 4,
        speed: 0.75,
        size: 0.15,
        reward: 60, // 6000벨/100
        price: 6000,
        description: '3월~5월, 9월~11월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '우무문어를 잡았다! 심해를 떠다니는 낙하산 같아!',
        movementPattern: 0.19,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),

      // 전설 (8000-15000벨)
      Fish(
        id: 'red_king_crab',
        name: '왕게',
        emoji: '🦀',
        difficulty: 5,
        speed: 0.8,
        size: 0.15,
        reward: 80, // 8000벨/100
        price: 8000,
        description: '11월~3월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '왕게를 잡았다! 게는 게지만 소라게의 친척이야!',
        movementPattern: 0.2,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'vampire_squid',
        name: '흡혈오징어',
        emoji: '🦑',
        difficulty: 5,
        speed: 0.82,
        size: 0.15,
        reward: 100, // 10000벨/100
        price: 10000,
        description: '5월~8월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '흡혈오징어를 잡았다! 흡혈박쥐문어라고도 불린데!',
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
        location: '바다(잠수)',
      ),
      Fish(
        id: 'sea_pig',
        name: '바다돼지',
        emoji: '🐷',
        difficulty: 5,
        speed: 0.85,
        size: 0.15,
        reward: 100, // 10000벨/100
        price: 10000,
        description: '11월~2월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '바다돼지를 잡았다! 귀여운 건지, 징그러운 건지!',
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
        location: '바다(잠수)',
      ),
      Fish(
        id: 'spider_crab',
        name: '키다리게',
        emoji: '🕷️',
        difficulty: 5,
        speed: 0.88,
        size: 0.15,
        reward: 120, // 12000벨/100
        price: 12000,
        description: '3월~4월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '키다리게를 잡았다! 다리가 진~짜 길어!',
        movementPattern: 0.2,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
      Fish(
        id: 'giant_isopod',
        name: '자이언트 이소포드',
        emoji: '🪲',
        difficulty: 5,
        speed: 0.9,
        size: 0.15,
        reward: 120, // 12000벨/100
        price: 12000,
        description: '7월~10월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '허어어억!! 자이언트 이소포드를 잡았다! 너무 깊게 잠수했나?',
        movementPattern: 0.2,
        appearanceHours: [
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          21,
          22,
          23,
          0,
          1,
          2,
          3,
        ], // 9시~16시, 21시~4시
        location: '바다(잠수)',
      ),
      Fish(
        id: 'gigas_giant_clam',
        name: '대왕거거',
        emoji: '🦪',
        difficulty: 5,
        speed: 0.85,
        size: 0.15,
        reward: 150, // 15000벨/100
        price: 15000,
        description: '5월~9월에 바다에서 잠수로 잡을 수 있는 해산물',
        catchMessage: '대왕거거를 잡았다! 껍데기에 물리지 않게 조심해야 돼~',
        movementPattern: 0.2,
        appearanceHours: [], // 24시간
        location: '바다(잠수)',
      ),
    ];
  }
}
