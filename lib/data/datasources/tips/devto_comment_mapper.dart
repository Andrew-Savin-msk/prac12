import 'package:prac12/core/models/tips/tip_comment_model.dart';
import 'package:prac12/data/datasources/tips/dto/devto_comment_dto.dart';

class DevtoCommentMapper {
  static TipComment toDomain(DevtoCommentDto dto) {
    DateTime? createdAt;
    try {
      if (dto.createdAt != null) {
        createdAt = DateTime.parse(dto.createdAt!);
      }
    } catch (_) {
      createdAt = null;
    }

    return TipComment(
      id: dto.id,
      bodyHtml: dto.bodyHtml ?? '',
      bodyMarkdown: dto.bodyMarkdown,
      createdAt: createdAt,
      authorName: dto.user?.name,
      authorUsername: dto.user?.username,
      authorProfileImage: dto.user?.profileImage,
      articleId: dto.articleId,
    );
  }
}

