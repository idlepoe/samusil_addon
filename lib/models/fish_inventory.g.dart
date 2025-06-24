// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fish_inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FishInventory _$FishInventoryFromJson(Map<String, dynamic> json) =>
    _FishInventory(
      fishId: json['fishId'] as String,
      fishName: json['fishName'] as String,
      caughtCount: (json['caughtCount'] as num).toInt(),
      currentCount: (json['currentCount'] as num).toInt(),
      lastCaughtAt: DateTime.parse(json['lastCaughtAt'] as String),
    );

Map<String, dynamic> _$FishInventoryToJson(_FishInventory instance) =>
    <String, dynamic>{
      'fishId': instance.fishId,
      'fishName': instance.fishName,
      'caughtCount': instance.caughtCount,
      'currentCount': instance.currentCount,
      'lastCaughtAt': instance.lastCaughtAt.toIso8601String(),
    };
