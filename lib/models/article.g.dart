// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Article _$ArticleFromJson(Map<String, dynamic> json) => _Article(
  key: _toString(json['key']),
  board_index: (json['board_index'] as num).toInt(),
  profile_key: _toString(json['profile_key']),
  profile_name: _toString(json['profile_name']),
  count_view: _toInt(json['count_view']),
  count_like: _toInt(json['count_like']),
  count_unlike: _toInt(json['count_unlike']),
  title: _toString(json['title']),
  contents:
      (json['contents'] as List<dynamic>)
          .map((e) => ArticleContent.fromJson(e as Map<String, dynamic>))
          .toList(),
  created_at: _toString(json['created_at']),
  comments:
      (json['comments'] as List<dynamic>)
          .map((e) => MainComment.fromJson(e as Map<String, dynamic>))
          .toList(),
  is_notice: json['is_notice'] as bool,
  thumbnail: json['thumbnail'] as String?,
);

Map<String, dynamic> _$ArticleToJson(_Article instance) => <String, dynamic>{
  'key': instance.key,
  'board_index': instance.board_index,
  'profile_key': instance.profile_key,
  'profile_name': instance.profile_name,
  'count_view': instance.count_view,
  'count_like': instance.count_like,
  'count_unlike': instance.count_unlike,
  'title': instance.title,
  'contents': instance.contents,
  'created_at': instance.created_at,
  'comments': instance.comments,
  'is_notice': instance.is_notice,
  'thumbnail': instance.thumbnail,
};
