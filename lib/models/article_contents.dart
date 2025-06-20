import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_contents.freezed.dart';
part 'article_contents.g.dart';

@freezed
abstract class ArticleContent with _$ArticleContent {
  const factory ArticleContent({
    required bool isPicture,
    required String contents,
  }) = _ArticleContent;

  factory ArticleContent.fromJson(Map<String, dynamic> json) =>
      _$ArticleContentFromJson(json);
}
