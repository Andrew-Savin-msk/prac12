// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devto_article_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevtoArticleDto _$DevtoArticleDtoFromJson(Map<String, dynamic> json) =>
    DevtoArticleDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      bodyMarkdown: json['body_markdown'] as String?,
      publishedAt: json['published_at'] as String?,
      createdAt: json['created_at'] as String?,
      tags: DevtoArticleDto._tagsFromJson(json['tags']),
      user: json['user'] == null
          ? null
          : DevtoUserDto.fromJson(json['user'] as Map<String, dynamic>),
      coverImage: json['cover_image'] as String?,
      readingTimeMinutes: (json['reading_time_minutes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DevtoArticleDtoToJson(DevtoArticleDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'body_markdown': instance.bodyMarkdown,
      'published_at': instance.publishedAt,
      'created_at': instance.createdAt,
      'tags': instance.tags,
      'user': instance.user,
      'cover_image': instance.coverImage,
      'reading_time_minutes': instance.readingTimeMinutes,
    };
