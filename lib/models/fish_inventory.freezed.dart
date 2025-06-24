// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fish_inventory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FishInventory {

 String get fishId; String get fishName; int get caughtCount;// 총 잡은 횟수
 int get currentCount;// 현재 보유 수량
 DateTime get lastCaughtAt;
/// Create a copy of FishInventory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FishInventoryCopyWith<FishInventory> get copyWith => _$FishInventoryCopyWithImpl<FishInventory>(this as FishInventory, _$identity);

  /// Serializes this FishInventory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FishInventory&&(identical(other.fishId, fishId) || other.fishId == fishId)&&(identical(other.fishName, fishName) || other.fishName == fishName)&&(identical(other.caughtCount, caughtCount) || other.caughtCount == caughtCount)&&(identical(other.currentCount, currentCount) || other.currentCount == currentCount)&&(identical(other.lastCaughtAt, lastCaughtAt) || other.lastCaughtAt == lastCaughtAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fishId,fishName,caughtCount,currentCount,lastCaughtAt);

@override
String toString() {
  return 'FishInventory(fishId: $fishId, fishName: $fishName, caughtCount: $caughtCount, currentCount: $currentCount, lastCaughtAt: $lastCaughtAt)';
}


}

/// @nodoc
abstract mixin class $FishInventoryCopyWith<$Res>  {
  factory $FishInventoryCopyWith(FishInventory value, $Res Function(FishInventory) _then) = _$FishInventoryCopyWithImpl;
@useResult
$Res call({
 String fishId, String fishName, int caughtCount, int currentCount, DateTime lastCaughtAt
});




}
/// @nodoc
class _$FishInventoryCopyWithImpl<$Res>
    implements $FishInventoryCopyWith<$Res> {
  _$FishInventoryCopyWithImpl(this._self, this._then);

  final FishInventory _self;
  final $Res Function(FishInventory) _then;

/// Create a copy of FishInventory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fishId = null,Object? fishName = null,Object? caughtCount = null,Object? currentCount = null,Object? lastCaughtAt = null,}) {
  return _then(_self.copyWith(
fishId: null == fishId ? _self.fishId : fishId // ignore: cast_nullable_to_non_nullable
as String,fishName: null == fishName ? _self.fishName : fishName // ignore: cast_nullable_to_non_nullable
as String,caughtCount: null == caughtCount ? _self.caughtCount : caughtCount // ignore: cast_nullable_to_non_nullable
as int,currentCount: null == currentCount ? _self.currentCount : currentCount // ignore: cast_nullable_to_non_nullable
as int,lastCaughtAt: null == lastCaughtAt ? _self.lastCaughtAt : lastCaughtAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _FishInventory implements FishInventory {
  const _FishInventory({required this.fishId, required this.fishName, required this.caughtCount, required this.currentCount, required this.lastCaughtAt});
  factory _FishInventory.fromJson(Map<String, dynamic> json) => _$FishInventoryFromJson(json);

@override final  String fishId;
@override final  String fishName;
@override final  int caughtCount;
// 총 잡은 횟수
@override final  int currentCount;
// 현재 보유 수량
@override final  DateTime lastCaughtAt;

/// Create a copy of FishInventory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FishInventoryCopyWith<_FishInventory> get copyWith => __$FishInventoryCopyWithImpl<_FishInventory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FishInventoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FishInventory&&(identical(other.fishId, fishId) || other.fishId == fishId)&&(identical(other.fishName, fishName) || other.fishName == fishName)&&(identical(other.caughtCount, caughtCount) || other.caughtCount == caughtCount)&&(identical(other.currentCount, currentCount) || other.currentCount == currentCount)&&(identical(other.lastCaughtAt, lastCaughtAt) || other.lastCaughtAt == lastCaughtAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fishId,fishName,caughtCount,currentCount,lastCaughtAt);

@override
String toString() {
  return 'FishInventory(fishId: $fishId, fishName: $fishName, caughtCount: $caughtCount, currentCount: $currentCount, lastCaughtAt: $lastCaughtAt)';
}


}

/// @nodoc
abstract mixin class _$FishInventoryCopyWith<$Res> implements $FishInventoryCopyWith<$Res> {
  factory _$FishInventoryCopyWith(_FishInventory value, $Res Function(_FishInventory) _then) = __$FishInventoryCopyWithImpl;
@override @useResult
$Res call({
 String fishId, String fishName, int caughtCount, int currentCount, DateTime lastCaughtAt
});




}
/// @nodoc
class __$FishInventoryCopyWithImpl<$Res>
    implements _$FishInventoryCopyWith<$Res> {
  __$FishInventoryCopyWithImpl(this._self, this._then);

  final _FishInventory _self;
  final $Res Function(_FishInventory) _then;

/// Create a copy of FishInventory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fishId = null,Object? fishName = null,Object? caughtCount = null,Object? currentCount = null,Object? lastCaughtAt = null,}) {
  return _then(_FishInventory(
fishId: null == fishId ? _self.fishId : fishId // ignore: cast_nullable_to_non_nullable
as String,fishName: null == fishName ? _self.fishName : fishName // ignore: cast_nullable_to_non_nullable
as String,caughtCount: null == caughtCount ? _self.caughtCount : caughtCount // ignore: cast_nullable_to_non_nullable
as int,currentCount: null == currentCount ? _self.currentCount : currentCount // ignore: cast_nullable_to_non_nullable
as int,lastCaughtAt: null == lastCaughtAt ? _self.lastCaughtAt : lastCaughtAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
