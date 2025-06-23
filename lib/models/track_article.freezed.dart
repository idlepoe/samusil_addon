// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_article.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackArticle {

@JsonKey(fromJson: _toString) String get id;@JsonKey(fromJson: _toString) String get profile_uid;@JsonKey(fromJson: _toString) String get profile_name;@JsonKey(fromJson: _toString) String get profile_photo_url;@JsonKey(fromJson: _toInt) int get count_view;@JsonKey(fromJson: _toInt) int get count_like;@JsonKey(fromJson: _toInt) int get count_unlike;@JsonKey(fromJson: _toInt) int get count_comments;@JsonKey(fromJson: _toString) String get title; List<Track> get tracks;// contents 대신 tracks 사용
@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime get created_at;@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJsonNullable) DateTime? get updated_at;@JsonKey(fromJson: _toInt) int? get profile_point; List<MainComment>? get comments;@JsonKey(fromJson: _toInt) int get total_duration;// 총 재생시간 (초)
@JsonKey(fromJson: _toInt) int get track_count;// 트랙 개수
@JsonKey(fromJson: _toString) String get description;
/// Create a copy of TrackArticle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackArticleCopyWith<TrackArticle> get copyWith => _$TrackArticleCopyWithImpl<TrackArticle>(this as TrackArticle, _$identity);

  /// Serializes this TrackArticle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackArticle&&(identical(other.id, id) || other.id == id)&&(identical(other.profile_uid, profile_uid) || other.profile_uid == profile_uid)&&(identical(other.profile_name, profile_name) || other.profile_name == profile_name)&&(identical(other.profile_photo_url, profile_photo_url) || other.profile_photo_url == profile_photo_url)&&(identical(other.count_view, count_view) || other.count_view == count_view)&&(identical(other.count_like, count_like) || other.count_like == count_like)&&(identical(other.count_unlike, count_unlike) || other.count_unlike == count_unlike)&&(identical(other.count_comments, count_comments) || other.count_comments == count_comments)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.tracks, tracks)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.updated_at, updated_at) || other.updated_at == updated_at)&&(identical(other.profile_point, profile_point) || other.profile_point == profile_point)&&const DeepCollectionEquality().equals(other.comments, comments)&&(identical(other.total_duration, total_duration) || other.total_duration == total_duration)&&(identical(other.track_count, track_count) || other.track_count == track_count)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profile_uid,profile_name,profile_photo_url,count_view,count_like,count_unlike,count_comments,title,const DeepCollectionEquality().hash(tracks),created_at,updated_at,profile_point,const DeepCollectionEquality().hash(comments),total_duration,track_count,description);

@override
String toString() {
  return 'TrackArticle(id: $id, profile_uid: $profile_uid, profile_name: $profile_name, profile_photo_url: $profile_photo_url, count_view: $count_view, count_like: $count_like, count_unlike: $count_unlike, count_comments: $count_comments, title: $title, tracks: $tracks, created_at: $created_at, updated_at: $updated_at, profile_point: $profile_point, comments: $comments, total_duration: $total_duration, track_count: $track_count, description: $description)';
}


}

/// @nodoc
abstract mixin class $TrackArticleCopyWith<$Res>  {
  factory $TrackArticleCopyWith(TrackArticle value, $Res Function(TrackArticle) _then) = _$TrackArticleCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String id,@JsonKey(fromJson: _toString) String profile_uid,@JsonKey(fromJson: _toString) String profile_name,@JsonKey(fromJson: _toString) String profile_photo_url,@JsonKey(fromJson: _toInt) int count_view,@JsonKey(fromJson: _toInt) int count_like,@JsonKey(fromJson: _toInt) int count_unlike,@JsonKey(fromJson: _toInt) int count_comments,@JsonKey(fromJson: _toString) String title, List<Track> tracks,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime created_at,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJsonNullable) DateTime? updated_at,@JsonKey(fromJson: _toInt) int? profile_point, List<MainComment>? comments,@JsonKey(fromJson: _toInt) int total_duration,@JsonKey(fromJson: _toInt) int track_count,@JsonKey(fromJson: _toString) String description
});




}
/// @nodoc
class _$TrackArticleCopyWithImpl<$Res>
    implements $TrackArticleCopyWith<$Res> {
  _$TrackArticleCopyWithImpl(this._self, this._then);

  final TrackArticle _self;
  final $Res Function(TrackArticle) _then;

/// Create a copy of TrackArticle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profile_uid = null,Object? profile_name = null,Object? profile_photo_url = null,Object? count_view = null,Object? count_like = null,Object? count_unlike = null,Object? count_comments = null,Object? title = null,Object? tracks = null,Object? created_at = null,Object? updated_at = freezed,Object? profile_point = freezed,Object? comments = freezed,Object? total_duration = null,Object? track_count = null,Object? description = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profile_uid: null == profile_uid ? _self.profile_uid : profile_uid // ignore: cast_nullable_to_non_nullable
as String,profile_name: null == profile_name ? _self.profile_name : profile_name // ignore: cast_nullable_to_non_nullable
as String,profile_photo_url: null == profile_photo_url ? _self.profile_photo_url : profile_photo_url // ignore: cast_nullable_to_non_nullable
as String,count_view: null == count_view ? _self.count_view : count_view // ignore: cast_nullable_to_non_nullable
as int,count_like: null == count_like ? _self.count_like : count_like // ignore: cast_nullable_to_non_nullable
as int,count_unlike: null == count_unlike ? _self.count_unlike : count_unlike // ignore: cast_nullable_to_non_nullable
as int,count_comments: null == count_comments ? _self.count_comments : count_comments // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,tracks: null == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<Track>,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as DateTime,updated_at: freezed == updated_at ? _self.updated_at : updated_at // ignore: cast_nullable_to_non_nullable
as DateTime?,profile_point: freezed == profile_point ? _self.profile_point : profile_point // ignore: cast_nullable_to_non_nullable
as int?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<MainComment>?,total_duration: null == total_duration ? _self.total_duration : total_duration // ignore: cast_nullable_to_non_nullable
as int,track_count: null == track_count ? _self.track_count : track_count // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TrackArticle implements TrackArticle {
  const _TrackArticle({@JsonKey(fromJson: _toString) required this.id, @JsonKey(fromJson: _toString) required this.profile_uid, @JsonKey(fromJson: _toString) required this.profile_name, @JsonKey(fromJson: _toString) required this.profile_photo_url, @JsonKey(fromJson: _toInt) required this.count_view, @JsonKey(fromJson: _toInt) required this.count_like, @JsonKey(fromJson: _toInt) required this.count_unlike, @JsonKey(fromJson: _toInt) required this.count_comments, @JsonKey(fromJson: _toString) required this.title, final  List<Track> tracks = const [], @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) required this.created_at, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJsonNullable) this.updated_at, @JsonKey(fromJson: _toInt) this.profile_point, final  List<MainComment>? comments, @JsonKey(fromJson: _toInt) this.total_duration = 0, @JsonKey(fromJson: _toInt) this.track_count = 0, @JsonKey(fromJson: _toString) this.description = ''}): _tracks = tracks,_comments = comments;
  factory _TrackArticle.fromJson(Map<String, dynamic> json) => _$TrackArticleFromJson(json);

@override@JsonKey(fromJson: _toString) final  String id;
@override@JsonKey(fromJson: _toString) final  String profile_uid;
@override@JsonKey(fromJson: _toString) final  String profile_name;
@override@JsonKey(fromJson: _toString) final  String profile_photo_url;
@override@JsonKey(fromJson: _toInt) final  int count_view;
@override@JsonKey(fromJson: _toInt) final  int count_like;
@override@JsonKey(fromJson: _toInt) final  int count_unlike;
@override@JsonKey(fromJson: _toInt) final  int count_comments;
@override@JsonKey(fromJson: _toString) final  String title;
 final  List<Track> _tracks;
@override@JsonKey() List<Track> get tracks {
  if (_tracks is EqualUnmodifiableListView) return _tracks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tracks);
}

// contents 대신 tracks 사용
@override@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) final  DateTime created_at;
@override@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJsonNullable) final  DateTime? updated_at;
@override@JsonKey(fromJson: _toInt) final  int? profile_point;
 final  List<MainComment>? _comments;
@override List<MainComment>? get comments {
  final value = _comments;
  if (value == null) return null;
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(fromJson: _toInt) final  int total_duration;
// 총 재생시간 (초)
@override@JsonKey(fromJson: _toInt) final  int track_count;
// 트랙 개수
@override@JsonKey(fromJson: _toString) final  String description;

/// Create a copy of TrackArticle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackArticleCopyWith<_TrackArticle> get copyWith => __$TrackArticleCopyWithImpl<_TrackArticle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackArticleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackArticle&&(identical(other.id, id) || other.id == id)&&(identical(other.profile_uid, profile_uid) || other.profile_uid == profile_uid)&&(identical(other.profile_name, profile_name) || other.profile_name == profile_name)&&(identical(other.profile_photo_url, profile_photo_url) || other.profile_photo_url == profile_photo_url)&&(identical(other.count_view, count_view) || other.count_view == count_view)&&(identical(other.count_like, count_like) || other.count_like == count_like)&&(identical(other.count_unlike, count_unlike) || other.count_unlike == count_unlike)&&(identical(other.count_comments, count_comments) || other.count_comments == count_comments)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._tracks, _tracks)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.updated_at, updated_at) || other.updated_at == updated_at)&&(identical(other.profile_point, profile_point) || other.profile_point == profile_point)&&const DeepCollectionEquality().equals(other._comments, _comments)&&(identical(other.total_duration, total_duration) || other.total_duration == total_duration)&&(identical(other.track_count, track_count) || other.track_count == track_count)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profile_uid,profile_name,profile_photo_url,count_view,count_like,count_unlike,count_comments,title,const DeepCollectionEquality().hash(_tracks),created_at,updated_at,profile_point,const DeepCollectionEquality().hash(_comments),total_duration,track_count,description);

@override
String toString() {
  return 'TrackArticle(id: $id, profile_uid: $profile_uid, profile_name: $profile_name, profile_photo_url: $profile_photo_url, count_view: $count_view, count_like: $count_like, count_unlike: $count_unlike, count_comments: $count_comments, title: $title, tracks: $tracks, created_at: $created_at, updated_at: $updated_at, profile_point: $profile_point, comments: $comments, total_duration: $total_duration, track_count: $track_count, description: $description)';
}


}

/// @nodoc
abstract mixin class _$TrackArticleCopyWith<$Res> implements $TrackArticleCopyWith<$Res> {
  factory _$TrackArticleCopyWith(_TrackArticle value, $Res Function(_TrackArticle) _then) = __$TrackArticleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String id,@JsonKey(fromJson: _toString) String profile_uid,@JsonKey(fromJson: _toString) String profile_name,@JsonKey(fromJson: _toString) String profile_photo_url,@JsonKey(fromJson: _toInt) int count_view,@JsonKey(fromJson: _toInt) int count_like,@JsonKey(fromJson: _toInt) int count_unlike,@JsonKey(fromJson: _toInt) int count_comments,@JsonKey(fromJson: _toString) String title, List<Track> tracks,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime created_at,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJsonNullable) DateTime? updated_at,@JsonKey(fromJson: _toInt) int? profile_point, List<MainComment>? comments,@JsonKey(fromJson: _toInt) int total_duration,@JsonKey(fromJson: _toInt) int track_count,@JsonKey(fromJson: _toString) String description
});




}
/// @nodoc
class __$TrackArticleCopyWithImpl<$Res>
    implements _$TrackArticleCopyWith<$Res> {
  __$TrackArticleCopyWithImpl(this._self, this._then);

  final _TrackArticle _self;
  final $Res Function(_TrackArticle) _then;

/// Create a copy of TrackArticle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profile_uid = null,Object? profile_name = null,Object? profile_photo_url = null,Object? count_view = null,Object? count_like = null,Object? count_unlike = null,Object? count_comments = null,Object? title = null,Object? tracks = null,Object? created_at = null,Object? updated_at = freezed,Object? profile_point = freezed,Object? comments = freezed,Object? total_duration = null,Object? track_count = null,Object? description = null,}) {
  return _then(_TrackArticle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profile_uid: null == profile_uid ? _self.profile_uid : profile_uid // ignore: cast_nullable_to_non_nullable
as String,profile_name: null == profile_name ? _self.profile_name : profile_name // ignore: cast_nullable_to_non_nullable
as String,profile_photo_url: null == profile_photo_url ? _self.profile_photo_url : profile_photo_url // ignore: cast_nullable_to_non_nullable
as String,count_view: null == count_view ? _self.count_view : count_view // ignore: cast_nullable_to_non_nullable
as int,count_like: null == count_like ? _self.count_like : count_like // ignore: cast_nullable_to_non_nullable
as int,count_unlike: null == count_unlike ? _self.count_unlike : count_unlike // ignore: cast_nullable_to_non_nullable
as int,count_comments: null == count_comments ? _self.count_comments : count_comments // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,tracks: null == tracks ? _self._tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<Track>,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as DateTime,updated_at: freezed == updated_at ? _self.updated_at : updated_at // ignore: cast_nullable_to_non_nullable
as DateTime?,profile_point: freezed == profile_point ? _self.profile_point : profile_point // ignore: cast_nullable_to_non_nullable
as int?,comments: freezed == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<MainComment>?,total_duration: null == total_duration ? _self.total_duration : total_duration // ignore: cast_nullable_to_non_nullable
as int,track_count: null == track_count ? _self.track_count : track_count // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
