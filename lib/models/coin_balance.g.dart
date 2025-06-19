// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoinBalance _$CoinBalanceFromJson(Map<String, dynamic> json) => _CoinBalance(
  id: json['id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  total: (json['total'] as num?)?.toInt(),
  created_at: json['created_at'] as String,
  profit: (json['profit'] as num?)?.toDouble(),
  sub_list: _toCoinBalanceList(json['sub_list']),
  current_price: (json['current_price'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CoinBalanceToJson(_CoinBalance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'total': instance.total,
      'created_at': instance.created_at,
      'profit': instance.profit,
      'sub_list': instance.sub_list,
      'current_price': instance.current_price,
    };
