// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoinPrice _$CoinPriceFromJson(Map<String, dynamic> json) => _CoinPrice(
  id: json['id'] as String?,
  name: json['name'] as String?,
  price: _toDouble(json['price']),
  volume_24h: _toDouble(json['volume_24h']),
  last_updated: json['last_updated'] as String,
);

Map<String, dynamic> _$CoinPriceToJson(_CoinPrice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'volume_24h': instance.volume_24h,
      'last_updated': instance.last_updated,
    };
