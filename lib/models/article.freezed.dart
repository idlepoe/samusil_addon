// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Article {

@JsonKey(fromJson: _toString) String get id;@JsonKey(fromJson: _toString) String get board_name;@JsonKey(fromJson: _toString) String get profile_uid;@JsonKey(fromJson: _toString) String get profile_name;@JsonKey(fromJson: _toString) String get profile_photo_url;@JsonKey(fromJson: _toInt) int get count_view;@JsonKey(fromJson: _toInt) int get count_like;@JsonKey(fromJson: _toInt) int get count_unlike;@JsonKey(fromJson: _toInt) int get count_comments;@JsonKey(fromJson: _toString) String get title; List<ArticleContent> get contents;@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime get created_at;@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJsonNullable) DateTime? get updated_at;@JsonKey(fromJson: _toInt) int? get profile_point; bool get is_notice; String? get thumbnail; List<MainComment>? get comments;
/// Create a copy of Article
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArticleCopyWith<Article> get copyWith => _$ArticleCopyWithImpl<Article>(this as Article, _$identity);

  /// Serializes this Article to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Article&&(identical(other.id, id) || other.id == id)&&(identical(other.board_name, board_name) || other.board_name == board_name)&&(identical(other.profile_uid, profile_uid) || other.profile_uid == profile_uid)&&(identical(other.profile_name, profile_name) || other.profile_name == profile_name)&&(identical(other.profile_photo_url, profile_photo_url) || other.profile_photo_url == profile_photo_url)&&(identical(other.count_view, count_view) || other.count_view == count_view)&&(identical(other.count_like, count_like) || other.count_like == count_like)&&(identical(other.count_unlike, count_unlike) || other.count_unlike == count_unlike)&&(identical(other.count_comments, count_comments) || other.count_comments == count_comments)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.contents, contents)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.updated_at, updated_at) || other.updated_at == updated_at)&&(identical(other.profile_point, profile_point) || other.profile_point == profile_point)&&(identical(other.is_notice, is_notice) || other.is_notice == is_notice)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&const DeepCollectionEquality().equals(other.comments, comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,board_name,profile_uid,profile_name,profile_photo_url,count_view,count_like,count_unlike,count_comments,title,const DeepCollectionEquality().hash(contents),created_at,updated_at,profile_point,is_notice,thumbnail,const DeepCollectionEquality().hash(comments));

@override
String toString() {
  return 'Article(id: $id, board_name: $board_name, profile_uid: $profile_uid, profile_name: $profile_name, profile_photo_url: $profile_photo_url, count_view: $count_view, count_like: $count_like, count_unlike: $count_unlike, count_comments: $count_comments, title: $title, contents: $contents, created_at: $created_at, updated_at: $updated_at, profile_point: $profile_point, is_notice: $is_notice, thumbnail: $thumbnail, comments: $comments)';
}


}

/// @nodoc
abstract mixin class $ArticleCopyWith<$Res>  {
  factory $ArticleCopyWith(Article value, $Res Function(Article) _then) = _$ArticleCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String id,@JsonKey(fromJson: _toString) String board_name,@JsonKey(fromJson: _toString) String profile_uid,@JsonKey(fromJson: _toString) String profile_name,@JsonKey(fromJson: _toString) String profile_photo_url,@JsonKey(fromJson: _toInt) int count_view,@JsonKey(fromJson: _toInt) int count_like,@JsonKey(fromJson: _toInt) int count_unlike,@JsonKey(fromJson: _toInt) int count_comments,@JsonKey(fromJson: _toString) String title, List<ArticleContent> contents,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime created_at,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJsonNullable) DateTime? updated_at,@JsonKey(fromJson: _toInt) int? profile_point, bool is_notice, String? thumbnail, List<MainComment>? comments
});




}
/// @nodoc
class _$ArticleCopyWithImpl<$Res>
    implements $ArticleCopyWith<$Res> {
  _$ArticleCopyWithImpl(this._self, this._then);

  final Article _self;
  final $Res Function(Article) _then;

/// Create a copy of Article
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? board_name = null,Object? profile_uid = null,Object? profile_name = null,Object? profile_photo_url = null,Object? count_view = null,Object? count_like = null,Object? count_unlike = null,Object? count_comments = null,Object? title = null,Object? contents = null,Object? created_at = null,Object? updated_at = freezed,Object? profile_point = freezed,Object? is_notice = null,Object? thumbnail = freezed,Object? comments = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,board_name: null == board_name ? _self.board_name : board_name // ignore: cast_nullable_to_non_nullable
as String,profile_uid: null == profile_uid ? _self.profile_uid : profile_uid // ignore: cast_nullable_to_non_nullable
as String,profile_name: null == profile_name ? _self.profile_name : profile_name // ignore: cast_nullable_to_non_nullable
as String,profile_photo_url: null == profile_photo_url ? _self.profile_photo_url : profile_photo_url // ignore: cast_nullable_to_non_nullable
as String,count_view: null == count_view ? _self.count_view : count_view // ignore: cast_nullable_to_non_nullable
as int,count_like: null == count_like ? _self.count_like : count_like // ignore: cast_nullable_to_non_nullable
as int,count_unlike: null == count_unlike ? _self.count_unlike : count_unlike // ignore: cast_nullable_to_non_nullable
as int,count_comments: null == count_comments ? _self.count_comments : count_comments // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,contents: null == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as List<ArticleContent>,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as DateTime,updated_at: freezed == updated_at ? _self.updated_at : updated_at // ignore: cast_nullable_to_non_nullable
as DateTime?,profile_point: freezed == profile_point ? _self.profile_point : profile_point // ignore: cast_nullable_to_non_nullable
as int?,is_notice: null == is_notice ? _self.is_notice : is_notice // ignore: cast_nullable_to_non_nullable
as bool,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<MainComment>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Article implements Article {
  const _Article({@JsonKey(fromJson: _toString) required this.id, @JsonKey(fromJson: _toString) required this.board_name, @JsonKey(fromJson: _toString) required this.profile_uid, @JsonKey(fromJson: _toString) required this.profile_name, @JsonKey(fromJson: _toString) required this.profile_photo_url, @JsonKey(fromJson: _toInt) required this.count_view, @JsonKey(fromJson: _toInt) required this.count_like, @JsonKey(fromJson: _toInt) required this.count_unlike, @JsonKey(fromJson: _toInt) required this.count_comments, @JsonKey(fromJson: _toString) required this.title, required final  List<ArticleContent> contents, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) required this.created_at, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJsonNullable) this.updated_at, @JsonKey(fromJson: _toInt) this.profile_point, required this.is_notice, this.thumbnail, final  List<MainComment>? comments}): _contents = contents,_comments = comments;
  factory _Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);

@override@JsonKey(fromJson: _toString) final  String id;
@override@JsonKey(fromJson: _toString) final  String board_name;
@override@JsonKey(fromJson: _toString) final  String profile_uid;
@override@JsonKey(fromJson: _toString) final  String profile_name;
@override@JsonKey(fromJson: _toString) final  String profile_photo_url;
@override@JsonKey(fromJson: _toInt) final  int count_view;
@override@JsonKey(fromJson: _toInt) final  int count_like;
@override@JsonKey(fromJson: _toInt) final  int count_unlike;
@override@JsonKey(fromJson: _toInt) final  int count_comments;
@override@JsonKey(fromJson: _toString) final  String title;
 final  List<ArticleContent> _contents;
@override List<ArticleContent> get contents {
  if (_contents is EqualUnmodifiableListView) return _contents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contents);
}

@override@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) final  DateTime created_at;
@override@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJsonNullable) final  DateTime? updated_at;
@override@JsonKey(fromJson: _toInt) final  int? profile_point;
@override final  bool is_notice;
@override final  String? thumbnail;
 final  List<MainComment>? _comments;
@override List<MainComment>? get comments {
  final value = _comments;
  if (value == null) return null;
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Article
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArticleCopyWith<_Article> get copyWith => __$ArticleCopyWithImpl<_Article>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArticleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Article&&(identical(other.id, id) || other.id == id)&&(identical(other.board_name, board_name) || other.board_name == board_name)&&(identical(other.profile_uid, profile_uid) || other.profile_uid == profile_uid)&&(identical(other.profile_name, profile_name) || other.profile_name == profile_name)&&(identical(other.profile_photo_url, profile_photo_url) || other.profile_photo_url == profile_photo_url)&&(identical(other.count_view, count_view) || other.count_view == count_view)&&(identical(other.count_like, count_like) || other.count_like == count_like)&&(identical(other.count_unlike, count_unlike) || other.count_unlike == count_unlike)&&(identical(other.count_comments, count_comments) || other.count_comments == count_comments)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._contents, _contents)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.updated_at, updated_at) || other.updated_at == updated_at)&&(identical(other.profile_point, profile_point) || other.profile_point == profile_point)&&(identical(other.is_notice, is_notice) || other.is_notice == is_notice)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&const DeepCollectionEquality().equals(other._comments, _comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,board_name,profile_uid,profile_name,profile_photo_url,count_view,count_like,count_unlike,count_comments,title,const DeepCollectionEquality().hash(_contents),created_at,updated_at,profile_point,is_notice,thumbnail,const DeepCollectionEquality().hash(_comments));

@override
String toString() {
  return 'Article(id: $id, board_name: $board_name, profile_uid: $profile_uid, profile_name: $profile_name, profile_photo_url: $profile_photo_url, count_view: $count_view, count_like: $count_like, count_unlike: $count_unlike, count_comments: $count_comments, title: $title, contents: $contents, created_at: $created_at, updated_at: $updated_at, profile_point: $profile_point, is_notice: $is_notice, thumbnail: $thumbnail, comments: $comments)';
}


}

/// @nodoc
abstract mixin class _$ArticleCopyWith<$Res> implements $ArticleCopyWith<$Res> {
  factory _$ArticleCopyWith(_Article value, $Res Function(_Article) _then) = __$ArticleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String id,@JsonKey(fromJson: _toString) String board_name,@JsonKey(fromJson: _toString) String profile_uid,@JsonKey(fromJson: _toString) String profile_name,@JsonKey(fromJson: _toString) String profile_photo_url,@JsonKey(fromJson: _toInt) int count_view,@JsonKey(fromJson: _toInt) int count_like,@JsonKey(fromJson: _toInt) int count_unlike,@JsonKey(fromJson: _toInt) int count_comments,@JsonKey(fromJson: _toString) String title, List<ArticleContent> contents,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime created_at,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJsonNullable) DateTime? updated_at,@JsonKey(fromJson: _toInt) int? profile_point, bool is_notice, String? thumbnail, List<MainComment>? comments
});




}
/// @nodoc
class __$ArticleCopyWithImpl<$Res>
    implements _$ArticleCopyWith<$Res> {
  __$ArticleCopyWithImpl(this._self, this._then);

  final _Article _self;
  final $Res Function(_Article) _then;

/// Create a copy of Article
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? board_name = null,Object? profile_uid = null,Object? profile_name = null,Object? profile_photo_url = null,Object? count_view = null,Object? count_like = null,Object? count_unlike = null,Object? count_comments = null,Object? title = null,Object? contents = null,Object? created_at = null,Object? updated_at = freezed,Object? profile_point = freezed,Object? is_notice = null,Object? thumbnail = freezed,Object? comments = freezed,}) {
  return _then(_Article(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,board_name: null == board_name ? _self.board_name : board_name // ignore: cast_nullable_to_non_nullable
as String,profile_uid: null == profile_uid ? _self.profile_uid : profile_uid // ignore: cast_nullable_to_non_nullable
as String,profile_name: null == profile_name ? _self.profile_name : profile_name // ignore: cast_nullable_to_non_nullable
as String,profile_photo_url: null == profile_photo_url ? _self.profile_photo_url : profile_photo_url // ignore: cast_nullable_to_non_nullable
as String,count_view: null == count_view ? _self.count_view : count_view // ignore: cast_nullable_to_non_nullable
as int,count_like: null == count_like ? _self.count_like : count_like // ignore: cast_nullable_to_non_nullable
as int,count_unlike: null == count_unlike ? _self.count_unlike : count_unlike // ignore: cast_nullable_to_non_nullable
as int,count_comments: null == count_comments ? _self.count_comments : count_comments // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,contents: null == contents ? _self._contents : contents // ignore: cast_nullable_to_non_nullable
as List<ArticleContent>,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as DateTime,updated_at: freezed == updated_at ? _self.updated_at : updated_at // ignore: cast_nullable_to_non_nullable
as DateTime?,profile_point: freezed == profile_point ? _self.profile_point : profile_point // ignore: cast_nullable_to_non_nullable
as int?,is_notice: null == is_notice ? _self.is_notice : is_notice // ignore: cast_nullable_to_non_nullable
as bool,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,comments: freezed == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<MainComment>?,
  ));
}


}

// dart format on
