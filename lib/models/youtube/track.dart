import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html_unescape/html_unescape.dart';

part 'track.freezed.dart';
part 'track.g.dart';

// null → '' 또는 '값'.toString()
String _toString(dynamic value) =>
    value is String ? HtmlUnescape().convert(value) : '';

// null → 0
int _toInt(dynamic value) =>
    value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;

// null → 0.0
double _toDouble(dynamic value) =>
    value is double ? value : double.tryParse(value?.toString() ?? '') ?? 0.0;

DateTime _toDateTime(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is Map &&
      value.containsKey('_seconds') &&
      value.containsKey('_nanoseconds')) {
    return DateTime.fromMillisecondsSinceEpoch(
      (value['_seconds'] as int) * 1000,
    );
  }
  return value as DateTime;
}

dynamic _fromDateTime(DateTime dateTime) {
  return dateTime.toIso8601String();
}

@freezed
abstract class Track with _$Track {
  const factory Track({
    required String id,
    required String videoId,
    @JsonKey(fromJson: _toString) required String title,
    @JsonKey(fromJson: _toString) required String description,
    required String thumbnail,
    required int duration,
  }) = _Track;

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
}
