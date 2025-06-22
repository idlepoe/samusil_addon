// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horse_race.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HorseRace _$HorseRaceFromJson(Map<String, dynamic> json) => _HorseRace(
  id: _toString(json['id']),
  startTime: _toDateTime(json['startTime']),
  endTime: _toDateTime(json['endTime']),
  bettingEndTime: _toDateTime(json['bettingEndTime']),
  horses:
      (json['horses'] as List<dynamic>)
          .map((e) => Horse.fromJson(e as Map<String, dynamic>))
          .toList(),
  bets:
      (json['bets'] as List<dynamic>)
          .map((e) => Bet.fromJson(e as Map<String, dynamic>))
          .toList(),
  isActive: _toBool(json['isActive']),
  isFinished: _toBool(json['isFinished']),
  currentRound: _toInt(json['currentRound']),
  totalRounds: _toInt(json['totalRounds']),
);

Map<String, dynamic> _$HorseRaceToJson(_HorseRace instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'bettingEndTime': instance.bettingEndTime.toIso8601String(),
      'horses': instance.horses,
      'bets': instance.bets,
      'isActive': instance.isActive,
      'isFinished': instance.isFinished,
      'currentRound': instance.currentRound,
      'totalRounds': instance.totalRounds,
    };

_Horse _$HorseFromJson(Map<String, dynamic> json) => _Horse(
  coinId: _toString(json['coinId']),
  name: _toString(json['name']),
  symbol: _toString(json['symbol']),
  currentPosition: _toDouble(json['currentPosition']),
  movements:
      (json['movements'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
  lastPrice: _toDouble(json['lastPrice']),
  previousPrice: _toDouble(json['previousPrice']),
);

Map<String, dynamic> _$HorseToJson(_Horse instance) => <String, dynamic>{
  'coinId': instance.coinId,
  'name': instance.name,
  'symbol': instance.symbol,
  'currentPosition': instance.currentPosition,
  'movements': instance.movements,
  'lastPrice': instance.lastPrice,
  'previousPrice': instance.previousPrice,
};

_Bet _$BetFromJson(Map<String, dynamic> json) => _Bet(
  id: _toString(json['id']),
  userId: _toString(json['userId']),
  userName: _toString(json['userName']),
  raceId: _toString(json['raceId']),
  betType: _toString(json['betType']),
  selectedHorseId: _toString(json['selectedHorseId']),
  betAmount: _toInt(json['betAmount']),
  betTime: _toDateTime(json['betTime']),
  isWon: _toBool(json['isWon']),
  wonAmount: _toInt(json['wonAmount']),
);

Map<String, dynamic> _$BetToJson(_Bet instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'userName': instance.userName,
  'raceId': instance.raceId,
  'betType': instance.betType,
  'selectedHorseId': instance.selectedHorseId,
  'betAmount': instance.betAmount,
  'betTime': instance.betTime.toIso8601String(),
  'isWon': instance.isWon,
  'wonAmount': instance.wonAmount,
};
