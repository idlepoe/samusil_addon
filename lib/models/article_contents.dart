import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_contents.freezed.dart';
part 'article_contents.g.dart';

bool _toBool(dynamic value) => value is bool ? value : false;

@freezed
abstract class ArticleContent with _$ArticleContent {
  const factory ArticleContent({
    required bool isPicture,
    bool? isOriginal,
    required String contents,
    @JsonKey(fromJson: _toBool) bool? isBold,
  }) = _ArticleContent;

  factory ArticleContent.fromJson(Map<String, dynamic> json) =>
      _$ArticleContentFromJson(json);
}
