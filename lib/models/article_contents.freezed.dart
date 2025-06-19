// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_contents.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArticleContent {

 bool get isPicture; bool? get isOriginal; String get contents;@JsonKey(fromJson: _toBool) bool? get isBold;
/// Create a copy of ArticleContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArticleContentCopyWith<ArticleContent> get copyWith => _$ArticleContentCopyWithImpl<ArticleContent>(this as ArticleContent, _$identity);

  /// Serializes this ArticleContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArticleContent&&(identical(other.isPicture, isPicture) || other.isPicture == isPicture)&&(identical(other.isOriginal, isOriginal) || other.isOriginal == isOriginal)&&(identical(other.contents, contents) || other.contents == contents)&&(identical(other.isBold, isBold) || other.isBold == isBold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPicture,isOriginal,contents,isBold);

@override
String toString() {
  return 'ArticleContent(isPicture: $isPicture, isOriginal: $isOriginal, contents: $contents, isBold: $isBold)';
}


}

/// @nodoc
abstract mixin class $ArticleContentCopyWith<$Res>  {
  factory $ArticleContentCopyWith(ArticleContent value, $Res Function(ArticleContent) _then) = _$ArticleContentCopyWithImpl;
@useResult
$Res call({
 bool isPicture, bool? isOriginal, String contents,@JsonKey(fromJson: _toBool) bool? isBold
});




}
/// @nodoc
class _$ArticleContentCopyWithImpl<$Res>
    implements $ArticleContentCopyWith<$Res> {
  _$ArticleContentCopyWithImpl(this._self, this._then);

  final ArticleContent _self;
  final $Res Function(ArticleContent) _then;

/// Create a copy of ArticleContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPicture = null,Object? isOriginal = freezed,Object? contents = null,Object? isBold = freezed,}) {
  return _then(_self.copyWith(
isPicture: null == isPicture ? _self.isPicture : isPicture // ignore: cast_nullable_to_non_nullable
as bool,isOriginal: freezed == isOriginal ? _self.isOriginal : isOriginal // ignore: cast_nullable_to_non_nullable
as bool?,contents: null == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as String,isBold: freezed == isBold ? _self.isBold : isBold // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ArticleContent implements ArticleContent {
  const _ArticleContent({required this.isPicture, this.isOriginal, required this.contents, @JsonKey(fromJson: _toBool) this.isBold});
  factory _ArticleContent.fromJson(Map<String, dynamic> json) => _$ArticleContentFromJson(json);

@override final  bool isPicture;
@override final  bool? isOriginal;
@override final  String contents;
@override@JsonKey(fromJson: _toBool) final  bool? isBold;

/// Create a copy of ArticleContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArticleContentCopyWith<_ArticleContent> get copyWith => __$ArticleContentCopyWithImpl<_ArticleContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArticleContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArticleContent&&(identical(other.isPicture, isPicture) || other.isPicture == isPicture)&&(identical(other.isOriginal, isOriginal) || other.isOriginal == isOriginal)&&(identical(other.contents, contents) || other.contents == contents)&&(identical(other.isBold, isBold) || other.isBold == isBold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPicture,isOriginal,contents,isBold);

@override
String toString() {
  return 'ArticleContent(isPicture: $isPicture, isOriginal: $isOriginal, contents: $contents, isBold: $isBold)';
}


}

/// @nodoc
abstract mixin class _$ArticleContentCopyWith<$Res> implements $ArticleContentCopyWith<$Res> {
  factory _$ArticleContentCopyWith(_ArticleContent value, $Res Function(_ArticleContent) _then) = __$ArticleContentCopyWithImpl;
@override @useResult
$Res call({
 bool isPicture, bool? isOriginal, String contents,@JsonKey(fromJson: _toBool) bool? isBold
});




}
/// @nodoc
class __$ArticleContentCopyWithImpl<$Res>
    implements _$ArticleContentCopyWith<$Res> {
  __$ArticleContentCopyWithImpl(this._self, this._then);

  final _ArticleContent _self;
  final $Res Function(_ArticleContent) _then;

/// Create a copy of ArticleContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPicture = null,Object? isOriginal = freezed,Object? contents = null,Object? isBold = freezed,}) {
  return _then(_ArticleContent(
isPicture: null == isPicture ? _self.isPicture : isPicture // ignore: cast_nullable_to_non_nullable
as bool,isOriginal: freezed == isOriginal ? _self.isOriginal : isOriginal // ignore: cast_nullable_to_non_nullable
as bool?,contents: null == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as String,isBold: freezed == isBold ? _self.isBold : isBold // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
