// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devto_comment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevtoCommentDto _$DevtoCommentDtoFromJson(Map<String, dynamic> json) =>
    DevtoCommentDto(
      id: (json['id'] as num?)?.toInt(),
      bodyHtml: json['body_html'] as String?,
      bodyMarkdown: json['body_markdown'] as String?,
      createdAt: json['created_at'] as String?,
      user: json['user'] == null
          ? null
          : DevtoUserDto.fromJson(json['user'] as Map<String, dynamic>),
      articleId: (json['article_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DevtoCommentDtoToJson(DevtoCommentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body_html': instance.bodyHtml,
      'body_markdown': instance.bodyMarkdown,
      'created_at': instance.createdAt,
      'user': instance.user,
      'article_id': instance.articleId,
    };
