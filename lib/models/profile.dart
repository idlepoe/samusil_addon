import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:samusil_addon/models/coin_balance.dart';

import 'alarm.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

String _toString(dynamic value) => value is String ? value : "";

int _toInt(dynamic value) => value is int ? value : 0;

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    @JsonKey(fromJson: _toString) required String key,
    @JsonKey(fromJson: _toString) required String name,
    @JsonKey(fromJson: _toString) required String profile_image_url,
    @JsonKey(fromJson: _toString) required String wish_last_date,
    @JsonKey(fromJson: _toInt) required int wish_streak,
    required double point,
    required List<Alarm> alarms,
    required List<CoinBalance> coin_balance,
    @JsonKey(fromJson: _toString) required String one_comment,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  factory Profile.init() => const Profile(
        key: "",
        name: "",
        profile_image_url: "",
        wish_last_date: "",
        wish_streak: 1,
        point: 0,
        alarms: [],
        coin_balance: [],
        one_comment: "",
      );
}
