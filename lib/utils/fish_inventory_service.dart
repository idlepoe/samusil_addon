import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fish_inventory.dart';

class FishInventoryService {
  static const String _key = 'fish_inventory';
  static FishInventoryService? _instance;

  static FishInventoryService get instance {
    _instance ??= FishInventoryService._();
    return _instance!;
  }

  FishInventoryService._();

  /// 물고기 인벤토리 전체 조회
  Future<List<FishInventory>> getAllInventory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => FishInventory.fromJson(json)).toList();
  }

  /// 특정 물고기 인벤토리 조회
  Future<FishInventory?> getFishInventory(String fishId) async {
    final inventory = await getAllInventory();
    try {
      return inventory.firstWhere((fish) => fish.fishId == fishId);
    } catch (e) {
      return null;
    }
  }

  /// 물고기 포획 (인벤토리에 추가)
  Future<FishInventory> addFish(String fishId, String fishName) async {
    final inventory = await getAllInventory();
    final existingFishIndex = inventory.indexWhere(
      (fish) => fish.fishId == fishId,
    );

    if (existingFishIndex >= 0) {
      // 기존 물고기 수량 증가
      final existingFish = inventory[existingFishIndex];
      final updatedFish = FishInventory(
        fishId: existingFish.fishId,
        fishName: existingFish.fishName,
        caughtCount: existingFish.caughtCount + 1,
        currentCount: existingFish.currentCount + 1,
        lastCaughtAt: DateTime.now(),
      );
      inventory[existingFishIndex] = updatedFish;
      await _saveInventory(inventory);
      return updatedFish;
    } else {
      // 새 물고기 추가
      final newFish = FishInventory(
        fishId: fishId,
        fishName: fishName,
        caughtCount: 1,
        currentCount: 1,
        lastCaughtAt: DateTime.now(),
      );
      inventory.add(newFish);
      await _saveInventory(inventory);
      return newFish;
    }
  }

  /// 물고기 판매 (수량 감소)
  Future<FishInventory?> sellFish(String fishId, int sellCount) async {
    final inventory = await getAllInventory();
    final existingFishIndex = inventory.indexWhere(
      (fish) => fish.fishId == fishId,
    );

    if (existingFishIndex < 0) {
      throw Exception('보유하지 않은 물고기입니다.');
    }

    final existingFish = inventory[existingFishIndex];
    if (existingFish.currentCount < sellCount) {
      throw Exception('보유량(${existingFish.currentCount}마리)보다 많이 판매할 수 없습니다.');
    }

    final updatedFish = FishInventory(
      fishId: existingFish.fishId,
      fishName: existingFish.fishName,
      caughtCount: existingFish.caughtCount,
      currentCount: existingFish.currentCount - sellCount,
      lastCaughtAt: existingFish.lastCaughtAt,
    );

    if (updatedFish.currentCount == 0) {
      // 수량이 0이 되면 인벤토리에서 제거
      inventory.removeAt(existingFishIndex);
    } else {
      inventory[existingFishIndex] = updatedFish;
    }

    await _saveInventory(inventory);
    return updatedFish.currentCount > 0 ? updatedFish : null;
  }

  /// 인벤토리 저장
  Future<void> _saveInventory(List<FishInventory> inventory) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(
      inventory.map((fish) => fish.toJson()).toList(),
    );
    await prefs.setString(_key, jsonString);
  }

  /// 인벤토리 초기화 (개발/테스트용)
  Future<void> clearInventory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  /// 총 잡은 물고기 수
  Future<int> getTotalCaughtCount() async {
    final inventory = await getAllInventory();
    return inventory.fold<int>(0, (sum, fish) => sum + fish.caughtCount);
  }

  /// 현재 보유 중인 물고기 수
  Future<int> getTotalCurrentCount() async {
    final inventory = await getAllInventory();
    return inventory.fold<int>(0, (sum, fish) => sum + fish.currentCount);
  }
}
