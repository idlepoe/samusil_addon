// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_contents.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArticleContent _$ArticleContentFromJson(Map<String, dynamic> json) =>
    _ArticleContent(
      isPicture: json['isPicture'] as bool,
      isOriginal: json['isOriginal'] as bool?,
      contents: json['contents'] as String,
      isBold: _toBool(json['isBold']),
    );

Map<String, dynamic> _$ArticleContentToJson(_ArticleContent instance) =>
    <String, dynamic>{
      'isPicture': instance.isPicture,
      'isOriginal': instance.isOriginal,
      'contents': instance.contents,
      'isBold': instance.isBold,
    };
