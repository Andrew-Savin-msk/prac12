class TipComment {
  final int? id;
  final String bodyHtml;
  final String? bodyMarkdown;
  final DateTime? createdAt;
  final String? authorName;
  final String? authorUsername;
  final String? authorProfileImage;
  final int? articleId;

  TipComment({
    this.id,
    required this.bodyHtml,
    this.bodyMarkdown,
    this.createdAt,
    this.authorName,
    this.authorUsername,
    this.authorProfileImage,
    this.articleId,
  });
}

