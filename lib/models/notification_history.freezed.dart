// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationHistory {

@JsonKey(fromJson: _toString) String get id;@JsonKey(fromJson: _toString) String get type;@JsonKey(fromJson: _toString) String get title;@JsonKey(fromJson: _toString) String get body;@JsonKey(fromJson: _toString) String get article_id;@JsonKey(fromJson: _toString) String get article_title;@JsonKey(fromJson: _toString) String get sender_uid;@JsonKey(fromJson: _toString) String get sender_name;@JsonKey(fromJson: _toDateTime) DateTime get created_at;@JsonKey(fromJson: _toBool) bool get read;
/// Create a copy of NotificationHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationHistoryCopyWith<NotificationHistory> get copyWith => _$NotificationHistoryCopyWithImpl<NotificationHistory>(this as NotificationHistory, _$identity);

  /// Serializes this NotificationHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.article_id, article_id) || other.article_id == article_id)&&(identical(other.article_title, article_title) || other.article_title == article_title)&&(identical(other.sender_uid, sender_uid) || other.sender_uid == sender_uid)&&(identical(other.sender_name, sender_name) || other.sender_name == sender_name)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.read, read) || other.read == read));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,body,article_id,article_title,sender_uid,sender_name,created_at,read);

@override
String toString() {
  return 'NotificationHistory(id: $id, type: $type, title: $title, body: $body, article_id: $article_id, article_title: $article_title, sender_uid: $sender_uid, sender_name: $sender_name, created_at: $created_at, read: $read)';
}


}

/// @nodoc
abstract mixin class $NotificationHistoryCopyWith<$Res>  {
  factory $NotificationHistoryCopyWith(NotificationHistory value, $Res Function(NotificationHistory) _then) = _$NotificationHistoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String id,@JsonKey(fromJson: _toString) String type,@JsonKey(fromJson: _toString) String title,@JsonKey(fromJson: _toString) String body,@JsonKey(fromJson: _toString) String article_id,@JsonKey(fromJson: _toString) String article_title,@JsonKey(fromJson: _toString) String sender_uid,@JsonKey(fromJson: _toString) String sender_name,@JsonKey(fromJson: _toDateTime) DateTime created_at,@JsonKey(fromJson: _toBool) bool read
});




}
/// @nodoc
class _$NotificationHistoryCopyWithImpl<$Res>
    implements $NotificationHistoryCopyWith<$Res> {
  _$NotificationHistoryCopyWithImpl(this._self, this._then);

  final NotificationHistory _self;
  final $Res Function(NotificationHistory) _then;

/// Create a copy of NotificationHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? body = null,Object? article_id = null,Object? article_title = null,Object? sender_uid = null,Object? sender_name = null,Object? created_at = null,Object? read = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,article_id: null == article_id ? _self.article_id : article_id // ignore: cast_nullable_to_non_nullable
as String,article_title: null == article_title ? _self.article_title : article_title // ignore: cast_nullable_to_non_nullable
as String,sender_uid: null == sender_uid ? _self.sender_uid : sender_uid // ignore: cast_nullable_to_non_nullable
as String,sender_name: null == sender_name ? _self.sender_name : sender_name // ignore: cast_nullable_to_non_nullable
as String,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as DateTime,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _NotificationHistory implements NotificationHistory {
  const _NotificationHistory({@JsonKey(fromJson: _toString) required this.id, @JsonKey(fromJson: _toString) required this.type, @JsonKey(fromJson: _toString) required this.title, @JsonKey(fromJson: _toString) required this.body, @JsonKey(fromJson: _toString) required this.article_id, @JsonKey(fromJson: _toString) required this.article_title, @JsonKey(fromJson: _toString) required this.sender_uid, @JsonKey(fromJson: _toString) required this.sender_name, @JsonKey(fromJson: _toDateTime) required this.created_at, @JsonKey(fromJson: _toBool) required this.read});
  factory _NotificationHistory.fromJson(Map<String, dynamic> json) => _$NotificationHistoryFromJson(json);

@override@JsonKey(fromJson: _toString) final  String id;
@override@JsonKey(fromJson: _toString) final  String type;
@override@JsonKey(fromJson: _toString) final  String title;
@override@JsonKey(fromJson: _toString) final  String body;
@override@JsonKey(fromJson: _toString) final  String article_id;
@override@JsonKey(fromJson: _toString) final  String article_title;
@override@JsonKey(fromJson: _toString) final  String sender_uid;
@override@JsonKey(fromJson: _toString) final  String sender_name;
@override@JsonKey(fromJson: _toDateTime) final  DateTime created_at;
@override@JsonKey(fromJson: _toBool) final  bool read;

/// Create a copy of NotificationHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationHistoryCopyWith<_NotificationHistory> get copyWith => __$NotificationHistoryCopyWithImpl<_NotificationHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.article_id, article_id) || other.article_id == article_id)&&(identical(other.article_title, article_title) || other.article_title == article_title)&&(identical(other.sender_uid, sender_uid) || other.sender_uid == sender_uid)&&(identical(other.sender_name, sender_name) || other.sender_name == sender_name)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.read, read) || other.read == read));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,body,article_id,article_title,sender_uid,sender_name,created_at,read);

@override
String toString() {
  return 'NotificationHistory(id: $id, type: $type, title: $title, body: $body, article_id: $article_id, article_title: $article_title, sender_uid: $sender_uid, sender_name: $sender_name, created_at: $created_at, read: $read)';
}


}

/// @nodoc
abstract mixin class _$NotificationHistoryCopyWith<$Res> implements $NotificationHistoryCopyWith<$Res> {
  factory _$NotificationHistoryCopyWith(_NotificationHistory value, $Res Function(_NotificationHistory) _then) = __$NotificationHistoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String id,@JsonKey(fromJson: _toString) String type,@JsonKey(fromJson: _toString) String title,@JsonKey(fromJson: _toString) String body,@JsonKey(fromJson: _toString) String article_id,@JsonKey(fromJson: _toString) String article_title,@JsonKey(fromJson: _toString) String sender_uid,@JsonKey(fromJson: _toString) String sender_name,@JsonKey(fromJson: _toDateTime) DateTime created_at,@JsonKey(fromJson: _toBool) bool read
});




}
/// @nodoc
class __$NotificationHistoryCopyWithImpl<$Res>
    implements _$NotificationHistoryCopyWith<$Res> {
  __$NotificationHistoryCopyWithImpl(this._self, this._then);

  final _NotificationHistory _self;
  final $Res Function(_NotificationHistory) _then;

/// Create a copy of NotificationHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? body = null,Object? article_id = null,Object? article_title = null,Object? sender_uid = null,Object? sender_name = null,Object? created_at = null,Object? read = null,}) {
  return _then(_NotificationHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,article_id: null == article_id ? _self.article_id : article_id // ignore: cast_nullable_to_non_nullable
as String,article_title: null == article_title ? _self.article_title : article_title // ignore: cast_nullable_to_non_nullable
as String,sender_uid: null == sender_uid ? _self.sender_uid : sender_uid // ignore: cast_nullable_to_non_nullable
as String,sender_name: null == sender_name ? _self.sender_name : sender_name // ignore: cast_nullable_to_non_nullable
as String,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as DateTime,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
