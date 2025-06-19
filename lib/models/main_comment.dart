import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_comment.freezed.dart';
part 'main_comment.g.dart';

String _toString(dynamic value) => value is String ? value : "";
bool _toBool(dynamic value) => value is bool ? value : false;
int _toInt(dynamic value) => value is int ? value : 0;

@freezed
abstract class MainComment with _$MainComment {
  const factory MainComment({
    @JsonKey(fromJson: _toString) required String key,
    @JsonKey(fromJson: _toString) required String contents,
    @JsonKey(fromJson: _toString) required String profile_key,
    @JsonKey(fromJson: _toString) required String profile_name,
    @JsonKey(fromJson: _toString) required String created_at,
    @JsonKey(fromJson: _toBool) required bool is_sub,
    @JsonKey(fromJson: _toString) required String parents_key,
  }) = _MainComment;

  factory MainComment.fromJson(Map<String, dynamic> json) =>
      _$MainCommentFromJson(json);
}
