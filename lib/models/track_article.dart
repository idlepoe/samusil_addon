import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:office_lounge/models/main_comment.dart';
import 'package:office_lounge/models/youtube/track.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'track_article.freezed.dart';
part 'track_article.g.dart';

String _toString(dynamic value) => value is String ? value : "";

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

Timestamp? _timestampToJsonNullable(DateTime? dateTime) {
  return dateTime != null ? Timestamp.fromDate(dateTime) : null;
}

@freezed
abstract class TrackArticle with _$TrackArticle {
  const factory TrackArticle({
    @JsonKey(fromJson: _toString) required String id,
    @JsonKey(fromJson: _toString) required String profile_uid,
    @JsonKey(fromJson: _toString) required String profile_name,
    @JsonKey(fromJson: _toString) required String profile_photo_url,
    @JsonKey(fromJson: _toInt) required int count_view,
    @JsonKey(fromJson: _toInt) required int count_like,
    @JsonKey(fromJson: _toInt) required int count_unlike,
    @JsonKey(fromJson: _toInt) required int count_comments,
    @JsonKey(fromJson: _toString) required String title,
    @Default([]) List<Track> tracks, // contents 대신 tracks 사용
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime created_at,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJsonNullable)
    DateTime? updated_at,
    @JsonKey(fromJson: _toInt) int? profile_point,
    List<MainComment>? comments,
    @JsonKey(fromJson: _toInt) @Default(0) int total_duration, // 총 재생시간 (초)
    @JsonKey(fromJson: _toInt) @Default(0) int track_count, // 트랙 개수
    @JsonKey(fromJson: _toString) @Default('') String description, // 플레이리스트 설명
  }) = _TrackArticle;

  factory TrackArticle.fromJson(Map<String, dynamic> json) =>
      _$TrackArticleFromJson(json);
}
