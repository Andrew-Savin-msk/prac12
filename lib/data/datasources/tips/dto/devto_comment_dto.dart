import 'package:json_annotation/json_annotation.dart';
import 'package:prac12/data/datasources/tips/dto/devto_user_dto.dart';

part 'devto_comment_dto.g.dart';

@JsonSerializable()
class DevtoCommentDto {
  final int? id;
  @JsonKey(name: 'body_html')
  final String? bodyHtml;
  @JsonKey(name: 'body_markdown')
  final String? bodyMarkdown;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final DevtoUserDto? user;
  @JsonKey(name: 'article_id')
  final int? articleId;

  DevtoCommentDto({
    this.id,
    this.bodyHtml,
    this.bodyMarkdown,
    this.createdAt,
    this.user,
    this.articleId,
  });

  factory DevtoCommentDto.fromJson(Map<String, dynamic> json) =>
      _$DevtoCommentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DevtoCommentDtoToJson(this);
}

