import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'wish.freezed.dart';
part 'wish.g.dart';

String _toString(dynamic value) => value is String ? value : "";

int _toInt(dynamic value) => value is int ? value : 1;

@freezed
abstract class Wish with _$Wish {
  const factory Wish({
    @JsonKey(fromJson: _toInt) required int index,
    @JsonKey(fromJson: _toString) required String key,
    @JsonKey(fromJson: _toString) required String comments,
    @JsonKey(fromJson: _toString) required String nick_name,
    @JsonKey(fromJson: _toInt) required int streak,
    @JsonKey(fromJson: _toString) required String created_at,
  }) = _Wish;

  factory Wish.fromJson(Map<String, dynamic> json) => _$WishFromJson(json);

  factory Wish.init() => Wish(
        index: 0,
        key: "",
        comments: "",
        nick_name: "",
        streak: 1,
        created_at: DateFormat("yyyy-MM-dd").format(DateTime.now()),
      );
}
