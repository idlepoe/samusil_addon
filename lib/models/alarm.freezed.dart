// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alarm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Alarm {

 String get key; String get my_contents; bool get is_read; String get target_article_key; String get target_contents; String get target_info; int get target_key_type;
/// Create a copy of Alarm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmCopyWith<Alarm> get copyWith => _$AlarmCopyWithImpl<Alarm>(this as Alarm, _$identity);

  /// Serializes this Alarm to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Alarm&&(identical(other.key, key) || other.key == key)&&(identical(other.my_contents, my_contents) || other.my_contents == my_contents)&&(identical(other.is_read, is_read) || other.is_read == is_read)&&(identical(other.target_article_key, target_article_key) || other.target_article_key == target_article_key)&&(identical(other.target_contents, target_contents) || other.target_contents == target_contents)&&(identical(other.target_info, target_info) || other.target_info == target_info)&&(identical(other.target_key_type, target_key_type) || other.target_key_type == target_key_type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,my_contents,is_read,target_article_key,target_contents,target_info,target_key_type);

@override
String toString() {
  return 'Alarm(key: $key, my_contents: $my_contents, is_read: $is_read, target_article_key: $target_article_key, target_contents: $target_contents, target_info: $target_info, target_key_type: $target_key_type)';
}


}

/// @nodoc
abstract mixin class $AlarmCopyWith<$Res>  {
  factory $AlarmCopyWith(Alarm value, $Res Function(Alarm) _then) = _$AlarmCopyWithImpl;
@useResult
$Res call({
 String key, String my_contents, bool is_read, String target_article_key, String target_contents, String target_info, int target_key_type
});




}
/// @nodoc
class _$AlarmCopyWithImpl<$Res>
    implements $AlarmCopyWith<$Res> {
  _$AlarmCopyWithImpl(this._self, this._then);

  final Alarm _self;
  final $Res Function(Alarm) _then;

/// Create a copy of Alarm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? my_contents = null,Object? is_read = null,Object? target_article_key = null,Object? target_contents = null,Object? target_info = null,Object? target_key_type = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,my_contents: null == my_contents ? _self.my_contents : my_contents // ignore: cast_nullable_to_non_nullable
as String,is_read: null == is_read ? _self.is_read : is_read // ignore: cast_nullable_to_non_nullable
as bool,target_article_key: null == target_article_key ? _self.target_article_key : target_article_key // ignore: cast_nullable_to_non_nullable
as String,target_contents: null == target_contents ? _self.target_contents : target_contents // ignore: cast_nullable_to_non_nullable
as String,target_info: null == target_info ? _self.target_info : target_info // ignore: cast_nullable_to_non_nullable
as String,target_key_type: null == target_key_type ? _self.target_key_type : target_key_type // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Alarm implements Alarm {
  const _Alarm({required this.key, required this.my_contents, required this.is_read, required this.target_article_key, required this.target_contents, required this.target_info, required this.target_key_type});
  factory _Alarm.fromJson(Map<String, dynamic> json) => _$AlarmFromJson(json);

@override final  String key;
@override final  String my_contents;
@override final  bool is_read;
@override final  String target_article_key;
@override final  String target_contents;
@override final  String target_info;
@override final  int target_key_type;

/// Create a copy of Alarm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlarmCopyWith<_Alarm> get copyWith => __$AlarmCopyWithImpl<_Alarm>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlarmToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Alarm&&(identical(other.key, key) || other.key == key)&&(identical(other.my_contents, my_contents) || other.my_contents == my_contents)&&(identical(other.is_read, is_read) || other.is_read == is_read)&&(identical(other.target_article_key, target_article_key) || other.target_article_key == target_article_key)&&(identical(other.target_contents, target_contents) || other.target_contents == target_contents)&&(identical(other.target_info, target_info) || other.target_info == target_info)&&(identical(other.target_key_type, target_key_type) || other.target_key_type == target_key_type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,my_contents,is_read,target_article_key,target_contents,target_info,target_key_type);

@override
String toString() {
  return 'Alarm(key: $key, my_contents: $my_contents, is_read: $is_read, target_article_key: $target_article_key, target_contents: $target_contents, target_info: $target_info, target_key_type: $target_key_type)';
}


}

/// @nodoc
abstract mixin class _$AlarmCopyWith<$Res> implements $AlarmCopyWith<$Res> {
  factory _$AlarmCopyWith(_Alarm value, $Res Function(_Alarm) _then) = __$AlarmCopyWithImpl;
@override @useResult
$Res call({
 String key, String my_contents, bool is_read, String target_article_key, String target_contents, String target_info, int target_key_type
});




}
/// @nodoc
class __$AlarmCopyWithImpl<$Res>
    implements _$AlarmCopyWith<$Res> {
  __$AlarmCopyWithImpl(this._self, this._then);

  final _Alarm _self;
  final $Res Function(_Alarm) _then;

/// Create a copy of Alarm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? my_contents = null,Object? is_read = null,Object? target_article_key = null,Object? target_contents = null,Object? target_info = null,Object? target_key_type = null,}) {
  return _then(_Alarm(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,my_contents: null == my_contents ? _self.my_contents : my_contents // ignore: cast_nullable_to_non_nullable
as String,is_read: null == is_read ? _self.is_read : is_read // ignore: cast_nullable_to_non_nullable
as bool,target_article_key: null == target_article_key ? _self.target_article_key : target_article_key // ignore: cast_nullable_to_non_nullable
as String,target_contents: null == target_contents ? _self.target_contents : target_contents // ignore: cast_nullable_to_non_nullable
as String,target_info: null == target_info ? _self.target_info : target_info // ignore: cast_nullable_to_non_nullable
as String,target_key_type: null == target_key_type ? _self.target_key_type : target_key_type // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
