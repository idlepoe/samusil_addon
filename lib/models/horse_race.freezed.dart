// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'horse_race.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HorseRace {

@JsonKey(fromJson: _toString) String get id;@JsonKey(fromJson: _toDateTime) DateTime get startTime;@JsonKey(fromJson: _toDateTime) DateTime get endTime;@JsonKey(fromJson: _toDateTime) DateTime get bettingEndTime; List<Horse> get horses; List<Bet> get bets;@JsonKey(fromJson: _toBool) bool get isActive;@JsonKey(fromJson: _toBool) bool get isFinished;@JsonKey(fromJson: _toInt) int get currentRound;@JsonKey(fromJson: _toInt) int get totalRounds;
/// Create a copy of HorseRace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HorseRaceCopyWith<HorseRace> get copyWith => _$HorseRaceCopyWithImpl<HorseRace>(this as HorseRace, _$identity);

  /// Serializes this HorseRace to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HorseRace&&(identical(other.id, id) || other.id == id)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.bettingEndTime, bettingEndTime) || other.bettingEndTime == bettingEndTime)&&const DeepCollectionEquality().equals(other.horses, horses)&&const DeepCollectionEquality().equals(other.bets, bets)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound)&&(identical(other.totalRounds, totalRounds) || other.totalRounds == totalRounds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,startTime,endTime,bettingEndTime,const DeepCollectionEquality().hash(horses),const DeepCollectionEquality().hash(bets),isActive,isFinished,currentRound,totalRounds);

@override
String toString() {
  return 'HorseRace(id: $id, startTime: $startTime, endTime: $endTime, bettingEndTime: $bettingEndTime, horses: $horses, bets: $bets, isActive: $isActive, isFinished: $isFinished, currentRound: $currentRound, totalRounds: $totalRounds)';
}


}

/// @nodoc
abstract mixin class $HorseRaceCopyWith<$Res>  {
  factory $HorseRaceCopyWith(HorseRace value, $Res Function(HorseRace) _then) = _$HorseRaceCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String id,@JsonKey(fromJson: _toDateTime) DateTime startTime,@JsonKey(fromJson: _toDateTime) DateTime endTime,@JsonKey(fromJson: _toDateTime) DateTime bettingEndTime, List<Horse> horses, List<Bet> bets,@JsonKey(fromJson: _toBool) bool isActive,@JsonKey(fromJson: _toBool) bool isFinished,@JsonKey(fromJson: _toInt) int currentRound,@JsonKey(fromJson: _toInt) int totalRounds
});




}
/// @nodoc
class _$HorseRaceCopyWithImpl<$Res>
    implements $HorseRaceCopyWith<$Res> {
  _$HorseRaceCopyWithImpl(this._self, this._then);

  final HorseRace _self;
  final $Res Function(HorseRace) _then;

/// Create a copy of HorseRace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? startTime = null,Object? endTime = null,Object? bettingEndTime = null,Object? horses = null,Object? bets = null,Object? isActive = null,Object? isFinished = null,Object? currentRound = null,Object? totalRounds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,bettingEndTime: null == bettingEndTime ? _self.bettingEndTime : bettingEndTime // ignore: cast_nullable_to_non_nullable
as DateTime,horses: null == horses ? _self.horses : horses // ignore: cast_nullable_to_non_nullable
as List<Horse>,bets: null == bets ? _self.bets : bets // ignore: cast_nullable_to_non_nullable
as List<Bet>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,currentRound: null == currentRound ? _self.currentRound : currentRound // ignore: cast_nullable_to_non_nullable
as int,totalRounds: null == totalRounds ? _self.totalRounds : totalRounds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _HorseRace implements HorseRace {
  const _HorseRace({@JsonKey(fromJson: _toString) required this.id, @JsonKey(fromJson: _toDateTime) required this.startTime, @JsonKey(fromJson: _toDateTime) required this.endTime, @JsonKey(fromJson: _toDateTime) required this.bettingEndTime, required final  List<Horse> horses, required final  List<Bet> bets, @JsonKey(fromJson: _toBool) required this.isActive, @JsonKey(fromJson: _toBool) required this.isFinished, @JsonKey(fromJson: _toInt) required this.currentRound, @JsonKey(fromJson: _toInt) required this.totalRounds}): _horses = horses,_bets = bets;
  factory _HorseRace.fromJson(Map<String, dynamic> json) => _$HorseRaceFromJson(json);

@override@JsonKey(fromJson: _toString) final  String id;
@override@JsonKey(fromJson: _toDateTime) final  DateTime startTime;
@override@JsonKey(fromJson: _toDateTime) final  DateTime endTime;
@override@JsonKey(fromJson: _toDateTime) final  DateTime bettingEndTime;
 final  List<Horse> _horses;
@override List<Horse> get horses {
  if (_horses is EqualUnmodifiableListView) return _horses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_horses);
}

 final  List<Bet> _bets;
@override List<Bet> get bets {
  if (_bets is EqualUnmodifiableListView) return _bets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bets);
}

@override@JsonKey(fromJson: _toBool) final  bool isActive;
@override@JsonKey(fromJson: _toBool) final  bool isFinished;
@override@JsonKey(fromJson: _toInt) final  int currentRound;
@override@JsonKey(fromJson: _toInt) final  int totalRounds;

/// Create a copy of HorseRace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HorseRaceCopyWith<_HorseRace> get copyWith => __$HorseRaceCopyWithImpl<_HorseRace>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HorseRaceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HorseRace&&(identical(other.id, id) || other.id == id)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.bettingEndTime, bettingEndTime) || other.bettingEndTime == bettingEndTime)&&const DeepCollectionEquality().equals(other._horses, _horses)&&const DeepCollectionEquality().equals(other._bets, _bets)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&(identical(other.currentRound, currentRound) || other.currentRound == currentRound)&&(identical(other.totalRounds, totalRounds) || other.totalRounds == totalRounds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,startTime,endTime,bettingEndTime,const DeepCollectionEquality().hash(_horses),const DeepCollectionEquality().hash(_bets),isActive,isFinished,currentRound,totalRounds);

@override
String toString() {
  return 'HorseRace(id: $id, startTime: $startTime, endTime: $endTime, bettingEndTime: $bettingEndTime, horses: $horses, bets: $bets, isActive: $isActive, isFinished: $isFinished, currentRound: $currentRound, totalRounds: $totalRounds)';
}


}

/// @nodoc
abstract mixin class _$HorseRaceCopyWith<$Res> implements $HorseRaceCopyWith<$Res> {
  factory _$HorseRaceCopyWith(_HorseRace value, $Res Function(_HorseRace) _then) = __$HorseRaceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String id,@JsonKey(fromJson: _toDateTime) DateTime startTime,@JsonKey(fromJson: _toDateTime) DateTime endTime,@JsonKey(fromJson: _toDateTime) DateTime bettingEndTime, List<Horse> horses, List<Bet> bets,@JsonKey(fromJson: _toBool) bool isActive,@JsonKey(fromJson: _toBool) bool isFinished,@JsonKey(fromJson: _toInt) int currentRound,@JsonKey(fromJson: _toInt) int totalRounds
});




}
/// @nodoc
class __$HorseRaceCopyWithImpl<$Res>
    implements _$HorseRaceCopyWith<$Res> {
  __$HorseRaceCopyWithImpl(this._self, this._then);

  final _HorseRace _self;
  final $Res Function(_HorseRace) _then;

/// Create a copy of HorseRace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? startTime = null,Object? endTime = null,Object? bettingEndTime = null,Object? horses = null,Object? bets = null,Object? isActive = null,Object? isFinished = null,Object? currentRound = null,Object? totalRounds = null,}) {
  return _then(_HorseRace(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,bettingEndTime: null == bettingEndTime ? _self.bettingEndTime : bettingEndTime // ignore: cast_nullable_to_non_nullable
as DateTime,horses: null == horses ? _self._horses : horses // ignore: cast_nullable_to_non_nullable
as List<Horse>,bets: null == bets ? _self._bets : bets // ignore: cast_nullable_to_non_nullable
as List<Bet>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,currentRound: null == currentRound ? _self.currentRound : currentRound // ignore: cast_nullable_to_non_nullable
as int,totalRounds: null == totalRounds ? _self.totalRounds : totalRounds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Horse {

@JsonKey(fromJson: _toString) String get coinId;@JsonKey(fromJson: _toString) String get name;@JsonKey(fromJson: _toString) String get symbol;@JsonKey(fromJson: _toDouble) double get currentPosition; List<double> get movements;@JsonKey(fromJson: _toDouble) double get lastPrice;@JsonKey(fromJson: _toDouble) double get previousPrice;
/// Create a copy of Horse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HorseCopyWith<Horse> get copyWith => _$HorseCopyWithImpl<Horse>(this as Horse, _$identity);

  /// Serializes this Horse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Horse&&(identical(other.coinId, coinId) || other.coinId == coinId)&&(identical(other.name, name) || other.name == name)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.currentPosition, currentPosition) || other.currentPosition == currentPosition)&&const DeepCollectionEquality().equals(other.movements, movements)&&(identical(other.lastPrice, lastPrice) || other.lastPrice == lastPrice)&&(identical(other.previousPrice, previousPrice) || other.previousPrice == previousPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coinId,name,symbol,currentPosition,const DeepCollectionEquality().hash(movements),lastPrice,previousPrice);

@override
String toString() {
  return 'Horse(coinId: $coinId, name: $name, symbol: $symbol, currentPosition: $currentPosition, movements: $movements, lastPrice: $lastPrice, previousPrice: $previousPrice)';
}


}

/// @nodoc
abstract mixin class $HorseCopyWith<$Res>  {
  factory $HorseCopyWith(Horse value, $Res Function(Horse) _then) = _$HorseCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String coinId,@JsonKey(fromJson: _toString) String name,@JsonKey(fromJson: _toString) String symbol,@JsonKey(fromJson: _toDouble) double currentPosition, List<double> movements,@JsonKey(fromJson: _toDouble) double lastPrice,@JsonKey(fromJson: _toDouble) double previousPrice
});




}
/// @nodoc
class _$HorseCopyWithImpl<$Res>
    implements $HorseCopyWith<$Res> {
  _$HorseCopyWithImpl(this._self, this._then);

  final Horse _self;
  final $Res Function(Horse) _then;

/// Create a copy of Horse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coinId = null,Object? name = null,Object? symbol = null,Object? currentPosition = null,Object? movements = null,Object? lastPrice = null,Object? previousPrice = null,}) {
  return _then(_self.copyWith(
coinId: null == coinId ? _self.coinId : coinId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,currentPosition: null == currentPosition ? _self.currentPosition : currentPosition // ignore: cast_nullable_to_non_nullable
as double,movements: null == movements ? _self.movements : movements // ignore: cast_nullable_to_non_nullable
as List<double>,lastPrice: null == lastPrice ? _self.lastPrice : lastPrice // ignore: cast_nullable_to_non_nullable
as double,previousPrice: null == previousPrice ? _self.previousPrice : previousPrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Horse implements Horse {
  const _Horse({@JsonKey(fromJson: _toString) required this.coinId, @JsonKey(fromJson: _toString) required this.name, @JsonKey(fromJson: _toString) required this.symbol, @JsonKey(fromJson: _toDouble) required this.currentPosition, required final  List<double> movements, @JsonKey(fromJson: _toDouble) required this.lastPrice, @JsonKey(fromJson: _toDouble) required this.previousPrice}): _movements = movements;
  factory _Horse.fromJson(Map<String, dynamic> json) => _$HorseFromJson(json);

@override@JsonKey(fromJson: _toString) final  String coinId;
@override@JsonKey(fromJson: _toString) final  String name;
@override@JsonKey(fromJson: _toString) final  String symbol;
@override@JsonKey(fromJson: _toDouble) final  double currentPosition;
 final  List<double> _movements;
@override List<double> get movements {
  if (_movements is EqualUnmodifiableListView) return _movements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_movements);
}

@override@JsonKey(fromJson: _toDouble) final  double lastPrice;
@override@JsonKey(fromJson: _toDouble) final  double previousPrice;

/// Create a copy of Horse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HorseCopyWith<_Horse> get copyWith => __$HorseCopyWithImpl<_Horse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HorseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Horse&&(identical(other.coinId, coinId) || other.coinId == coinId)&&(identical(other.name, name) || other.name == name)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.currentPosition, currentPosition) || other.currentPosition == currentPosition)&&const DeepCollectionEquality().equals(other._movements, _movements)&&(identical(other.lastPrice, lastPrice) || other.lastPrice == lastPrice)&&(identical(other.previousPrice, previousPrice) || other.previousPrice == previousPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coinId,name,symbol,currentPosition,const DeepCollectionEquality().hash(_movements),lastPrice,previousPrice);

@override
String toString() {
  return 'Horse(coinId: $coinId, name: $name, symbol: $symbol, currentPosition: $currentPosition, movements: $movements, lastPrice: $lastPrice, previousPrice: $previousPrice)';
}


}

/// @nodoc
abstract mixin class _$HorseCopyWith<$Res> implements $HorseCopyWith<$Res> {
  factory _$HorseCopyWith(_Horse value, $Res Function(_Horse) _then) = __$HorseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String coinId,@JsonKey(fromJson: _toString) String name,@JsonKey(fromJson: _toString) String symbol,@JsonKey(fromJson: _toDouble) double currentPosition, List<double> movements,@JsonKey(fromJson: _toDouble) double lastPrice,@JsonKey(fromJson: _toDouble) double previousPrice
});




}
/// @nodoc
class __$HorseCopyWithImpl<$Res>
    implements _$HorseCopyWith<$Res> {
  __$HorseCopyWithImpl(this._self, this._then);

  final _Horse _self;
  final $Res Function(_Horse) _then;

/// Create a copy of Horse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coinId = null,Object? name = null,Object? symbol = null,Object? currentPosition = null,Object? movements = null,Object? lastPrice = null,Object? previousPrice = null,}) {
  return _then(_Horse(
coinId: null == coinId ? _self.coinId : coinId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,currentPosition: null == currentPosition ? _self.currentPosition : currentPosition // ignore: cast_nullable_to_non_nullable
as double,movements: null == movements ? _self._movements : movements // ignore: cast_nullable_to_non_nullable
as List<double>,lastPrice: null == lastPrice ? _self.lastPrice : lastPrice // ignore: cast_nullable_to_non_nullable
as double,previousPrice: null == previousPrice ? _self.previousPrice : previousPrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$Bet {

@JsonKey(fromJson: _toString) String get id;@JsonKey(fromJson: _toString) String get userId;@JsonKey(fromJson: _toString) String get userName;@JsonKey(fromJson: _toString) String get raceId;@JsonKey(fromJson: _toString) String get betType;// 'winner', 'top2', 'top3'
@JsonKey(fromJson: _toString) String get selectedHorseId;@JsonKey(fromJson: _toInt) int get betAmount;@JsonKey(fromJson: _toDateTime) DateTime get betTime;@JsonKey(fromJson: _toBool) bool get isWon;@JsonKey(fromJson: _toInt) int get wonAmount;
/// Create a copy of Bet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BetCopyWith<Bet> get copyWith => _$BetCopyWithImpl<Bet>(this as Bet, _$identity);

  /// Serializes this Bet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bet&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.raceId, raceId) || other.raceId == raceId)&&(identical(other.betType, betType) || other.betType == betType)&&(identical(other.selectedHorseId, selectedHorseId) || other.selectedHorseId == selectedHorseId)&&(identical(other.betAmount, betAmount) || other.betAmount == betAmount)&&(identical(other.betTime, betTime) || other.betTime == betTime)&&(identical(other.isWon, isWon) || other.isWon == isWon)&&(identical(other.wonAmount, wonAmount) || other.wonAmount == wonAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,raceId,betType,selectedHorseId,betAmount,betTime,isWon,wonAmount);

@override
String toString() {
  return 'Bet(id: $id, userId: $userId, userName: $userName, raceId: $raceId, betType: $betType, selectedHorseId: $selectedHorseId, betAmount: $betAmount, betTime: $betTime, isWon: $isWon, wonAmount: $wonAmount)';
}


}

/// @nodoc
abstract mixin class $BetCopyWith<$Res>  {
  factory $BetCopyWith(Bet value, $Res Function(Bet) _then) = _$BetCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String id,@JsonKey(fromJson: _toString) String userId,@JsonKey(fromJson: _toString) String userName,@JsonKey(fromJson: _toString) String raceId,@JsonKey(fromJson: _toString) String betType,@JsonKey(fromJson: _toString) String selectedHorseId,@JsonKey(fromJson: _toInt) int betAmount,@JsonKey(fromJson: _toDateTime) DateTime betTime,@JsonKey(fromJson: _toBool) bool isWon,@JsonKey(fromJson: _toInt) int wonAmount
});




}
/// @nodoc
class _$BetCopyWithImpl<$Res>
    implements $BetCopyWith<$Res> {
  _$BetCopyWithImpl(this._self, this._then);

  final Bet _self;
  final $Res Function(Bet) _then;

/// Create a copy of Bet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? raceId = null,Object? betType = null,Object? selectedHorseId = null,Object? betAmount = null,Object? betTime = null,Object? isWon = null,Object? wonAmount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,raceId: null == raceId ? _self.raceId : raceId // ignore: cast_nullable_to_non_nullable
as String,betType: null == betType ? _self.betType : betType // ignore: cast_nullable_to_non_nullable
as String,selectedHorseId: null == selectedHorseId ? _self.selectedHorseId : selectedHorseId // ignore: cast_nullable_to_non_nullable
as String,betAmount: null == betAmount ? _self.betAmount : betAmount // ignore: cast_nullable_to_non_nullable
as int,betTime: null == betTime ? _self.betTime : betTime // ignore: cast_nullable_to_non_nullable
as DateTime,isWon: null == isWon ? _self.isWon : isWon // ignore: cast_nullable_to_non_nullable
as bool,wonAmount: null == wonAmount ? _self.wonAmount : wonAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Bet implements Bet {
  const _Bet({@JsonKey(fromJson: _toString) required this.id, @JsonKey(fromJson: _toString) required this.userId, @JsonKey(fromJson: _toString) required this.userName, @JsonKey(fromJson: _toString) required this.raceId, @JsonKey(fromJson: _toString) required this.betType, @JsonKey(fromJson: _toString) required this.selectedHorseId, @JsonKey(fromJson: _toInt) required this.betAmount, @JsonKey(fromJson: _toDateTime) required this.betTime, @JsonKey(fromJson: _toBool) required this.isWon, @JsonKey(fromJson: _toInt) required this.wonAmount});
  factory _Bet.fromJson(Map<String, dynamic> json) => _$BetFromJson(json);

@override@JsonKey(fromJson: _toString) final  String id;
@override@JsonKey(fromJson: _toString) final  String userId;
@override@JsonKey(fromJson: _toString) final  String userName;
@override@JsonKey(fromJson: _toString) final  String raceId;
@override@JsonKey(fromJson: _toString) final  String betType;
// 'winner', 'top2', 'top3'
@override@JsonKey(fromJson: _toString) final  String selectedHorseId;
@override@JsonKey(fromJson: _toInt) final  int betAmount;
@override@JsonKey(fromJson: _toDateTime) final  DateTime betTime;
@override@JsonKey(fromJson: _toBool) final  bool isWon;
@override@JsonKey(fromJson: _toInt) final  int wonAmount;

/// Create a copy of Bet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BetCopyWith<_Bet> get copyWith => __$BetCopyWithImpl<_Bet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bet&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.raceId, raceId) || other.raceId == raceId)&&(identical(other.betType, betType) || other.betType == betType)&&(identical(other.selectedHorseId, selectedHorseId) || other.selectedHorseId == selectedHorseId)&&(identical(other.betAmount, betAmount) || other.betAmount == betAmount)&&(identical(other.betTime, betTime) || other.betTime == betTime)&&(identical(other.isWon, isWon) || other.isWon == isWon)&&(identical(other.wonAmount, wonAmount) || other.wonAmount == wonAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,raceId,betType,selectedHorseId,betAmount,betTime,isWon,wonAmount);

@override
String toString() {
  return 'Bet(id: $id, userId: $userId, userName: $userName, raceId: $raceId, betType: $betType, selectedHorseId: $selectedHorseId, betAmount: $betAmount, betTime: $betTime, isWon: $isWon, wonAmount: $wonAmount)';
}


}

/// @nodoc
abstract mixin class _$BetCopyWith<$Res> implements $BetCopyWith<$Res> {
  factory _$BetCopyWith(_Bet value, $Res Function(_Bet) _then) = __$BetCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String id,@JsonKey(fromJson: _toString) String userId,@JsonKey(fromJson: _toString) String userName,@JsonKey(fromJson: _toString) String raceId,@JsonKey(fromJson: _toString) String betType,@JsonKey(fromJson: _toString) String selectedHorseId,@JsonKey(fromJson: _toInt) int betAmount,@JsonKey(fromJson: _toDateTime) DateTime betTime,@JsonKey(fromJson: _toBool) bool isWon,@JsonKey(fromJson: _toInt) int wonAmount
});




}
/// @nodoc
class __$BetCopyWithImpl<$Res>
    implements _$BetCopyWith<$Res> {
  __$BetCopyWithImpl(this._self, this._then);

  final _Bet _self;
  final $Res Function(_Bet) _then;

/// Create a copy of Bet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? raceId = null,Object? betType = null,Object? selectedHorseId = null,Object? betAmount = null,Object? betTime = null,Object? isWon = null,Object? wonAmount = null,}) {
  return _then(_Bet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,raceId: null == raceId ? _self.raceId : raceId // ignore: cast_nullable_to_non_nullable
as String,betType: null == betType ? _self.betType : betType // ignore: cast_nullable_to_non_nullable
as String,selectedHorseId: null == selectedHorseId ? _self.selectedHorseId : selectedHorseId // ignore: cast_nullable_to_non_nullable
as String,betAmount: null == betAmount ? _self.betAmount : betAmount // ignore: cast_nullable_to_non_nullable
as int,betTime: null == betTime ? _self.betTime : betTime // ignore: cast_nullable_to_non_nullable
as DateTime,isWon: null == isWon ? _self.isWon : isWon // ignore: cast_nullable_to_non_nullable
as bool,wonAmount: null == wonAmount ? _self.wonAmount : wonAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
