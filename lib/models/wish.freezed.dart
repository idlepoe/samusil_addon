// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wish.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Wish {

@JsonKey(fromJson: _toInt) int get index;@JsonKey(fromJson: _toString) String get key;@JsonKey(fromJson: _toString) String get comments;@JsonKey(fromJson: _toString) String get nick_name;@JsonKey(fromJson: _toInt) int get streak;@JsonKey(fromJson: _toString) String get created_at;
/// Create a copy of Wish
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WishCopyWith<Wish> get copyWith => _$WishCopyWithImpl<Wish>(this as Wish, _$identity);

  /// Serializes this Wish to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Wish&&(identical(other.index, index) || other.index == index)&&(identical(other.key, key) || other.key == key)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.nick_name, nick_name) || other.nick_name == nick_name)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.created_at, created_at) || other.created_at == created_at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,key,comments,nick_name,streak,created_at);

@override
String toString() {
  return 'Wish(index: $index, key: $key, comments: $comments, nick_name: $nick_name, streak: $streak, created_at: $created_at)';
}


}

/// @nodoc
abstract mixin class $WishCopyWith<$Res>  {
  factory $WishCopyWith(Wish value, $Res Function(Wish) _then) = _$WishCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toInt) int index,@JsonKey(fromJson: _toString) String key,@JsonKey(fromJson: _toString) String comments,@JsonKey(fromJson: _toString) String nick_name,@JsonKey(fromJson: _toInt) int streak,@JsonKey(fromJson: _toString) String created_at
});




}
/// @nodoc
class _$WishCopyWithImpl<$Res>
    implements $WishCopyWith<$Res> {
  _$WishCopyWithImpl(this._self, this._then);

  final Wish _self;
  final $Res Function(Wish) _then;

/// Create a copy of Wish
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? key = null,Object? comments = null,Object? nick_name = null,Object? streak = null,Object? created_at = null,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String,nick_name: null == nick_name ? _self.nick_name : nick_name // ignore: cast_nullable_to_non_nullable
as String,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Wish implements Wish {
  const _Wish({@JsonKey(fromJson: _toInt) required this.index, @JsonKey(fromJson: _toString) required this.key, @JsonKey(fromJson: _toString) required this.comments, @JsonKey(fromJson: _toString) required this.nick_name, @JsonKey(fromJson: _toInt) required this.streak, @JsonKey(fromJson: _toString) required this.created_at});
  factory _Wish.fromJson(Map<String, dynamic> json) => _$WishFromJson(json);

@override@JsonKey(fromJson: _toInt) final  int index;
@override@JsonKey(fromJson: _toString) final  String key;
@override@JsonKey(fromJson: _toString) final  String comments;
@override@JsonKey(fromJson: _toString) final  String nick_name;
@override@JsonKey(fromJson: _toInt) final  int streak;
@override@JsonKey(fromJson: _toString) final  String created_at;

/// Create a copy of Wish
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WishCopyWith<_Wish> get copyWith => __$WishCopyWithImpl<_Wish>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WishToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Wish&&(identical(other.index, index) || other.index == index)&&(identical(other.key, key) || other.key == key)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.nick_name, nick_name) || other.nick_name == nick_name)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.created_at, created_at) || other.created_at == created_at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,key,comments,nick_name,streak,created_at);

@override
String toString() {
  return 'Wish(index: $index, key: $key, comments: $comments, nick_name: $nick_name, streak: $streak, created_at: $created_at)';
}


}

/// @nodoc
abstract mixin class _$WishCopyWith<$Res> implements $WishCopyWith<$Res> {
  factory _$WishCopyWith(_Wish value, $Res Function(_Wish) _then) = __$WishCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toInt) int index,@JsonKey(fromJson: _toString) String key,@JsonKey(fromJson: _toString) String comments,@JsonKey(fromJson: _toString) String nick_name,@JsonKey(fromJson: _toInt) int streak,@JsonKey(fromJson: _toString) String created_at
});




}
/// @nodoc
class __$WishCopyWithImpl<$Res>
    implements _$WishCopyWith<$Res> {
  __$WishCopyWithImpl(this._self, this._then);

  final _Wish _self;
  final $Res Function(_Wish) _then;

/// Create a copy of Wish
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? key = null,Object? comments = null,Object? nick_name = null,Object? streak = null,Object? created_at = null,}) {
  return _then(_Wish(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String,nick_name: null == nick_name ? _self.nick_name : nick_name // ignore: cast_nullable_to_non_nullable
as String,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
