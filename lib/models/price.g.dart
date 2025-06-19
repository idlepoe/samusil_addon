// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Price _$PriceFromJson(Map<String, dynamic> json) => _Price(
  price: (json['price'] as num).toDouble(),
  volume_24h: (json['volume_24h'] as num).toDouble(),
  last_updated: json['last_updated'] as String,
);

Map<String, dynamic> _$PriceToJson(_Price instance) => <String, dynamic>{
  'price': instance.price,
  'volume_24h': instance.volume_24h,
  'last_updated': instance.last_updated,
};
