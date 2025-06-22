import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'point_history.freezed.dart';
part 'point_history.g.dart';

@freezed
abstract class PointHistory with _$PointHistory {
  const factory PointHistory({
    @JsonKey(fromJson: _toString) String? id,
    @JsonKey(fromJson: _toString) required String profile_uid,
    @JsonKey(fromJson: _toString) required String action_type,
    @JsonKey(fromJson: _toInt) required int points_earned,
    @JsonKey(fromJson: _toString) required String description,
    @JsonKey(fromJson: _toString) String? related_id,
    @JsonKey(fromJson: _toDateTimeObj) required DateTime created_at,
  }) = _PointHistory;

  factory PointHistory.fromJson(Map<String, dynamic> json) =>
      _$PointHistoryFromJson(json);
}

String _toString(dynamic value) => value?.toString() ?? '';

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

DateTime _toDateTimeObj(dynamic value) {
  if (value is DateTime) return value;
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
  if (value is Map && value['_seconds'] != null) {
    return DateTime.fromMillisecondsSinceEpoch(value['_seconds'] * 1000);
  }
  return DateTime.now();
}
