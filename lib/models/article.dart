import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:office_lounge/models/main_comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'article_contents.dart';

part 'article.freezed.dart';
part 'article.g.dart';

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
abstract class Article with _$Article {
  const factory Article({
    @JsonKey(fromJson: _toString) required String id,
    @JsonKey(fromJson: _toString) required String board_name,
    @JsonKey(fromJson: _toString) required String profile_uid,
    @JsonKey(fromJson: _toString) required String profile_name,
    @JsonKey(fromJson: _toString) required String profile_photo_url,
    @JsonKey(fromJson: _toInt) required int count_view,
    @JsonKey(fromJson: _toInt) required int count_like,
    @JsonKey(fromJson: _toInt) required int count_unlike,
    @JsonKey(fromJson: _toInt) required int count_comments,
    @JsonKey(fromJson: _toString) required String title,
    required List<ArticleContent> contents,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime created_at,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJsonNullable)
    DateTime? updated_at,
    @JsonKey(fromJson: _toInt) int? profile_point,
    required bool is_notice,
    String? thumbnail,
    List<MainComment>? comments,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
