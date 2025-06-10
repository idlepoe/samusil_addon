// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UploadItem {

 String get name; String get url; String get type;
/// Create a copy of UploadItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadItemCopyWith<UploadItem> get copyWith => _$UploadItemCopyWithImpl<UploadItem>(this as UploadItem, _$identity);

  /// Serializes this UploadItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadItem&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,url,type);

@override
String toString() {
  return 'UploadItem(name: $name, url: $url, type: $type)';
}


}

/// @nodoc
abstract mixin class $UploadItemCopyWith<$Res>  {
  factory $UploadItemCopyWith(UploadItem value, $Res Function(UploadItem) _then) = _$UploadItemCopyWithImpl;
@useResult
$Res call({
 String name, String url, String type
});




}
/// @nodoc
class _$UploadItemCopyWithImpl<$Res>
    implements $UploadItemCopyWith<$Res> {
  _$UploadItemCopyWithImpl(this._self, this._then);

  final UploadItem _self;
  final $Res Function(UploadItem) _then;

/// Create a copy of UploadItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? url = null,Object? type = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UploadItem implements UploadItem {
  const _UploadItem({required this.name, required this.url, required this.type});
  factory _UploadItem.fromJson(Map<String, dynamic> json) => _$UploadItemFromJson(json);

@override final  String name;
@override final  String url;
@override final  String type;

/// Create a copy of UploadItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadItemCopyWith<_UploadItem> get copyWith => __$UploadItemCopyWithImpl<_UploadItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadItem&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,url,type);

@override
String toString() {
  return 'UploadItem(name: $name, url: $url, type: $type)';
}


}

/// @nodoc
abstract mixin class _$UploadItemCopyWith<$Res> implements $UploadItemCopyWith<$Res> {
  factory _$UploadItemCopyWith(_UploadItem value, $Res Function(_UploadItem) _then) = __$UploadItemCopyWithImpl;
@override @useResult
$Res call({
 String name, String url, String type
});




}
/// @nodoc
class __$UploadItemCopyWithImpl<$Res>
    implements _$UploadItemCopyWith<$Res> {
  __$UploadItemCopyWithImpl(this._self, this._then);

  final _UploadItem _self;
  final $Res Function(_UploadItem) _then;

/// Create a copy of UploadItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? url = null,Object? type = null,}) {
  return _then(_UploadItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
