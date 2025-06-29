// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'online_sutda_game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnlineSutdaPlayer {

 String get playerId; String get playerName; String? get photoUrl;@JsonKey(toJson: cardsToJson) List<SutdaCard> get cards; int get totalBet; bool get hasFolded; bool get isConnected; int get points;
/// Create a copy of OnlineSutdaPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnlineSutdaPlayerCopyWith<OnlineSutdaPlayer> get copyWith => _$OnlineSutdaPlayerCopyWithImpl<OnlineSutdaPlayer>(this as OnlineSutdaPlayer, _$identity);

  /// Serializes this OnlineSutdaPlayer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnlineSutdaPlayer&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&const DeepCollectionEquality().equals(other.cards, cards)&&(identical(other.totalBet, totalBet) || other.totalBet == totalBet)&&(identical(other.hasFolded, hasFolded) || other.hasFolded == hasFolded)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.points, points) || other.points == points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerName,photoUrl,const DeepCollectionEquality().hash(cards),totalBet,hasFolded,isConnected,points);

@override
String toString() {
  return 'OnlineSutdaPlayer(playerId: $playerId, playerName: $playerName, photoUrl: $photoUrl, cards: $cards, totalBet: $totalBet, hasFolded: $hasFolded, isConnected: $isConnected, points: $points)';
}


}

/// @nodoc
abstract mixin class $OnlineSutdaPlayerCopyWith<$Res>  {
  factory $OnlineSutdaPlayerCopyWith(OnlineSutdaPlayer value, $Res Function(OnlineSutdaPlayer) _then) = _$OnlineSutdaPlayerCopyWithImpl;
@useResult
$Res call({
 String playerId, String playerName, String? photoUrl,@JsonKey(toJson: cardsToJson) List<SutdaCard> cards, int totalBet, bool hasFolded, bool isConnected, int points
});




}
/// @nodoc
class _$OnlineSutdaPlayerCopyWithImpl<$Res>
    implements $OnlineSutdaPlayerCopyWith<$Res> {
  _$OnlineSutdaPlayerCopyWithImpl(this._self, this._then);

  final OnlineSutdaPlayer _self;
  final $Res Function(OnlineSutdaPlayer) _then;

/// Create a copy of OnlineSutdaPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? playerName = null,Object? photoUrl = freezed,Object? cards = null,Object? totalBet = null,Object? hasFolded = null,Object? isConnected = null,Object? points = null,}) {
  return _then(_self.copyWith(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,cards: null == cards ? _self.cards : cards // ignore: cast_nullable_to_non_nullable
as List<SutdaCard>,totalBet: null == totalBet ? _self.totalBet : totalBet // ignore: cast_nullable_to_non_nullable
as int,hasFolded: null == hasFolded ? _self.hasFolded : hasFolded // ignore: cast_nullable_to_non_nullable
as bool,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _OnlineSutdaPlayer implements OnlineSutdaPlayer {
  const _OnlineSutdaPlayer({required this.playerId, required this.playerName, required this.photoUrl, @JsonKey(toJson: cardsToJson) required final  List<SutdaCard> cards, required this.totalBet, required this.hasFolded, required this.isConnected, this.points = 0}): _cards = cards;
  factory _OnlineSutdaPlayer.fromJson(Map<String, dynamic> json) => _$OnlineSutdaPlayerFromJson(json);

@override final  String playerId;
@override final  String playerName;
@override final  String? photoUrl;
 final  List<SutdaCard> _cards;
@override@JsonKey(toJson: cardsToJson) List<SutdaCard> get cards {
  if (_cards is EqualUnmodifiableListView) return _cards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cards);
}

@override final  int totalBet;
@override final  bool hasFolded;
@override final  bool isConnected;
@override@JsonKey() final  int points;

/// Create a copy of OnlineSutdaPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnlineSutdaPlayerCopyWith<_OnlineSutdaPlayer> get copyWith => __$OnlineSutdaPlayerCopyWithImpl<_OnlineSutdaPlayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnlineSutdaPlayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnlineSutdaPlayer&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&const DeepCollectionEquality().equals(other._cards, _cards)&&(identical(other.totalBet, totalBet) || other.totalBet == totalBet)&&(identical(other.hasFolded, hasFolded) || other.hasFolded == hasFolded)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.points, points) || other.points == points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerName,photoUrl,const DeepCollectionEquality().hash(_cards),totalBet,hasFolded,isConnected,points);

@override
String toString() {
  return 'OnlineSutdaPlayer(playerId: $playerId, playerName: $playerName, photoUrl: $photoUrl, cards: $cards, totalBet: $totalBet, hasFolded: $hasFolded, isConnected: $isConnected, points: $points)';
}


}

/// @nodoc
abstract mixin class _$OnlineSutdaPlayerCopyWith<$Res> implements $OnlineSutdaPlayerCopyWith<$Res> {
  factory _$OnlineSutdaPlayerCopyWith(_OnlineSutdaPlayer value, $Res Function(_OnlineSutdaPlayer) _then) = __$OnlineSutdaPlayerCopyWithImpl;
@override @useResult
$Res call({
 String playerId, String playerName, String? photoUrl,@JsonKey(toJson: cardsToJson) List<SutdaCard> cards, int totalBet, bool hasFolded, bool isConnected, int points
});




}
/// @nodoc
class __$OnlineSutdaPlayerCopyWithImpl<$Res>
    implements _$OnlineSutdaPlayerCopyWith<$Res> {
  __$OnlineSutdaPlayerCopyWithImpl(this._self, this._then);

  final _OnlineSutdaPlayer _self;
  final $Res Function(_OnlineSutdaPlayer) _then;

/// Create a copy of OnlineSutdaPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? playerName = null,Object? photoUrl = freezed,Object? cards = null,Object? totalBet = null,Object? hasFolded = null,Object? isConnected = null,Object? points = null,}) {
  return _then(_OnlineSutdaPlayer(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,cards: null == cards ? _self._cards : cards // ignore: cast_nullable_to_non_nullable
as List<SutdaCard>,totalBet: null == totalBet ? _self.totalBet : totalBet // ignore: cast_nullable_to_non_nullable
as int,hasFolded: null == hasFolded ? _self.hasFolded : hasFolded // ignore: cast_nullable_to_non_nullable
as bool,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$OnlineSutdaGame {

 String get gameId; OnlineGameState get gameState;@JsonKey(toJson: playersToJson) List<OnlineSutdaPlayer> get players; int get currentPlayerIndex; int get pot; int get baseBet; int get currentBet; int get round;// 1 또는 2
 List<String> get bettingHistory; DateTime get createdAt; DateTime? get startedAt; bool get isGameStarted; int get maxPlayers;
/// Create a copy of OnlineSutdaGame
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnlineSutdaGameCopyWith<OnlineSutdaGame> get copyWith => _$OnlineSutdaGameCopyWithImpl<OnlineSutdaGame>(this as OnlineSutdaGame, _$identity);

  /// Serializes this OnlineSutdaGame to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnlineSutdaGame&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.gameState, gameState) || other.gameState == gameState)&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.currentPlayerIndex, currentPlayerIndex) || other.currentPlayerIndex == currentPlayerIndex)&&(identical(other.pot, pot) || other.pot == pot)&&(identical(other.baseBet, baseBet) || other.baseBet == baseBet)&&(identical(other.currentBet, currentBet) || other.currentBet == currentBet)&&(identical(other.round, round) || other.round == round)&&const DeepCollectionEquality().equals(other.bettingHistory, bettingHistory)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.isGameStarted, isGameStarted) || other.isGameStarted == isGameStarted)&&(identical(other.maxPlayers, maxPlayers) || other.maxPlayers == maxPlayers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,gameState,const DeepCollectionEquality().hash(players),currentPlayerIndex,pot,baseBet,currentBet,round,const DeepCollectionEquality().hash(bettingHistory),createdAt,startedAt,isGameStarted,maxPlayers);

@override
String toString() {
  return 'OnlineSutdaGame(gameId: $gameId, gameState: $gameState, players: $players, currentPlayerIndex: $currentPlayerIndex, pot: $pot, baseBet: $baseBet, currentBet: $currentBet, round: $round, bettingHistory: $bettingHistory, createdAt: $createdAt, startedAt: $startedAt, isGameStarted: $isGameStarted, maxPlayers: $maxPlayers)';
}


}

/// @nodoc
abstract mixin class $OnlineSutdaGameCopyWith<$Res>  {
  factory $OnlineSutdaGameCopyWith(OnlineSutdaGame value, $Res Function(OnlineSutdaGame) _then) = _$OnlineSutdaGameCopyWithImpl;
@useResult
$Res call({
 String gameId, OnlineGameState gameState,@JsonKey(toJson: playersToJson) List<OnlineSutdaPlayer> players, int currentPlayerIndex, int pot, int baseBet, int currentBet, int round, List<String> bettingHistory, DateTime createdAt, DateTime? startedAt, bool isGameStarted, int maxPlayers
});




}
/// @nodoc
class _$OnlineSutdaGameCopyWithImpl<$Res>
    implements $OnlineSutdaGameCopyWith<$Res> {
  _$OnlineSutdaGameCopyWithImpl(this._self, this._then);

  final OnlineSutdaGame _self;
  final $Res Function(OnlineSutdaGame) _then;

/// Create a copy of OnlineSutdaGame
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gameId = null,Object? gameState = null,Object? players = null,Object? currentPlayerIndex = null,Object? pot = null,Object? baseBet = null,Object? currentBet = null,Object? round = null,Object? bettingHistory = null,Object? createdAt = null,Object? startedAt = freezed,Object? isGameStarted = null,Object? maxPlayers = null,}) {
  return _then(_self.copyWith(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,gameState: null == gameState ? _self.gameState : gameState // ignore: cast_nullable_to_non_nullable
as OnlineGameState,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<OnlineSutdaPlayer>,currentPlayerIndex: null == currentPlayerIndex ? _self.currentPlayerIndex : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
as int,pot: null == pot ? _self.pot : pot // ignore: cast_nullable_to_non_nullable
as int,baseBet: null == baseBet ? _self.baseBet : baseBet // ignore: cast_nullable_to_non_nullable
as int,currentBet: null == currentBet ? _self.currentBet : currentBet // ignore: cast_nullable_to_non_nullable
as int,round: null == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as int,bettingHistory: null == bettingHistory ? _self.bettingHistory : bettingHistory // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isGameStarted: null == isGameStarted ? _self.isGameStarted : isGameStarted // ignore: cast_nullable_to_non_nullable
as bool,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _OnlineSutdaGame implements OnlineSutdaGame {
  const _OnlineSutdaGame({required this.gameId, required this.gameState, @JsonKey(toJson: playersToJson) required final  List<OnlineSutdaPlayer> players, required this.currentPlayerIndex, required this.pot, required this.baseBet, required this.currentBet, required this.round, required final  List<String> bettingHistory, required this.createdAt, required this.startedAt, this.isGameStarted = false, this.maxPlayers = 2}): _players = players,_bettingHistory = bettingHistory;
  factory _OnlineSutdaGame.fromJson(Map<String, dynamic> json) => _$OnlineSutdaGameFromJson(json);

@override final  String gameId;
@override final  OnlineGameState gameState;
 final  List<OnlineSutdaPlayer> _players;
@override@JsonKey(toJson: playersToJson) List<OnlineSutdaPlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

@override final  int currentPlayerIndex;
@override final  int pot;
@override final  int baseBet;
@override final  int currentBet;
@override final  int round;
// 1 또는 2
 final  List<String> _bettingHistory;
// 1 또는 2
@override List<String> get bettingHistory {
  if (_bettingHistory is EqualUnmodifiableListView) return _bettingHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bettingHistory);
}

@override final  DateTime createdAt;
@override final  DateTime? startedAt;
@override@JsonKey() final  bool isGameStarted;
@override@JsonKey() final  int maxPlayers;

/// Create a copy of OnlineSutdaGame
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnlineSutdaGameCopyWith<_OnlineSutdaGame> get copyWith => __$OnlineSutdaGameCopyWithImpl<_OnlineSutdaGame>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnlineSutdaGameToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnlineSutdaGame&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.gameState, gameState) || other.gameState == gameState)&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.currentPlayerIndex, currentPlayerIndex) || other.currentPlayerIndex == currentPlayerIndex)&&(identical(other.pot, pot) || other.pot == pot)&&(identical(other.baseBet, baseBet) || other.baseBet == baseBet)&&(identical(other.currentBet, currentBet) || other.currentBet == currentBet)&&(identical(other.round, round) || other.round == round)&&const DeepCollectionEquality().equals(other._bettingHistory, _bettingHistory)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.isGameStarted, isGameStarted) || other.isGameStarted == isGameStarted)&&(identical(other.maxPlayers, maxPlayers) || other.maxPlayers == maxPlayers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,gameState,const DeepCollectionEquality().hash(_players),currentPlayerIndex,pot,baseBet,currentBet,round,const DeepCollectionEquality().hash(_bettingHistory),createdAt,startedAt,isGameStarted,maxPlayers);

@override
String toString() {
  return 'OnlineSutdaGame(gameId: $gameId, gameState: $gameState, players: $players, currentPlayerIndex: $currentPlayerIndex, pot: $pot, baseBet: $baseBet, currentBet: $currentBet, round: $round, bettingHistory: $bettingHistory, createdAt: $createdAt, startedAt: $startedAt, isGameStarted: $isGameStarted, maxPlayers: $maxPlayers)';
}


}

/// @nodoc
abstract mixin class _$OnlineSutdaGameCopyWith<$Res> implements $OnlineSutdaGameCopyWith<$Res> {
  factory _$OnlineSutdaGameCopyWith(_OnlineSutdaGame value, $Res Function(_OnlineSutdaGame) _then) = __$OnlineSutdaGameCopyWithImpl;
@override @useResult
$Res call({
 String gameId, OnlineGameState gameState,@JsonKey(toJson: playersToJson) List<OnlineSutdaPlayer> players, int currentPlayerIndex, int pot, int baseBet, int currentBet, int round, List<String> bettingHistory, DateTime createdAt, DateTime? startedAt, bool isGameStarted, int maxPlayers
});




}
/// @nodoc
class __$OnlineSutdaGameCopyWithImpl<$Res>
    implements _$OnlineSutdaGameCopyWith<$Res> {
  __$OnlineSutdaGameCopyWithImpl(this._self, this._then);

  final _OnlineSutdaGame _self;
  final $Res Function(_OnlineSutdaGame) _then;

/// Create a copy of OnlineSutdaGame
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gameId = null,Object? gameState = null,Object? players = null,Object? currentPlayerIndex = null,Object? pot = null,Object? baseBet = null,Object? currentBet = null,Object? round = null,Object? bettingHistory = null,Object? createdAt = null,Object? startedAt = freezed,Object? isGameStarted = null,Object? maxPlayers = null,}) {
  return _then(_OnlineSutdaGame(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,gameState: null == gameState ? _self.gameState : gameState // ignore: cast_nullable_to_non_nullable
as OnlineGameState,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<OnlineSutdaPlayer>,currentPlayerIndex: null == currentPlayerIndex ? _self.currentPlayerIndex : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
as int,pot: null == pot ? _self.pot : pot // ignore: cast_nullable_to_non_nullable
as int,baseBet: null == baseBet ? _self.baseBet : baseBet // ignore: cast_nullable_to_non_nullable
as int,currentBet: null == currentBet ? _self.currentBet : currentBet // ignore: cast_nullable_to_non_nullable
as int,round: null == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as int,bettingHistory: null == bettingHistory ? _self._bettingHistory : bettingHistory // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isGameStarted: null == isGameStarted ? _self.isGameStarted : isGameStarted // ignore: cast_nullable_to_non_nullable
as bool,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BettingMove {

 String get playerId; BettingAction get action; int get amount; DateTime get timestamp;
/// Create a copy of BettingMove
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BettingMoveCopyWith<BettingMove> get copyWith => _$BettingMoveCopyWithImpl<BettingMove>(this as BettingMove, _$identity);

  /// Serializes this BettingMove to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BettingMove&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.action, action) || other.action == action)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,action,amount,timestamp);

@override
String toString() {
  return 'BettingMove(playerId: $playerId, action: $action, amount: $amount, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $BettingMoveCopyWith<$Res>  {
  factory $BettingMoveCopyWith(BettingMove value, $Res Function(BettingMove) _then) = _$BettingMoveCopyWithImpl;
@useResult
$Res call({
 String playerId, BettingAction action, int amount, DateTime timestamp
});




}
/// @nodoc
class _$BettingMoveCopyWithImpl<$Res>
    implements $BettingMoveCopyWith<$Res> {
  _$BettingMoveCopyWithImpl(this._self, this._then);

  final BettingMove _self;
  final $Res Function(BettingMove) _then;

/// Create a copy of BettingMove
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? action = null,Object? amount = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as BettingAction,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _BettingMove implements BettingMove {
  const _BettingMove({required this.playerId, required this.action, required this.amount, required this.timestamp});
  factory _BettingMove.fromJson(Map<String, dynamic> json) => _$BettingMoveFromJson(json);

@override final  String playerId;
@override final  BettingAction action;
@override final  int amount;
@override final  DateTime timestamp;

/// Create a copy of BettingMove
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BettingMoveCopyWith<_BettingMove> get copyWith => __$BettingMoveCopyWithImpl<_BettingMove>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BettingMoveToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BettingMove&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.action, action) || other.action == action)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,action,amount,timestamp);

@override
String toString() {
  return 'BettingMove(playerId: $playerId, action: $action, amount: $amount, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$BettingMoveCopyWith<$Res> implements $BettingMoveCopyWith<$Res> {
  factory _$BettingMoveCopyWith(_BettingMove value, $Res Function(_BettingMove) _then) = __$BettingMoveCopyWithImpl;
@override @useResult
$Res call({
 String playerId, BettingAction action, int amount, DateTime timestamp
});




}
/// @nodoc
class __$BettingMoveCopyWithImpl<$Res>
    implements _$BettingMoveCopyWith<$Res> {
  __$BettingMoveCopyWithImpl(this._self, this._then);

  final _BettingMove _self;
  final $Res Function(_BettingMove) _then;

/// Create a copy of BettingMove
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? action = null,Object? amount = null,Object? timestamp = null,}) {
  return _then(_BettingMove(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as BettingAction,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
