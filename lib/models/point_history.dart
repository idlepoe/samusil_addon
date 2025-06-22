import 'package:freezed_annotation/freezed_annotation.dart';

part 'point_history.freezed.dart';
part 'point_history.g.dart';

@freezed
abstract class PointHistory with _$PointHistory {
  const factory PointHistory({
    String? id,
    required String profile_uid,
    required String action_type,
    required int points_earned,
    required String description,
    String? related_id,
    required String created_at,
  }) = _PointHistory;

  factory PointHistory.fromJson(Map<String, dynamic> json) =>
      _$PointHistoryFromJson(json);
} 