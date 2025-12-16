import 'package:prac12/core/models/tips/tip_article_model.dart';
import 'package:prac12/data/datasources/tips/dto/devto_article_dto.dart';

class DevtoArticleMapper {
  static TipArticle toDomain(DevtoArticleDto dto) {
    // Используем description как shortDescription, bodyMarkdown как content
    // Если description пустой, берем первые 100 символов из bodyMarkdown
    String shortDescription;
    try {
      shortDescription = dto.description?.isNotEmpty == true
          ? dto.description!
          : (dto.bodyMarkdown?.isNotEmpty == true
              ? dto.bodyMarkdown!.substring(0, dto.bodyMarkdown!.length > 100 ? 100 : dto.bodyMarkdown!.length)
              : 'No description');
    } catch (e) {
      print('Error parsing shortDescription for article ${dto.id}: $e');
      shortDescription = dto.description ?? dto.title ?? 'No description';
    }

    // Парсим дату из publishedAt или createdAt
    DateTime createdAt;
    try {
      if (dto.publishedAt != null) {
        createdAt = DateTime.parse(dto.publishedAt!);
      } else if (dto.createdAt != null) {
        createdAt = DateTime.parse(dto.createdAt!);
      } else {
        createdAt = DateTime.now();
      }
    } catch (_) {
      createdAt = DateTime.now();
    }

    // Берем первый тег как category, если есть
    final category = dto.tags?.isNotEmpty == true ? dto.tags!.first : null;

    return TipArticle(
      id: dto.id.toString(),
      title: dto.title ?? 'Untitled',
      shortDescription: shortDescription,
      content: dto.bodyMarkdown ?? '',
      createdAt: createdAt,
      category: category,
    );
  }
}

