import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'horse_race.freezed.dart';
part 'horse_race.g.dart';

@freezed
abstract class HorseRace with _$HorseRace {
  const factory HorseRace({
    @JsonKey(fromJson: _toString) required String id,
    @JsonKey(fromJson: _toDateTime) required DateTime bettingStartTime,
    @JsonKey(fromJson: _toDateTime) required DateTime bettingEndTime,
    @JsonKey(fromJson: _toDateTime) required DateTime startTime,
    @JsonKey(fromJson: _toDateTime) required DateTime endTime,
    required List<Horse> horses,
    @JsonKey(fromJson: _toBool) required bool isActive,
    @JsonKey(fromJson: _toBool) required bool isFinished,
    @JsonKey(fromJson: _toInt) required int currentRound,
    @JsonKey(fromJson: _toInt) required int totalRounds,
  }) = _HorseRace;

  factory HorseRace.fromJson(Map<String, dynamic> json) =>
      _$HorseRaceFromJson(json);
}

@freezed
abstract class Horse with _$Horse {
  const factory Horse({
    @JsonKey(fromJson: _toString) required String coinId,
    @JsonKey(fromJson: _toString) required String name,
    @JsonKey(fromJson: _toString) required String symbol,
    @JsonKey(fromJson: _toString) required String image,
    @JsonKey(fromJson: _toDouble) required double currentPosition,
    required List<double> movements,
    @JsonKey(fromJson: _toDouble) required double lastPrice,
    @JsonKey(fromJson: _toDouble) required double previousPrice,
    @JsonKey(fromJson: _toInt) required int rank,
  }) = _Horse;

  factory Horse.fromJson(Map<String, dynamic> json) => _$HorseFromJson(json);
}

@freezed
abstract class Bet with _$Bet {
  const factory Bet({
    @JsonKey(fromJson: _toString) required String id,
    @JsonKey(fromJson: _toString) required String userId,
    @JsonKey(fromJson: _toString) required String userName,
    @JsonKey(fromJson: _toString) required String raceId,
    @JsonKey(fromJson: _toString)
    required String betType, // 'winner', 'top2', 'top3'
    @JsonKey(fromJson: _toString) required String horseId,
    @JsonKey(fromJson: _toInt) required int amount,
    @JsonKey(fromJson: _toDateTime) required DateTime betTime,
    @JsonKey(fromJson: _toBool) required bool isWon,
    @JsonKey(fromJson: _toInt) required int wonAmount,
  }) = _Bet;

  factory Bet.fromJson(Map<String, dynamic> json) => _$BetFromJson(json);
}

String _toString(dynamic value) => value?.toString() ?? '';
int _toInt(dynamic value) =>
    value is int ? value : int.tryParse(value?.toString() ?? '0') ?? 0;
double _toDouble(dynamic value) =>
    value is double
        ? value
        : double.tryParse(value?.toString() ?? '0.0') ?? 0.0;
bool _toBool(dynamic value) =>
    value?.toString().toLowerCase() == 'true' || value == true;
DateTime _toDateTime(dynamic value) {
  if (value is DateTime) return value;
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  if (value is Map && value.containsKey('_seconds')) {
    return Timestamp(value['_seconds'], value['_nanoseconds'] ?? 0).toDate();
  }
  return DateTime.fromMillisecondsSinceEpoch(0);
}
