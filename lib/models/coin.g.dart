// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Coin _$CoinFromJson(Map<String, dynamic> json) => _Coin(
  id: json['id'] as String,
  name: json['name'] as String,
  symbol: json['symbol'] as String,
  rank: (json['rank'] as num).toInt(),
  is_active: json['is_active'] as bool,
  price_history:
      (json['price_history'] as List<dynamic>?)
          ?.map((e) => Price.fromJson(e as Map<String, dynamic>))
          .toList(),
  diffList:
      (json['diffList'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
  diffPercentage: (json['diffPercentage'] as num?)?.toDouble(),
  color: (json['color'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CoinToJson(_Coin instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'symbol': instance.symbol,
  'rank': instance.rank,
  'is_active': instance.is_active,
  'price_history': instance.price_history,
  'diffList': instance.diffList,
  'diffPercentage': instance.diffPercentage,
  'color': instance.color,
};
