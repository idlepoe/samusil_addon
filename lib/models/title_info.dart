class TitleInfo {
  final String id;
  final String name;
  final String description;
  final String unlockCondition; // 해금 조건 설명
  final String emoji; // 칭호 앞에 붙일 이모지
  final TitleCategory category; // 칭호 카테고리

  const TitleInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.unlockCondition,
    this.emoji = '',
    required this.category,
  });

  /// 칭고 표시용 텍스트 (이모지 + 이름)
  String get displayName => emoji.isEmpty ? name : '$emoji $name';
}

enum TitleCategory {
  fishing, // 낚시 관련
  general, // 일반
  special, // 특별
}

/// 모든 칭호 정보
class TitleData {
  static const List<TitleInfo> allTitles = [
    // === 낚시 관련 칭호 ===
    TitleInfo(
      id: 'first_fish',
      name: '첫 물고기',
      description: '첫 번째 물고기를 잡은 기념',
      unlockCondition: '물고기 1마리 포획',
      emoji: '🐟',
      category: TitleCategory.fishing,
    ),
    TitleInfo(
      id: 'fishing_novice',
      name: '낚시 초보',
      description: '낚시의 세계에 발을 들인 초보자',
      unlockCondition: '물고기 5마리 포획',
      emoji: '🎣',
      category: TitleCategory.fishing,
    ),
    TitleInfo(
      id: 'pond_explorer',
      name: '연못 탐험가',
      description: '연못의 모든 비밀을 아는 자',
      unlockCondition: '연못 물고기 3종 포획',
      emoji: '🏞️',
      category: TitleCategory.fishing,
    ),
    TitleInfo(
      id: 'river_master',
      name: '강의 주인',
      description: '강물을 자유자재로 다루는 낚시꾼',
      unlockCondition: '강 물고기 5종 포획',
      emoji: '🌊',
      category: TitleCategory.fishing,
    ),
    TitleInfo(
      id: 'sea_hunter',
      name: '바다 사냥꾼',
      description: '바다의 거친 파도를 정복한 어부',
      unlockCondition: '바다 물고기 10종 포획',
      emoji: '🌊',
      category: TitleCategory.fishing,
    ),
    TitleInfo(
      id: 'deep_sea_diver',
      name: '심해 잠수부',
      description: '깊은 바다의 보물을 찾는 전문가',
      unlockCondition: '바다(잠수) 물고기 5종 포획',
      emoji: '🤿',
      category: TitleCategory.fishing,
    ),
    TitleInfo(
      id: 'rare_collector',
      name: '희귀종 수집가',
      description: '희귀한 물고기만을 노리는 전문가',
      unlockCondition: '희귀 등급(4등급) 물고기 3종 포획',
      emoji: '💎',
      category: TitleCategory.fishing,
    ),
    TitleInfo(
      id: 'legend_fisher',
      name: '전설의 어부',
      description: '모든 물고기를 잡은 전설적인 낚시꾼',
      unlockCondition: '물고기 도감 100% 완성',
      emoji: '👑',
      category: TitleCategory.fishing,
    ),
    TitleInfo(
      id: 'point_millionaire',
      name: '포인트 백만장자',
      description: '물고기 판매로 큰 부를 축적한 사업가',
      unlockCondition: '물고기 판매로 총 1000P 획득',
      emoji: '💰',
      category: TitleCategory.fishing,
    ),

    // === 일반 칭호 ===
    TitleInfo(
      id: 'office_worker',
      name: '사무직 직장인',
      description: '평범한 사무실 생활을 하는 직장인',
      unlockCondition: '기본 칭호',
      emoji: '💼',
      category: TitleCategory.general,
    ),
    TitleInfo(
      id: 'early_bird',
      name: '일찍 일어나는 새',
      description: '새벽부터 활동하는 부지런한 사람',
      unlockCondition: '오전 6시 이전 접속 5회',
      emoji: '🐦',
      category: TitleCategory.general,
    ),

    // === 특별 칭호 ===
    TitleInfo(
      id: 'beta_tester',
      name: '베타 테스터',
      description: '앱 초기 개발에 참여한 소중한 사용자',
      unlockCondition: '베타 테스트 참여',
      emoji: '🔬',
      category: TitleCategory.special,
    ),
  ];

  /// ID로 칭호 정보 찾기
  static TitleInfo? getTitleById(String id) {
    try {
      return allTitles.firstWhere((title) => title.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 카테고리별 칭호 목록
  static List<TitleInfo> getTitlesByCategory(TitleCategory category) {
    return allTitles.where((title) => title.category == category).toList();
  }
}
