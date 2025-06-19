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

@JsonKey(fromJson: _toString) String get key; int get board_index;@JsonKey(fromJson: _toString) String get profile_key;@JsonKey(fromJson: _toString) String get profile_name;@JsonKey(fromJson: _toInt) int get count_view;@JsonKey(fromJson: _toInt) int get count_like;@JsonKey(fromJson: _toInt) int get count_unlike;@JsonKey(fromJson: _toString) String get title; List<ArticleContent> get contents;@JsonKey(fromJson: _toString) String get created_at; List<MainComment> get comments; bool get is_notice; String? get thumbnail;
/// Create a copy of Article
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArticleCopyWith<Article> get copyWith => _$ArticleCopyWithImpl<Article>(this as Article, _$identity);

  /// Serializes this Article to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Article&&(identical(other.key, key) || other.key == key)&&(identical(other.board_index, board_index) || other.board_index == board_index)&&(identical(other.profile_key, profile_key) || other.profile_key == profile_key)&&(identical(other.profile_name, profile_name) || other.profile_name == profile_name)&&(identical(other.count_view, count_view) || other.count_view == count_view)&&(identical(other.count_like, count_like) || other.count_like == count_like)&&(identical(other.count_unlike, count_unlike) || other.count_unlike == count_unlike)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.contents, contents)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&const DeepCollectionEquality().equals(other.comments, comments)&&(identical(other.is_notice, is_notice) || other.is_notice == is_notice)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,board_index,profile_key,profile_name,count_view,count_like,count_unlike,title,const DeepCollectionEquality().hash(contents),created_at,const DeepCollectionEquality().hash(comments),is_notice,thumbnail);

@override
String toString() {
  return 'Article(key: $key, board_index: $board_index, profile_key: $profile_key, profile_name: $profile_name, count_view: $count_view, count_like: $count_like, count_unlike: $count_unlike, title: $title, contents: $contents, created_at: $created_at, comments: $comments, is_notice: $is_notice, thumbnail: $thumbnail)';
}


}

/// @nodoc
abstract mixin class $ArticleCopyWith<$Res>  {
  factory $ArticleCopyWith(Article value, $Res Function(Article) _then) = _$ArticleCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String key, int board_index,@JsonKey(fromJson: _toString) String profile_key,@JsonKey(fromJson: _toString) String profile_name,@JsonKey(fromJson: _toInt) int count_view,@JsonKey(fromJson: _toInt) int count_like,@JsonKey(fromJson: _toInt) int count_unlike,@JsonKey(fromJson: _toString) String title, List<ArticleContent> contents,@JsonKey(fromJson: _toString) String created_at, List<MainComment> comments, bool is_notice, String? thumbnail
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
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? board_index = null,Object? profile_key = null,Object? profile_name = null,Object? count_view = null,Object? count_like = null,Object? count_unlike = null,Object? title = null,Object? contents = null,Object? created_at = null,Object? comments = null,Object? is_notice = null,Object? thumbnail = freezed,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,board_index: null == board_index ? _self.board_index : board_index // ignore: cast_nullable_to_non_nullable
as int,profile_key: null == profile_key ? _self.profile_key : profile_key // ignore: cast_nullable_to_non_nullable
as String,profile_name: null == profile_name ? _self.profile_name : profile_name // ignore: cast_nullable_to_non_nullable
as String,count_view: null == count_view ? _self.count_view : count_view // ignore: cast_nullable_to_non_nullable
as int,count_like: null == count_like ? _self.count_like : count_like // ignore: cast_nullable_to_non_nullable
as int,count_unlike: null == count_unlike ? _self.count_unlike : count_unlike // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,contents: null == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as List<ArticleContent>,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as String,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<MainComment>,is_notice: null == is_notice ? _self.is_notice : is_notice // ignore: cast_nullable_to_non_nullable
as bool,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Article implements Article {
  const _Article({@JsonKey(fromJson: _toString) required this.key, required this.board_index, @JsonKey(fromJson: _toString) required this.profile_key, @JsonKey(fromJson: _toString) required this.profile_name, @JsonKey(fromJson: _toInt) required this.count_view, @JsonKey(fromJson: _toInt) required this.count_like, @JsonKey(fromJson: _toInt) required this.count_unlike, @JsonKey(fromJson: _toString) required this.title, required final  List<ArticleContent> contents, @JsonKey(fromJson: _toString) required this.created_at, required final  List<MainComment> comments, required this.is_notice, this.thumbnail}): _contents = contents,_comments = comments;
  factory _Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);

@override@JsonKey(fromJson: _toString) final  String key;
@override final  int board_index;
@override@JsonKey(fromJson: _toString) final  String profile_key;
@override@JsonKey(fromJson: _toString) final  String profile_name;
@override@JsonKey(fromJson: _toInt) final  int count_view;
@override@JsonKey(fromJson: _toInt) final  int count_like;
@override@JsonKey(fromJson: _toInt) final  int count_unlike;
@override@JsonKey(fromJson: _toString) final  String title;
 final  List<ArticleContent> _contents;
@override List<ArticleContent> get contents {
  if (_contents is EqualUnmodifiableListView) return _contents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contents);
}

@override@JsonKey(fromJson: _toString) final  String created_at;
 final  List<MainComment> _comments;
@override List<MainComment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

@override final  bool is_notice;
@override final  String? thumbnail;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Article&&(identical(other.key, key) || other.key == key)&&(identical(other.board_index, board_index) || other.board_index == board_index)&&(identical(other.profile_key, profile_key) || other.profile_key == profile_key)&&(identical(other.profile_name, profile_name) || other.profile_name == profile_name)&&(identical(other.count_view, count_view) || other.count_view == count_view)&&(identical(other.count_like, count_like) || other.count_like == count_like)&&(identical(other.count_unlike, count_unlike) || other.count_unlike == count_unlike)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._contents, _contents)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&const DeepCollectionEquality().equals(other._comments, _comments)&&(identical(other.is_notice, is_notice) || other.is_notice == is_notice)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,board_index,profile_key,profile_name,count_view,count_like,count_unlike,title,const DeepCollectionEquality().hash(_contents),created_at,const DeepCollectionEquality().hash(_comments),is_notice,thumbnail);

@override
String toString() {
  return 'Article(key: $key, board_index: $board_index, profile_key: $profile_key, profile_name: $profile_name, count_view: $count_view, count_like: $count_like, count_unlike: $count_unlike, title: $title, contents: $contents, created_at: $created_at, comments: $comments, is_notice: $is_notice, thumbnail: $thumbnail)';
}


}

/// @nodoc
abstract mixin class _$ArticleCopyWith<$Res> implements $ArticleCopyWith<$Res> {
  factory _$ArticleCopyWith(_Article value, $Res Function(_Article) _then) = __$ArticleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String key, int board_index,@JsonKey(fromJson: _toString) String profile_key,@JsonKey(fromJson: _toString) String profile_name,@JsonKey(fromJson: _toInt) int count_view,@JsonKey(fromJson: _toInt) int count_like,@JsonKey(fromJson: _toInt) int count_unlike,@JsonKey(fromJson: _toString) String title, List<ArticleContent> contents,@JsonKey(fromJson: _toString) String created_at, List<MainComment> comments, bool is_notice, String? thumbnail
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
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? board_index = null,Object? profile_key = null,Object? profile_name = null,Object? count_view = null,Object? count_like = null,Object? count_unlike = null,Object? title = null,Object? contents = null,Object? created_at = null,Object? comments = null,Object? is_notice = null,Object? thumbnail = freezed,}) {
  return _then(_Article(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,board_index: null == board_index ? _self.board_index : board_index // ignore: cast_nullable_to_non_nullable
as int,profile_key: null == profile_key ? _self.profile_key : profile_key // ignore: cast_nullable_to_non_nullable
as String,profile_name: null == profile_name ? _self.profile_name : profile_name // ignore: cast_nullable_to_non_nullable
as String,count_view: null == count_view ? _self.count_view : count_view // ignore: cast_nullable_to_non_nullable
as int,count_like: null == count_like ? _self.count_like : count_like // ignore: cast_nullable_to_non_nullable
as int,count_unlike: null == count_unlike ? _self.count_unlike : count_unlike // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,contents: null == contents ? _self._contents : contents // ignore: cast_nullable_to_non_nullable
as List<ArticleContent>,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as String,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<MainComment>,is_notice: null == is_notice ? _self.is_notice : is_notice // ignore: cast_nullable_to_non_nullable
as bool,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
