// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Track _$TrackFromJson(Map<String, dynamic> json) => _Track(
  id: json['id'] as String,
  videoId: json['videoId'] as String,
  title: _toString(json['title']),
  description: _toString(json['description']),
  thumbnail: json['thumbnail'] as String,
  duration: (json['duration'] as num).toInt(),
);

Map<String, dynamic> _$TrackToJson(_Track instance) => <String, dynamic>{
  'id': instance.id,
  'videoId': instance.videoId,
  'title': instance.title,
  'description': instance.description,
  'thumbnail': instance.thumbnail,
  'duration': instance.duration,
};
