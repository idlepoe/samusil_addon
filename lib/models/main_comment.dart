import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'main_comment.freezed.dart';
part 'main_comment.g.dart';

String _toString(dynamic value) => value is String ? value : "";
bool _toBool(dynamic value) => value is bool ? value : false;
int _toInt(dynamic value) => value is int ? value : 0;

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
abstract class MainComment with _$MainComment {
  const factory MainComment({
    @JsonKey(fromJson: _toString) required String key,
    @JsonKey(fromJson: _toString) required String contents,
    @JsonKey(fromJson: _toString) required String profile_uid,
    @JsonKey(fromJson: _toString) required String profile_name,
    @JsonKey(fromJson: _toString) required String profile_photo_url,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime created_at,
    @JsonKey(fromJson: _toBool) required bool is_sub,
    @JsonKey(fromJson: _toString) required String parents_key,
  }) = _MainComment;

  factory MainComment.fromJson(Map<String, dynamic> json) =>
      _$MainCommentFromJson(json);
}
