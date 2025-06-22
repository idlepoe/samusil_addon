// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'point_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PointHistory {

@JsonKey(fromJson: _toString) String? get id;@JsonKey(fromJson: _toString) String get profile_uid;@JsonKey(fromJson: _toString) String get action_type;@JsonKey(fromJson: _toInt) int get points_earned;@JsonKey(fromJson: _toString) String get description;@JsonKey(fromJson: _toString) String? get related_id;@JsonKey(fromJson: _toDateTimeObj) DateTime get created_at;
/// Create a copy of PointHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointHistoryCopyWith<PointHistory> get copyWith => _$PointHistoryCopyWithImpl<PointHistory>(this as PointHistory, _$identity);

  /// Serializes this PointHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.profile_uid, profile_uid) || other.profile_uid == profile_uid)&&(identical(other.action_type, action_type) || other.action_type == action_type)&&(identical(other.points_earned, points_earned) || other.points_earned == points_earned)&&(identical(other.description, description) || other.description == description)&&(identical(other.related_id, related_id) || other.related_id == related_id)&&(identical(other.created_at, created_at) || other.created_at == created_at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profile_uid,action_type,points_earned,description,related_id,created_at);

@override
String toString() {
  return 'PointHistory(id: $id, profile_uid: $profile_uid, action_type: $action_type, points_earned: $points_earned, description: $description, related_id: $related_id, created_at: $created_at)';
}


}

/// @nodoc
abstract mixin class $PointHistoryCopyWith<$Res>  {
  factory $PointHistoryCopyWith(PointHistory value, $Res Function(PointHistory) _then) = _$PointHistoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String? id,@JsonKey(fromJson: _toString) String profile_uid,@JsonKey(fromJson: _toString) String action_type,@JsonKey(fromJson: _toInt) int points_earned,@JsonKey(fromJson: _toString) String description,@JsonKey(fromJson: _toString) String? related_id,@JsonKey(fromJson: _toDateTimeObj) DateTime created_at
});




}
/// @nodoc
class _$PointHistoryCopyWithImpl<$Res>
    implements $PointHistoryCopyWith<$Res> {
  _$PointHistoryCopyWithImpl(this._self, this._then);

  final PointHistory _self;
  final $Res Function(PointHistory) _then;

/// Create a copy of PointHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? profile_uid = null,Object? action_type = null,Object? points_earned = null,Object? description = null,Object? related_id = freezed,Object? created_at = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,profile_uid: null == profile_uid ? _self.profile_uid : profile_uid // ignore: cast_nullable_to_non_nullable
as String,action_type: null == action_type ? _self.action_type : action_type // ignore: cast_nullable_to_non_nullable
as String,points_earned: null == points_earned ? _self.points_earned : points_earned // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,related_id: freezed == related_id ? _self.related_id : related_id // ignore: cast_nullable_to_non_nullable
as String?,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PointHistory implements PointHistory {
  const _PointHistory({@JsonKey(fromJson: _toString) this.id, @JsonKey(fromJson: _toString) required this.profile_uid, @JsonKey(fromJson: _toString) required this.action_type, @JsonKey(fromJson: _toInt) required this.points_earned, @JsonKey(fromJson: _toString) required this.description, @JsonKey(fromJson: _toString) this.related_id, @JsonKey(fromJson: _toDateTimeObj) required this.created_at});
  factory _PointHistory.fromJson(Map<String, dynamic> json) => _$PointHistoryFromJson(json);

@override@JsonKey(fromJson: _toString) final  String? id;
@override@JsonKey(fromJson: _toString) final  String profile_uid;
@override@JsonKey(fromJson: _toString) final  String action_type;
@override@JsonKey(fromJson: _toInt) final  int points_earned;
@override@JsonKey(fromJson: _toString) final  String description;
@override@JsonKey(fromJson: _toString) final  String? related_id;
@override@JsonKey(fromJson: _toDateTimeObj) final  DateTime created_at;

/// Create a copy of PointHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointHistoryCopyWith<_PointHistory> get copyWith => __$PointHistoryCopyWithImpl<_PointHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PointHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.profile_uid, profile_uid) || other.profile_uid == profile_uid)&&(identical(other.action_type, action_type) || other.action_type == action_type)&&(identical(other.points_earned, points_earned) || other.points_earned == points_earned)&&(identical(other.description, description) || other.description == description)&&(identical(other.related_id, related_id) || other.related_id == related_id)&&(identical(other.created_at, created_at) || other.created_at == created_at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profile_uid,action_type,points_earned,description,related_id,created_at);

@override
String toString() {
  return 'PointHistory(id: $id, profile_uid: $profile_uid, action_type: $action_type, points_earned: $points_earned, description: $description, related_id: $related_id, created_at: $created_at)';
}


}

/// @nodoc
abstract mixin class _$PointHistoryCopyWith<$Res> implements $PointHistoryCopyWith<$Res> {
  factory _$PointHistoryCopyWith(_PointHistory value, $Res Function(_PointHistory) _then) = __$PointHistoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String? id,@JsonKey(fromJson: _toString) String profile_uid,@JsonKey(fromJson: _toString) String action_type,@JsonKey(fromJson: _toInt) int points_earned,@JsonKey(fromJson: _toString) String description,@JsonKey(fromJson: _toString) String? related_id,@JsonKey(fromJson: _toDateTimeObj) DateTime created_at
});




}
/// @nodoc
class __$PointHistoryCopyWithImpl<$Res>
    implements _$PointHistoryCopyWith<$Res> {
  __$PointHistoryCopyWithImpl(this._self, this._then);

  final _PointHistory _self;
  final $Res Function(_PointHistory) _then;

/// Create a copy of PointHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? profile_uid = null,Object? action_type = null,Object? points_earned = null,Object? description = null,Object? related_id = freezed,Object? created_at = null,}) {
  return _then(_PointHistory(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,profile_uid: null == profile_uid ? _self.profile_uid : profile_uid // ignore: cast_nullable_to_non_nullable
as String,action_type: null == action_type ? _self.action_type : action_type // ignore: cast_nullable_to_non_nullable
as String,points_earned: null == points_earned ? _self.points_earned : points_earned // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,related_id: freezed == related_id ? _self.related_id : related_id // ignore: cast_nullable_to_non_nullable
as String?,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
