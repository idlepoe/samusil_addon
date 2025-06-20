import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'price.freezed.dart';
part 'price.g.dart';

DateTime _timestampFromJson(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return timestamp.toDate();
  } else if (timestamp is String) {
    return DateTime.parse(timestamp);
  }
  return DateTime.now();
}

Timestamp _timestampToJson(DateTime dateTime) {
  return Timestamp.fromDate(dateTime);
}

@freezed
abstract class Price with _$Price {
  const factory Price({
    required double price,
    required double volume_24h,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime last_updated,
  }) = _Price;

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
}
