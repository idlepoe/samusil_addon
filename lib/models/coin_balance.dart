import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coin_balance.freezed.dart';
part 'coin_balance.g.dart';

List<CoinBalance> _toCoinBalanceList(dynamic value) => value is List<CoinBalance> ? value : [];

@freezed
abstract class CoinBalance with _$CoinBalance {
  const factory CoinBalance({
    required String id,
    required String name,
    required double price,
    required int quantity,
    int? total,
    required String created_at,
    double? profit,
    @JsonKey(fromJson: _toCoinBalanceList) List<CoinBalance>? sub_list,
    double? current_price,
  }) = _CoinBalance;

  factory CoinBalance.fromJson(Map<String, dynamic> json) =>
      _$CoinBalanceFromJson(json);
}
