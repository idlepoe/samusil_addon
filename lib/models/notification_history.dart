import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_history.freezed.dart';
part 'notification_history.g.dart';

@freezed
abstract class NotificationHistory with _$NotificationHistory {
  const factory NotificationHistory({
    @JsonKey(fromJson: _toString) required String id,
    @JsonKey(fromJson: _toString) required String type,
    @JsonKey(fromJson: _toString) required String title,
    @JsonKey(fromJson: _toString) required String body,
    @JsonKey(fromJson: _toString) required String article_id,
    @JsonKey(fromJson: _toString) required String article_title,
    @JsonKey(fromJson: _toString) required String sender_uid,
    @JsonKey(fromJson: _toString) required String sender_name,
    @JsonKey(fromJson: _toDateTime) required DateTime created_at,
    @JsonKey(fromJson: _toBool) required bool read,
  }) = _NotificationHistory;

  factory NotificationHistory.fromJson(Map<String, dynamic> json) =>
      _$NotificationHistoryFromJson(json);
}

String _toString(dynamic value) => value?.toString() ?? '';
DateTime _toDateTime(dynamic value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.parse(value);
  if (value is Map && value['_seconds'] != null) {
    return DateTime.fromMillisecondsSinceEpoch(value['_seconds'] * 1000);
  }
  return DateTime.now();
}

bool _toBool(dynamic value) =>
    value?.toString().toLowerCase() == 'true' || value == true;
