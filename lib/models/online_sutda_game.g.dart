// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_sutda_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnlineSutdaPlayer _$OnlineSutdaPlayerFromJson(Map<String, dynamic> json) =>
    _OnlineSutdaPlayer(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      photoUrl: json['photoUrl'] as String?,
      cards:
          (json['cards'] as List<dynamic>)
              .map((e) => SutdaCard.fromJson(e as Map<String, dynamic>))
              .toList(),
      totalBet: (json['totalBet'] as num).toInt(),
      hasFolded: json['hasFolded'] as bool,
      isConnected: json['isConnected'] as bool,
      points: (json['points'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$OnlineSutdaPlayerToJson(_OnlineSutdaPlayer instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'photoUrl': instance.photoUrl,
      'cards': cardsToJson(instance.cards),
      'totalBet': instance.totalBet,
      'hasFolded': instance.hasFolded,
      'isConnected': instance.isConnected,
      'points': instance.points,
    };

_OnlineSutdaGame _$OnlineSutdaGameFromJson(Map<String, dynamic> json) =>
    _OnlineSutdaGame(
      gameId: json['gameId'] as String,
      gameState: $enumDecode(_$OnlineGameStateEnumMap, json['gameState']),
      players:
          (json['players'] as List<dynamic>)
              .map((e) => OnlineSutdaPlayer.fromJson(e as Map<String, dynamic>))
              .toList(),
      currentPlayerIndex: (json['currentPlayerIndex'] as num).toInt(),
      pot: (json['pot'] as num).toInt(),
      baseBet: (json['baseBet'] as num).toInt(),
      currentBet: (json['currentBet'] as num).toInt(),
      round: (json['round'] as num).toInt(),
      bettingHistory:
          (json['bettingHistory'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      startedAt:
          json['startedAt'] == null
              ? null
              : DateTime.parse(json['startedAt'] as String),
      isGameStarted: json['isGameStarted'] as bool? ?? false,
      maxPlayers: (json['maxPlayers'] as num?)?.toInt() ?? 2,
    );

Map<String, dynamic> _$OnlineSutdaGameToJson(_OnlineSutdaGame instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'gameState': _$OnlineGameStateEnumMap[instance.gameState]!,
      'players': playersToJson(instance.players),
      'currentPlayerIndex': instance.currentPlayerIndex,
      'pot': instance.pot,
      'baseBet': instance.baseBet,
      'currentBet': instance.currentBet,
      'round': instance.round,
      'bettingHistory': instance.bettingHistory,
      'createdAt': instance.createdAt.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'isGameStarted': instance.isGameStarted,
      'maxPlayers': instance.maxPlayers,
    };

const _$OnlineGameStateEnumMap = {
  OnlineGameState.waiting: 'waiting',
  OnlineGameState.dealing: 'dealing',
  OnlineGameState.firstBetting: 'firstBetting',
  OnlineGameState.secondDealing: 'secondDealing',
  OnlineGameState.secondBetting: 'secondBetting',
  OnlineGameState.showdown: 'showdown',
  OnlineGameState.finished: 'finished',
};

_BettingMove _$BettingMoveFromJson(Map<String, dynamic> json) => _BettingMove(
  playerId: json['playerId'] as String,
  action: $enumDecode(_$BettingActionEnumMap, json['action']),
  amount: (json['amount'] as num).toInt(),
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$BettingMoveToJson(_BettingMove instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'action': _$BettingActionEnumMap[instance.action]!,
      'amount': instance.amount,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$BettingActionEnumMap = {
  BettingAction.check: 'check',
  BettingAction.ping: 'ping',
  BettingAction.call: 'call',
  BettingAction.raise: 'raise',
  BettingAction.half: 'half',
  BettingAction.quarter: 'quarter',
  BettingAction.ddadang: 'ddadang',
  BettingAction.die: 'die',
};
