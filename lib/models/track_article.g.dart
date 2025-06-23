// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackArticle _$TrackArticleFromJson(Map<String, dynamic> json) =>
    _TrackArticle(
      id: _toString(json['id']),
      profile_uid: _toString(json['profile_uid']),
      profile_name: _toString(json['profile_name']),
      profile_photo_url: _toString(json['profile_photo_url']),
      count_view: _toInt(json['count_view']),
      count_like: _toInt(json['count_like']),
      count_unlike: _toInt(json['count_unlike']),
      count_comments: _toInt(json['count_comments']),
      count_favorite:
          json['count_favorite'] == null ? 0 : _toInt(json['count_favorite']),
      title: _toString(json['title']),
      tracks:
          (json['tracks'] as List<dynamic>?)
              ?.map((e) => Track.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      created_at: _timestampFromJson(json['created_at']),
      updated_at: _timestampFromJson(json['updated_at']),
      profile_point: _toInt(json['profile_point']),
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map((e) => MainComment.fromJson(e as Map<String, dynamic>))
              .toList(),
      total_duration:
          json['total_duration'] == null ? 0 : _toInt(json['total_duration']),
      track_count:
          json['track_count'] == null ? 0 : _toInt(json['track_count']),
      description:
          json['description'] == null ? '' : _toString(json['description']),
    );

Map<String, dynamic> _$TrackArticleToJson(_TrackArticle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profile_uid': instance.profile_uid,
      'profile_name': instance.profile_name,
      'profile_photo_url': instance.profile_photo_url,
      'count_view': instance.count_view,
      'count_like': instance.count_like,
      'count_unlike': instance.count_unlike,
      'count_comments': instance.count_comments,
      'count_favorite': instance.count_favorite,
      'title': instance.title,
      'tracks': instance.tracks,
      'created_at': _timestampToJson(instance.created_at),
      'updated_at': _timestampToJsonNullable(instance.updated_at),
      'profile_point': instance.profile_point,
      'comments': instance.comments,
      'total_duration': instance.total_duration,
      'track_count': instance.track_count,
      'description': instance.description,
    };
