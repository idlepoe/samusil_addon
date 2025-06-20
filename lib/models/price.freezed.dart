// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Price {

 double get price; double get volume_24h;@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime get last_updated;
/// Create a copy of Price
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceCopyWith<Price> get copyWith => _$PriceCopyWithImpl<Price>(this as Price, _$identity);

  /// Serializes this Price to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Price&&(identical(other.price, price) || other.price == price)&&(identical(other.volume_24h, volume_24h) || other.volume_24h == volume_24h)&&(identical(other.last_updated, last_updated) || other.last_updated == last_updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,price,volume_24h,last_updated);

@override
String toString() {
  return 'Price(price: $price, volume_24h: $volume_24h, last_updated: $last_updated)';
}


}

/// @nodoc
abstract mixin class $PriceCopyWith<$Res>  {
  factory $PriceCopyWith(Price value, $Res Function(Price) _then) = _$PriceCopyWithImpl;
@useResult
$Res call({
 double price, double volume_24h,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime last_updated
});




}
/// @nodoc
class _$PriceCopyWithImpl<$Res>
    implements $PriceCopyWith<$Res> {
  _$PriceCopyWithImpl(this._self, this._then);

  final Price _self;
  final $Res Function(Price) _then;

/// Create a copy of Price
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? price = null,Object? volume_24h = null,Object? last_updated = null,}) {
  return _then(_self.copyWith(
price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,volume_24h: null == volume_24h ? _self.volume_24h : volume_24h // ignore: cast_nullable_to_non_nullable
as double,last_updated: null == last_updated ? _self.last_updated : last_updated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Price implements Price {
  const _Price({required this.price, required this.volume_24h, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) required this.last_updated});
  factory _Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);

@override final  double price;
@override final  double volume_24h;
@override@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) final  DateTime last_updated;

/// Create a copy of Price
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceCopyWith<_Price> get copyWith => __$PriceCopyWithImpl<_Price>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Price&&(identical(other.price, price) || other.price == price)&&(identical(other.volume_24h, volume_24h) || other.volume_24h == volume_24h)&&(identical(other.last_updated, last_updated) || other.last_updated == last_updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,price,volume_24h,last_updated);

@override
String toString() {
  return 'Price(price: $price, volume_24h: $volume_24h, last_updated: $last_updated)';
}


}

/// @nodoc
abstract mixin class _$PriceCopyWith<$Res> implements $PriceCopyWith<$Res> {
  factory _$PriceCopyWith(_Price value, $Res Function(_Price) _then) = __$PriceCopyWithImpl;
@override @useResult
$Res call({
 double price, double volume_24h,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime last_updated
});




}
/// @nodoc
class __$PriceCopyWithImpl<$Res>
    implements _$PriceCopyWith<$Res> {
  __$PriceCopyWithImpl(this._self, this._then);

  final _Price _self;
  final $Res Function(_Price) _then;

/// Create a copy of Price
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? price = null,Object? volume_24h = null,Object? last_updated = null,}) {
  return _then(_Price(
price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,volume_24h: null == volume_24h ? _self.volume_24h : volume_24h // ignore: cast_nullable_to_non_nullable
as double,last_updated: null == last_updated ? _self.last_updated : last_updated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
