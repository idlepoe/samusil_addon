// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coin_price.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoinPrice {

 String? get id; String? get name;@JsonKey(fromJson: _toDouble) double get price;@JsonKey(fromJson: _toDouble) double get volume_24h; String get last_updated;
/// Create a copy of CoinPrice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoinPriceCopyWith<CoinPrice> get copyWith => _$CoinPriceCopyWithImpl<CoinPrice>(this as CoinPrice, _$identity);

  /// Serializes this CoinPrice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoinPrice&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.volume_24h, volume_24h) || other.volume_24h == volume_24h)&&(identical(other.last_updated, last_updated) || other.last_updated == last_updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,volume_24h,last_updated);

@override
String toString() {
  return 'CoinPrice(id: $id, name: $name, price: $price, volume_24h: $volume_24h, last_updated: $last_updated)';
}


}

/// @nodoc
abstract mixin class $CoinPriceCopyWith<$Res>  {
  factory $CoinPriceCopyWith(CoinPrice value, $Res Function(CoinPrice) _then) = _$CoinPriceCopyWithImpl;
@useResult
$Res call({
 String? id, String? name,@JsonKey(fromJson: _toDouble) double price,@JsonKey(fromJson: _toDouble) double volume_24h, String last_updated
});




}
/// @nodoc
class _$CoinPriceCopyWithImpl<$Res>
    implements $CoinPriceCopyWith<$Res> {
  _$CoinPriceCopyWithImpl(this._self, this._then);

  final CoinPrice _self;
  final $Res Function(CoinPrice) _then;

/// Create a copy of CoinPrice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? price = null,Object? volume_24h = null,Object? last_updated = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,volume_24h: null == volume_24h ? _self.volume_24h : volume_24h // ignore: cast_nullable_to_non_nullable
as double,last_updated: null == last_updated ? _self.last_updated : last_updated // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _CoinPrice implements CoinPrice {
  const _CoinPrice({this.id, this.name, @JsonKey(fromJson: _toDouble) required this.price, @JsonKey(fromJson: _toDouble) required this.volume_24h, required this.last_updated});
  factory _CoinPrice.fromJson(Map<String, dynamic> json) => _$CoinPriceFromJson(json);

@override final  String? id;
@override final  String? name;
@override@JsonKey(fromJson: _toDouble) final  double price;
@override@JsonKey(fromJson: _toDouble) final  double volume_24h;
@override final  String last_updated;

/// Create a copy of CoinPrice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoinPriceCopyWith<_CoinPrice> get copyWith => __$CoinPriceCopyWithImpl<_CoinPrice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoinPriceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoinPrice&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.volume_24h, volume_24h) || other.volume_24h == volume_24h)&&(identical(other.last_updated, last_updated) || other.last_updated == last_updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,volume_24h,last_updated);

@override
String toString() {
  return 'CoinPrice(id: $id, name: $name, price: $price, volume_24h: $volume_24h, last_updated: $last_updated)';
}


}

/// @nodoc
abstract mixin class _$CoinPriceCopyWith<$Res> implements $CoinPriceCopyWith<$Res> {
  factory _$CoinPriceCopyWith(_CoinPrice value, $Res Function(_CoinPrice) _then) = __$CoinPriceCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name,@JsonKey(fromJson: _toDouble) double price,@JsonKey(fromJson: _toDouble) double volume_24h, String last_updated
});




}
/// @nodoc
class __$CoinPriceCopyWithImpl<$Res>
    implements _$CoinPriceCopyWith<$Res> {
  __$CoinPriceCopyWithImpl(this._self, this._then);

  final _CoinPrice _self;
  final $Res Function(_CoinPrice) _then;

/// Create a copy of CoinPrice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? price = null,Object? volume_24h = null,Object? last_updated = null,}) {
  return _then(_CoinPrice(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,volume_24h: null == volume_24h ? _self.volume_24h : volume_24h // ignore: cast_nullable_to_non_nullable
as double,last_updated: null == last_updated ? _self.last_updated : last_updated // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
