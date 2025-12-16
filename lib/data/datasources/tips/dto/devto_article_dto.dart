import 'package:json_annotation/json_annotation.dart';
import 'package:prac12/data/datasources/tips/dto/devto_user_dto.dart';

part 'devto_article_dto.g.dart';

@JsonSerializable()
class DevtoArticleDto {
  final int id;
  final String? title;
  final String? description;
  @JsonKey(name: 'body_markdown')
  final String? bodyMarkdown;
  @JsonKey(name: 'published_at')
  final String? publishedAt;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'tags', fromJson: _tagsFromJson)
  final List<String>? tags;
  final DevtoUserDto? user;
  @JsonKey(name: 'cover_image')
  final String? coverImage;
  @JsonKey(name: 'reading_time_minutes')
  final int? readingTimeMinutes;

  DevtoArticleDto({
    required this.id,
    this.title,
    this.description,
    this.bodyMarkdown,
    this.publishedAt,
    this.createdAt,
    this.tags,
    this.user,
    this.coverImage,
    this.readingTimeMinutes,
  });

  factory DevtoArticleDto.fromJson(Map<String, dynamic> json) =>
      _$DevtoArticleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DevtoArticleDtoToJson(this);

  /// Кастомный конвертер для tags: может быть массивом строк, строкой или массивом объектов
  static List<String>? _tagsFromJson(dynamic json) {
    if (json == null) return null;
    
    if (json is List) {
      // Если это массив
      return json.map((e) {
        if (e is String) {
          return e;
        } else if (e is Map) {
          // Если это массив объектов с полем 'name'
          return e['name'] as String? ?? '';
        } else {
          return e.toString();
        }
      }).where((e) => e.isNotEmpty).toList();
    } else if (json is String) {
      // Если это строка (разделенная запятыми)
      return json.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    
    return null;
  }
}

