// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Coin {

 String get id; String get name; String get symbol; int get rank; bool get is_active; List<Price>? get price_history; List<double>? get diffList; double? get diffPercentage; double? get color;
/// Create a copy of Coin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoinCopyWith<Coin> get copyWith => _$CoinCopyWithImpl<Coin>(this as Coin, _$identity);

  /// Serializes this Coin to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Coin&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.is_active, is_active) || other.is_active == is_active)&&const DeepCollectionEquality().equals(other.price_history, price_history)&&const DeepCollectionEquality().equals(other.diffList, diffList)&&(identical(other.diffPercentage, diffPercentage) || other.diffPercentage == diffPercentage)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,symbol,rank,is_active,const DeepCollectionEquality().hash(price_history),const DeepCollectionEquality().hash(diffList),diffPercentage,color);

@override
String toString() {
  return 'Coin(id: $id, name: $name, symbol: $symbol, rank: $rank, is_active: $is_active, price_history: $price_history, diffList: $diffList, diffPercentage: $diffPercentage, color: $color)';
}


}

/// @nodoc
abstract mixin class $CoinCopyWith<$Res>  {
  factory $CoinCopyWith(Coin value, $Res Function(Coin) _then) = _$CoinCopyWithImpl;
@useResult
$Res call({
 String id, String name, String symbol, int rank, bool is_active, List<Price>? price_history, List<double>? diffList, double? diffPercentage, double? color
});




}
/// @nodoc
class _$CoinCopyWithImpl<$Res>
    implements $CoinCopyWith<$Res> {
  _$CoinCopyWithImpl(this._self, this._then);

  final Coin _self;
  final $Res Function(Coin) _then;

/// Create a copy of Coin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? symbol = null,Object? rank = null,Object? is_active = null,Object? price_history = freezed,Object? diffList = freezed,Object? diffPercentage = freezed,Object? color = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,is_active: null == is_active ? _self.is_active : is_active // ignore: cast_nullable_to_non_nullable
as bool,price_history: freezed == price_history ? _self.price_history : price_history // ignore: cast_nullable_to_non_nullable
as List<Price>?,diffList: freezed == diffList ? _self.diffList : diffList // ignore: cast_nullable_to_non_nullable
as List<double>?,diffPercentage: freezed == diffPercentage ? _self.diffPercentage : diffPercentage // ignore: cast_nullable_to_non_nullable
as double?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Coin implements Coin {
  const _Coin({required this.id, required this.name, required this.symbol, required this.rank, required this.is_active, final  List<Price>? price_history, final  List<double>? diffList, this.diffPercentage, this.color}): _price_history = price_history,_diffList = diffList;
  factory _Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);

@override final  String id;
@override final  String name;
@override final  String symbol;
@override final  int rank;
@override final  bool is_active;
 final  List<Price>? _price_history;
@override List<Price>? get price_history {
  final value = _price_history;
  if (value == null) return null;
  if (_price_history is EqualUnmodifiableListView) return _price_history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<double>? _diffList;
@override List<double>? get diffList {
  final value = _diffList;
  if (value == null) return null;
  if (_diffList is EqualUnmodifiableListView) return _diffList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  double? diffPercentage;
@override final  double? color;

/// Create a copy of Coin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoinCopyWith<_Coin> get copyWith => __$CoinCopyWithImpl<_Coin>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoinToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Coin&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.is_active, is_active) || other.is_active == is_active)&&const DeepCollectionEquality().equals(other._price_history, _price_history)&&const DeepCollectionEquality().equals(other._diffList, _diffList)&&(identical(other.diffPercentage, diffPercentage) || other.diffPercentage == diffPercentage)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,symbol,rank,is_active,const DeepCollectionEquality().hash(_price_history),const DeepCollectionEquality().hash(_diffList),diffPercentage,color);

@override
String toString() {
  return 'Coin(id: $id, name: $name, symbol: $symbol, rank: $rank, is_active: $is_active, price_history: $price_history, diffList: $diffList, diffPercentage: $diffPercentage, color: $color)';
}


}

/// @nodoc
abstract mixin class _$CoinCopyWith<$Res> implements $CoinCopyWith<$Res> {
  factory _$CoinCopyWith(_Coin value, $Res Function(_Coin) _then) = __$CoinCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String symbol, int rank, bool is_active, List<Price>? price_history, List<double>? diffList, double? diffPercentage, double? color
});




}
/// @nodoc
class __$CoinCopyWithImpl<$Res>
    implements _$CoinCopyWith<$Res> {
  __$CoinCopyWithImpl(this._self, this._then);

  final _Coin _self;
  final $Res Function(_Coin) _then;

/// Create a copy of Coin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? symbol = null,Object? rank = null,Object? is_active = null,Object? price_history = freezed,Object? diffList = freezed,Object? diffPercentage = freezed,Object? color = freezed,}) {
  return _then(_Coin(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,is_active: null == is_active ? _self.is_active : is_active // ignore: cast_nullable_to_non_nullable
as bool,price_history: freezed == price_history ? _self._price_history : price_history // ignore: cast_nullable_to_non_nullable
as List<Price>?,diffList: freezed == diffList ? _self._diffList : diffList // ignore: cast_nullable_to_non_nullable
as List<double>?,diffPercentage: freezed == diffPercentage ? _self.diffPercentage : diffPercentage // ignore: cast_nullable_to_non_nullable
as double?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
