import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_price.freezed.dart';
part 'coin_price.g.dart';

double _toDouble(dynamic value) => value is double ? value : 0;
String _toString(dynamic value) => value is String ? value : "";

@freezed
abstract class CoinPrice with _$CoinPrice {
  const factory CoinPrice({
    String? id,
    String? name,
    @JsonKey(fromJson: _toDouble) required double price,
    @JsonKey(fromJson: _toDouble) required double volume_24h,
    required String last_updated,
  }) = _CoinPrice;

  factory CoinPrice.fromJson(Map<String, dynamic> json) =>
      _$CoinPriceFromJson(json);
}
