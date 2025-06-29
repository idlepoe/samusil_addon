// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sutda_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SutdaCard _$SutdaCardFromJson(Map<String, dynamic> json) => _SutdaCard(
  month: (json['month'] as num).toInt(),
  type: json['type'] as String,
  value: (json['value'] as num).toInt(),
);

Map<String, dynamic> _$SutdaCardToJson(_SutdaCard instance) =>
    <String, dynamic>{
      'month': instance.month,
      'type': instance.type,
      'value': instance.value,
    };

_SutdaHand _$SutdaHandFromJson(Map<String, dynamic> json) => _SutdaHand(
  name: json['name'] as String,
  rank: (json['rank'] as num).toInt(),
  value: (json['value'] as num).toInt(),
);

Map<String, dynamic> _$SutdaHandToJson(_SutdaHand instance) =>
    <String, dynamic>{
      'name': instance.name,
      'rank': instance.rank,
      'value': instance.value,
    };
