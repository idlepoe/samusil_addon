import 'package:freezed_annotation/freezed_annotation.dart';

part 'fish_inventory.freezed.dart';
part 'fish_inventory.g.dart';

@freezed
abstract class FishInventory with _$FishInventory {
  const factory FishInventory({
    required String fishId,
    required String fishName,
    required int caughtCount, // 총 잡은 횟수
    required int currentCount, // 현재 보유 수량
    required DateTime lastCaughtAt,
  }) = _FishInventory;

  factory FishInventory.fromJson(Map<String, dynamic> json) =>
      _$FishInventoryFromJson(json);
}
