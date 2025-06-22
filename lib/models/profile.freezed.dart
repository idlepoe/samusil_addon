// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {

@JsonKey(fromJson: _toString) String get uid;@JsonKey(fromJson: _toString) String get name;@JsonKey(fromJson: _toString) String get photo_url;@JsonKey(fromJson: _toString) String get wish_last_date;@JsonKey(fromJson: _toInt) int get wish_streak; double get point;@JsonKey(fromJson: _toString) String get one_comment;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.photo_url, photo_url) || other.photo_url == photo_url)&&(identical(other.wish_last_date, wish_last_date) || other.wish_last_date == wish_last_date)&&(identical(other.wish_streak, wish_streak) || other.wish_streak == wish_streak)&&(identical(other.point, point) || other.point == point)&&(identical(other.one_comment, one_comment) || other.one_comment == one_comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,photo_url,wish_last_date,wish_streak,point,one_comment);

@override
String toString() {
  return 'Profile(uid: $uid, name: $name, photo_url: $photo_url, wish_last_date: $wish_last_date, wish_streak: $wish_streak, point: $point, one_comment: $one_comment)';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String uid,@JsonKey(fromJson: _toString) String name,@JsonKey(fromJson: _toString) String photo_url,@JsonKey(fromJson: _toString) String wish_last_date,@JsonKey(fromJson: _toInt) int wish_streak, double point,@JsonKey(fromJson: _toString) String one_comment
});




}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? name = null,Object? photo_url = null,Object? wish_last_date = null,Object? wish_streak = null,Object? point = null,Object? one_comment = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photo_url: null == photo_url ? _self.photo_url : photo_url // ignore: cast_nullable_to_non_nullable
as String,wish_last_date: null == wish_last_date ? _self.wish_last_date : wish_last_date // ignore: cast_nullable_to_non_nullable
as String,wish_streak: null == wish_streak ? _self.wish_streak : wish_streak // ignore: cast_nullable_to_non_nullable
as int,point: null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as double,one_comment: null == one_comment ? _self.one_comment : one_comment // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Profile implements Profile {
  const _Profile({@JsonKey(fromJson: _toString) required this.uid, @JsonKey(fromJson: _toString) required this.name, @JsonKey(fromJson: _toString) required this.photo_url, @JsonKey(fromJson: _toString) required this.wish_last_date, @JsonKey(fromJson: _toInt) required this.wish_streak, required this.point, @JsonKey(fromJson: _toString) required this.one_comment});
  factory _Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

@override@JsonKey(fromJson: _toString) final  String uid;
@override@JsonKey(fromJson: _toString) final  String name;
@override@JsonKey(fromJson: _toString) final  String photo_url;
@override@JsonKey(fromJson: _toString) final  String wish_last_date;
@override@JsonKey(fromJson: _toInt) final  int wish_streak;
@override final  double point;
@override@JsonKey(fromJson: _toString) final  String one_comment;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.photo_url, photo_url) || other.photo_url == photo_url)&&(identical(other.wish_last_date, wish_last_date) || other.wish_last_date == wish_last_date)&&(identical(other.wish_streak, wish_streak) || other.wish_streak == wish_streak)&&(identical(other.point, point) || other.point == point)&&(identical(other.one_comment, one_comment) || other.one_comment == one_comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,photo_url,wish_last_date,wish_streak,point,one_comment);

@override
String toString() {
  return 'Profile(uid: $uid, name: $name, photo_url: $photo_url, wish_last_date: $wish_last_date, wish_streak: $wish_streak, point: $point, one_comment: $one_comment)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String uid,@JsonKey(fromJson: _toString) String name,@JsonKey(fromJson: _toString) String photo_url,@JsonKey(fromJson: _toString) String wish_last_date,@JsonKey(fromJson: _toInt) int wish_streak, double point,@JsonKey(fromJson: _toString) String one_comment
});




}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? name = null,Object? photo_url = null,Object? wish_last_date = null,Object? wish_streak = null,Object? point = null,Object? one_comment = null,}) {
  return _then(_Profile(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photo_url: null == photo_url ? _self.photo_url : photo_url // ignore: cast_nullable_to_non_nullable
as String,wish_last_date: null == wish_last_date ? _self.wish_last_date : wish_last_date // ignore: cast_nullable_to_non_nullable
as String,wish_streak: null == wish_streak ? _self.wish_streak : wish_streak // ignore: cast_nullable_to_non_nullable
as int,point: null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as double,one_comment: null == one_comment ? _self.one_comment : one_comment // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
