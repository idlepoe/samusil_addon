import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:office_lounge/models/price.dart';

part 'coin.freezed.dart';
part 'coin.g.dart';

@freezed
abstract class Coin with _$Coin {
  const factory Coin({
    required String id,
    required String name,
    required String symbol,
    required int rank,
    required bool is_active,
    List<Price>? price_history,
    List<double>? diffList,
    double? diffPercentage,
    double? color,
    double? current_volume_24h,
  }) = _Coin;

  factory Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);
}
