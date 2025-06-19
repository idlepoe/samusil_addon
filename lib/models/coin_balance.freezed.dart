// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coin_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoinBalance {

 String get id; String get name; double get price; int get quantity; int? get total; String get created_at; double? get profit;@JsonKey(fromJson: _toCoinBalanceList) List<CoinBalance>? get sub_list; double? get current_price;
/// Create a copy of CoinBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoinBalanceCopyWith<CoinBalance> get copyWith => _$CoinBalanceCopyWithImpl<CoinBalance>(this as CoinBalance, _$identity);

  /// Serializes this CoinBalance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoinBalance&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.total, total) || other.total == total)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.profit, profit) || other.profit == profit)&&const DeepCollectionEquality().equals(other.sub_list, sub_list)&&(identical(other.current_price, current_price) || other.current_price == current_price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,quantity,total,created_at,profit,const DeepCollectionEquality().hash(sub_list),current_price);

@override
String toString() {
  return 'CoinBalance(id: $id, name: $name, price: $price, quantity: $quantity, total: $total, created_at: $created_at, profit: $profit, sub_list: $sub_list, current_price: $current_price)';
}


}

/// @nodoc
abstract mixin class $CoinBalanceCopyWith<$Res>  {
  factory $CoinBalanceCopyWith(CoinBalance value, $Res Function(CoinBalance) _then) = _$CoinBalanceCopyWithImpl;
@useResult
$Res call({
 String id, String name, double price, int quantity, int? total, String created_at, double? profit,@JsonKey(fromJson: _toCoinBalanceList) List<CoinBalance>? sub_list, double? current_price
});




}
/// @nodoc
class _$CoinBalanceCopyWithImpl<$Res>
    implements $CoinBalanceCopyWith<$Res> {
  _$CoinBalanceCopyWithImpl(this._self, this._then);

  final CoinBalance _self;
  final $Res Function(CoinBalance) _then;

/// Create a copy of CoinBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? price = null,Object? quantity = null,Object? total = freezed,Object? created_at = null,Object? profit = freezed,Object? sub_list = freezed,Object? current_price = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as String,profit: freezed == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double?,sub_list: freezed == sub_list ? _self.sub_list : sub_list // ignore: cast_nullable_to_non_nullable
as List<CoinBalance>?,current_price: freezed == current_price ? _self.current_price : current_price // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _CoinBalance implements CoinBalance {
  const _CoinBalance({required this.id, required this.name, required this.price, required this.quantity, this.total, required this.created_at, this.profit, @JsonKey(fromJson: _toCoinBalanceList) final  List<CoinBalance>? sub_list, this.current_price}): _sub_list = sub_list;
  factory _CoinBalance.fromJson(Map<String, dynamic> json) => _$CoinBalanceFromJson(json);

@override final  String id;
@override final  String name;
@override final  double price;
@override final  int quantity;
@override final  int? total;
@override final  String created_at;
@override final  double? profit;
 final  List<CoinBalance>? _sub_list;
@override@JsonKey(fromJson: _toCoinBalanceList) List<CoinBalance>? get sub_list {
  final value = _sub_list;
  if (value == null) return null;
  if (_sub_list is EqualUnmodifiableListView) return _sub_list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  double? current_price;

/// Create a copy of CoinBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoinBalanceCopyWith<_CoinBalance> get copyWith => __$CoinBalanceCopyWithImpl<_CoinBalance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoinBalanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoinBalance&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.total, total) || other.total == total)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.profit, profit) || other.profit == profit)&&const DeepCollectionEquality().equals(other._sub_list, _sub_list)&&(identical(other.current_price, current_price) || other.current_price == current_price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,quantity,total,created_at,profit,const DeepCollectionEquality().hash(_sub_list),current_price);

@override
String toString() {
  return 'CoinBalance(id: $id, name: $name, price: $price, quantity: $quantity, total: $total, created_at: $created_at, profit: $profit, sub_list: $sub_list, current_price: $current_price)';
}


}

/// @nodoc
abstract mixin class _$CoinBalanceCopyWith<$Res> implements $CoinBalanceCopyWith<$Res> {
  factory _$CoinBalanceCopyWith(_CoinBalance value, $Res Function(_CoinBalance) _then) = __$CoinBalanceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double price, int quantity, int? total, String created_at, double? profit,@JsonKey(fromJson: _toCoinBalanceList) List<CoinBalance>? sub_list, double? current_price
});




}
/// @nodoc
class __$CoinBalanceCopyWithImpl<$Res>
    implements _$CoinBalanceCopyWith<$Res> {
  __$CoinBalanceCopyWithImpl(this._self, this._then);

  final _CoinBalance _self;
  final $Res Function(_CoinBalance) _then;

/// Create a copy of CoinBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? price = null,Object? quantity = null,Object? total = freezed,Object? created_at = null,Object? profit = freezed,Object? sub_list = freezed,Object? current_price = freezed,}) {
  return _then(_CoinBalance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as String,profit: freezed == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double?,sub_list: freezed == sub_list ? _self._sub_list : sub_list // ignore: cast_nullable_to_non_nullable
as List<CoinBalance>?,current_price: freezed == current_price ? _self.current_price : current_price // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
