import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:samusil_addon/models/main_comment.dart';

import 'article_contents.dart';

part 'article.freezed.dart';
part 'article.g.dart';

String _toString(dynamic value) => value is String ? value : "";

int _toInt(dynamic value) => value is int ? value : 0;

@freezed
abstract class Article with _$Article {
  const factory Article({
    @JsonKey(fromJson: _toString) required String key,
    @JsonKey(fromJson: _toString) required String board_name,
    @JsonKey(fromJson: _toString) required String profile_key,
    @JsonKey(fromJson: _toString) required String profile_name,
    @JsonKey(fromJson: _toInt) required int count_view,
    @JsonKey(fromJson: _toInt) required int count_like,
    @JsonKey(fromJson: _toInt) required int count_unlike,
    @JsonKey(fromJson: _toInt) required int count_comments,
    @JsonKey(fromJson: _toString) required String title,
    required List<ArticleContent> contents,
    @JsonKey(fromJson: _toString) required String created_at,
    required bool is_notice,
    String? thumbnail,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
