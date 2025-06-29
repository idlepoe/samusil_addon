// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sutda_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SutdaCard {

 int get month; String get type; int get value;
/// Create a copy of SutdaCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SutdaCardCopyWith<SutdaCard> get copyWith => _$SutdaCardCopyWithImpl<SutdaCard>(this as SutdaCard, _$identity);

  /// Serializes this SutdaCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SutdaCard&&(identical(other.month, month) || other.month == month)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,type,value);

@override
String toString() {
  return 'SutdaCard(month: $month, type: $type, value: $value)';
}


}

/// @nodoc
abstract mixin class $SutdaCardCopyWith<$Res>  {
  factory $SutdaCardCopyWith(SutdaCard value, $Res Function(SutdaCard) _then) = _$SutdaCardCopyWithImpl;
@useResult
$Res call({
 int month, String type, int value
});




}
/// @nodoc
class _$SutdaCardCopyWithImpl<$Res>
    implements $SutdaCardCopyWith<$Res> {
  _$SutdaCardCopyWithImpl(this._self, this._then);

  final SutdaCard _self;
  final $Res Function(SutdaCard) _then;

/// Create a copy of SutdaCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? type = null,Object? value = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SutdaCard implements SutdaCard {
  const _SutdaCard({required this.month, required this.type, required this.value});
  factory _SutdaCard.fromJson(Map<String, dynamic> json) => _$SutdaCardFromJson(json);

@override final  int month;
@override final  String type;
@override final  int value;

/// Create a copy of SutdaCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SutdaCardCopyWith<_SutdaCard> get copyWith => __$SutdaCardCopyWithImpl<_SutdaCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SutdaCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SutdaCard&&(identical(other.month, month) || other.month == month)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,type,value);

@override
String toString() {
  return 'SutdaCard(month: $month, type: $type, value: $value)';
}


}

/// @nodoc
abstract mixin class _$SutdaCardCopyWith<$Res> implements $SutdaCardCopyWith<$Res> {
  factory _$SutdaCardCopyWith(_SutdaCard value, $Res Function(_SutdaCard) _then) = __$SutdaCardCopyWithImpl;
@override @useResult
$Res call({
 int month, String type, int value
});




}
/// @nodoc
class __$SutdaCardCopyWithImpl<$Res>
    implements _$SutdaCardCopyWith<$Res> {
  __$SutdaCardCopyWithImpl(this._self, this._then);

  final _SutdaCard _self;
  final $Res Function(_SutdaCard) _then;

/// Create a copy of SutdaCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? type = null,Object? value = null,}) {
  return _then(_SutdaCard(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SutdaHand {

 String get name; int get rank; int get value;
/// Create a copy of SutdaHand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SutdaHandCopyWith<SutdaHand> get copyWith => _$SutdaHandCopyWithImpl<SutdaHand>(this as SutdaHand, _$identity);

  /// Serializes this SutdaHand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SutdaHand&&(identical(other.name, name) || other.name == name)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,rank,value);

@override
String toString() {
  return 'SutdaHand(name: $name, rank: $rank, value: $value)';
}


}

/// @nodoc
abstract mixin class $SutdaHandCopyWith<$Res>  {
  factory $SutdaHandCopyWith(SutdaHand value, $Res Function(SutdaHand) _then) = _$SutdaHandCopyWithImpl;
@useResult
$Res call({
 String name, int rank, int value
});




}
/// @nodoc
class _$SutdaHandCopyWithImpl<$Res>
    implements $SutdaHandCopyWith<$Res> {
  _$SutdaHandCopyWithImpl(this._self, this._then);

  final SutdaHand _self;
  final $Res Function(SutdaHand) _then;

/// Create a copy of SutdaHand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? rank = null,Object? value = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SutdaHand implements SutdaHand {
  const _SutdaHand({required this.name, required this.rank, required this.value});
  factory _SutdaHand.fromJson(Map<String, dynamic> json) => _$SutdaHandFromJson(json);

@override final  String name;
@override final  int rank;
@override final  int value;

/// Create a copy of SutdaHand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SutdaHandCopyWith<_SutdaHand> get copyWith => __$SutdaHandCopyWithImpl<_SutdaHand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SutdaHandToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SutdaHand&&(identical(other.name, name) || other.name == name)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,rank,value);

@override
String toString() {
  return 'SutdaHand(name: $name, rank: $rank, value: $value)';
}


}

/// @nodoc
abstract mixin class _$SutdaHandCopyWith<$Res> implements $SutdaHandCopyWith<$Res> {
  factory _$SutdaHandCopyWith(_SutdaHand value, $Res Function(_SutdaHand) _then) = __$SutdaHandCopyWithImpl;
@override @useResult
$Res call({
 String name, int rank, int value
});




}
/// @nodoc
class __$SutdaHandCopyWithImpl<$Res>
    implements _$SutdaHandCopyWith<$Res> {
  __$SutdaHandCopyWithImpl(this._self, this._then);

  final _SutdaHand _self;
  final $Res Function(_SutdaHand) _then;

/// Create a copy of SutdaHand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? rank = null,Object? value = null,}) {
  return _then(_SutdaHand(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
