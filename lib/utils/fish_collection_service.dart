import 'package:shared_preferences/shared_preferences.dart';
import '../models/fish.dart';

class FishCollectionService {
  static const String _caughtFishKey = 'caught_fish';
  static const String _fishCountKey = 'fish_count_';

  static FishCollectionService? _instance;
  static FishCollectionService get instance =>
      _instance ??= FishCollectionService._();

  FishCollectionService._();

  SharedPreferences? _prefs;

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// 잡은 물고기 목록 가져오기
  Future<Set<String>> getCaughtFish() async {
    await _initPrefs();
    final caughtFishList = _prefs!.getStringList(_caughtFishKey) ?? [];
    return Set<String>.from(caughtFishList);
  }

  /// 물고기 잡았을 때 저장
  Future<void> addCaughtFish(String fishName) async {
    await _initPrefs();
    final caughtFish = await getCaughtFish();
    caughtFish.add(fishName);
    await _prefs!.setStringList(_caughtFishKey, caughtFish.toList());

    // 물고기 개수 증가
    final currentCount = await getFishCount(fishName);
    await _prefs!.setInt('$_fishCountKey$fishName', currentCount + 1);
  }

  /// 특정 물고기를 잡았는지 확인
  Future<bool> isFishCaught(String fishName) async {
    final caughtFish = await getCaughtFish();
    return caughtFish.contains(fishName);
  }

  /// 특정 물고기를 잡은 개수 가져오기
  Future<int> getFishCount(String fishName) async {
    await _initPrefs();
    return _prefs!.getInt('$_fishCountKey$fishName') ?? 0;
  }

  /// 도감 완성도 (잡은 물고기 수 / 전체 물고기 수)
  Future<double> getCollectionProgress() async {
    final caughtFish = await getCaughtFish();
    return caughtFish.length / Fish.allFish.length;
  }

  /// 도감 초기화 (디버그용)
  Future<void> clearCollection() async {
    await _initPrefs();
    await _prefs!.remove(_caughtFishKey);
    // 모든 물고기 개수도 초기화
    for (final fish in Fish.allFish) {
      await _prefs!.remove('$_fishCountKey${fish.name}');
    }
  }
}
