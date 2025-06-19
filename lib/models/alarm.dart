import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm.freezed.dart';
part 'alarm.g.dart';

@freezed
abstract class Alarm with _$Alarm {
  const factory Alarm({
    required String key,
    required String my_contents,
    required bool is_read,
    required String target_article_key,
    required String target_contents,
    required String target_info,
    required int target_key_type,
  }) = _Alarm;

  factory Alarm.fromJson(Map<String, dynamic> json) => _$AlarmFromJson(json);

  factory Alarm.init() => const Alarm(
        key: "",
        my_contents: "",
        is_read: false,
        target_article_key: "",
        target_contents: "",
        target_info: "",
        target_key_type: 1,
      );
}