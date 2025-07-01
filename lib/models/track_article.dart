import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:office_lounge/models/main_comment.dart';
import 'package:office_lounge/models/youtube/track.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

part 'track_article.freezed.dart';
part 'track_article.g.dart';

String _toString(dynamic value) => value is String ? value : "";

int _toInt(dynamic value) => value is int ? value : 0;

DateTime _timestampFromJson(dynamic timestamp) {
  final logger = Logger();

  if (timestamp is Timestamp) {
    final result = timestamp.toDate();
    return result;
  } else if (timestamp is String) {
    try {
      final result = DateTime.parse(timestamp);
      return result;
    } catch (e) {
      // ISO 8601 파싱 실패 시 다른 형식 시도
      try {
        final result = DateFormat('yyyy-MM-dd HH:mm:ss').parse(timestamp);
        return result;
      } catch (e2) {
        // 모든 파싱 실패 시 Unix epoch 시간으로 설정 (1970-01-01)
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }
  } else if (timestamp is int) {
    // Unix timestamp (초 단위)
    final result = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    logger.d('Int 변환 결과: $result');
    return result;
  } else if (timestamp is double) {
    // Unix timestamp (초 단위, 소수점 포함)
    final result = DateTime.fromMillisecondsSinceEpoch(
      (timestamp * 1000).round(),
    );
    logger.d('Double 변환 결과: $result');
    return result;
  } else if (timestamp is Map) {
    // Firestore Timestamp 객체가 Map 형태로 올 경우
    if (timestamp.containsKey('_seconds')) {
      final seconds = timestamp['_seconds'] as int;
      final nanoseconds = timestamp['_nanoseconds'] as int? ?? 0;
      final result = DateTime.fromMillisecondsSinceEpoch(
        seconds * 1000 + nanoseconds ~/ 1000000,
      );
      logger.d('Map 변환 결과: $result');
      return result;
    }
  }

  logger.w('모든 타임스탬프 변환 실패, epoch 시간 반환: $timestamp');
  // 모든 변환 실패 시 Unix epoch 시간 반환 (현재 시간이 아닌)
  return DateTime.fromMillisecondsSinceEpoch(0);
}

String _timestampToJson(DateTime dateTime) {
  return dateTime.toIso8601String();
}

String? _timestampToJsonNullable(DateTime? dateTime) {
  return dateTime?.toIso8601String();
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
