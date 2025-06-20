// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MainComment {

@JsonKey(fromJson: _toString) String get key;@JsonKey(fromJson: _toString) String get contents;@JsonKey(fromJson: _toString) String get profile_uid;@JsonKey(fromJson: _toString) String get profile_name;@JsonKey(fromJson: _toString) String get profile_photo_url;@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime get created_at;@JsonKey(fromJson: _toBool) bool get is_sub;@JsonKey(fromJson: _toString) String get parents_key;
/// Create a copy of MainComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MainCommentCopyWith<MainComment> get copyWith => _$MainCommentCopyWithImpl<MainComment>(this as MainComment, _$identity);

  /// Serializes this MainComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainComment&&(identical(other.key, key) || other.key == key)&&(identical(other.contents, contents) || other.contents == contents)&&(identical(other.profile_uid, profile_uid) || other.profile_uid == profile_uid)&&(identical(other.profile_name, profile_name) || other.profile_name == profile_name)&&(identical(other.profile_photo_url, profile_photo_url) || other.profile_photo_url == profile_photo_url)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.is_sub, is_sub) || other.is_sub == is_sub)&&(identical(other.parents_key, parents_key) || other.parents_key == parents_key));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,contents,profile_uid,profile_name,profile_photo_url,created_at,is_sub,parents_key);

@override
String toString() {
  return 'MainComment(key: $key, contents: $contents, profile_uid: $profile_uid, profile_name: $profile_name, profile_photo_url: $profile_photo_url, created_at: $created_at, is_sub: $is_sub, parents_key: $parents_key)';
}


}

/// @nodoc
abstract mixin class $MainCommentCopyWith<$Res>  {
  factory $MainCommentCopyWith(MainComment value, $Res Function(MainComment) _then) = _$MainCommentCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String key,@JsonKey(fromJson: _toString) String contents,@JsonKey(fromJson: _toString) String profile_uid,@JsonKey(fromJson: _toString) String profile_name,@JsonKey(fromJson: _toString) String profile_photo_url,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime created_at,@JsonKey(fromJson: _toBool) bool is_sub,@JsonKey(fromJson: _toString) String parents_key
});




}
/// @nodoc
class _$MainCommentCopyWithImpl<$Res>
    implements $MainCommentCopyWith<$Res> {
  _$MainCommentCopyWithImpl(this._self, this._then);

  final MainComment _self;
  final $Res Function(MainComment) _then;

/// Create a copy of MainComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? contents = null,Object? profile_uid = null,Object? profile_name = null,Object? profile_photo_url = null,Object? created_at = null,Object? is_sub = null,Object? parents_key = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,contents: null == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as String,profile_uid: null == profile_uid ? _self.profile_uid : profile_uid // ignore: cast_nullable_to_non_nullable
as String,profile_name: null == profile_name ? _self.profile_name : profile_name // ignore: cast_nullable_to_non_nullable
as String,profile_photo_url: null == profile_photo_url ? _self.profile_photo_url : profile_photo_url // ignore: cast_nullable_to_non_nullable
as String,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as DateTime,is_sub: null == is_sub ? _self.is_sub : is_sub // ignore: cast_nullable_to_non_nullable
as bool,parents_key: null == parents_key ? _self.parents_key : parents_key // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _MainComment implements MainComment {
  const _MainComment({@JsonKey(fromJson: _toString) required this.key, @JsonKey(fromJson: _toString) required this.contents, @JsonKey(fromJson: _toString) required this.profile_uid, @JsonKey(fromJson: _toString) required this.profile_name, @JsonKey(fromJson: _toString) required this.profile_photo_url, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) required this.created_at, @JsonKey(fromJson: _toBool) required this.is_sub, @JsonKey(fromJson: _toString) required this.parents_key});
  factory _MainComment.fromJson(Map<String, dynamic> json) => _$MainCommentFromJson(json);

@override@JsonKey(fromJson: _toString) final  String key;
@override@JsonKey(fromJson: _toString) final  String contents;
@override@JsonKey(fromJson: _toString) final  String profile_uid;
@override@JsonKey(fromJson: _toString) final  String profile_name;
@override@JsonKey(fromJson: _toString) final  String profile_photo_url;
@override@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) final  DateTime created_at;
@override@JsonKey(fromJson: _toBool) final  bool is_sub;
@override@JsonKey(fromJson: _toString) final  String parents_key;

/// Create a copy of MainComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MainCommentCopyWith<_MainComment> get copyWith => __$MainCommentCopyWithImpl<_MainComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MainCommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainComment&&(identical(other.key, key) || other.key == key)&&(identical(other.contents, contents) || other.contents == contents)&&(identical(other.profile_uid, profile_uid) || other.profile_uid == profile_uid)&&(identical(other.profile_name, profile_name) || other.profile_name == profile_name)&&(identical(other.profile_photo_url, profile_photo_url) || other.profile_photo_url == profile_photo_url)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.is_sub, is_sub) || other.is_sub == is_sub)&&(identical(other.parents_key, parents_key) || other.parents_key == parents_key));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,contents,profile_uid,profile_name,profile_photo_url,created_at,is_sub,parents_key);

@override
String toString() {
  return 'MainComment(key: $key, contents: $contents, profile_uid: $profile_uid, profile_name: $profile_name, profile_photo_url: $profile_photo_url, created_at: $created_at, is_sub: $is_sub, parents_key: $parents_key)';
}


}

/// @nodoc
abstract mixin class _$MainCommentCopyWith<$Res> implements $MainCommentCopyWith<$Res> {
  factory _$MainCommentCopyWith(_MainComment value, $Res Function(_MainComment) _then) = __$MainCommentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String key,@JsonKey(fromJson: _toString) String contents,@JsonKey(fromJson: _toString) String profile_uid,@JsonKey(fromJson: _toString) String profile_name,@JsonKey(fromJson: _toString) String profile_photo_url,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime created_at,@JsonKey(fromJson: _toBool) bool is_sub,@JsonKey(fromJson: _toString) String parents_key
});




}
/// @nodoc
class __$MainCommentCopyWithImpl<$Res>
    implements _$MainCommentCopyWith<$Res> {
  __$MainCommentCopyWithImpl(this._self, this._then);

  final _MainComment _self;
  final $Res Function(_MainComment) _then;

/// Create a copy of MainComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? contents = null,Object? profile_uid = null,Object? profile_name = null,Object? profile_photo_url = null,Object? created_at = null,Object? is_sub = null,Object? parents_key = null,}) {
  return _then(_MainComment(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,contents: null == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as String,profile_uid: null == profile_uid ? _self.profile_uid : profile_uid // ignore: cast_nullable_to_non_nullable
as String,profile_name: null == profile_name ? _self.profile_name : profile_name // ignore: cast_nullable_to_non_nullable
as String,profile_photo_url: null == profile_photo_url ? _self.profile_photo_url : profile_photo_url // ignore: cast_nullable_to_non_nullable
as String,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as DateTime,is_sub: null == is_sub ? _self.is_sub : is_sub // ignore: cast_nullable_to_non_nullable
as bool,parents_key: null == parents_key ? _self.parents_key : parents_key // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
