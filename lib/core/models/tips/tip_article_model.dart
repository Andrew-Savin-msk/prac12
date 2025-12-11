class TipArticle {
  final String id;
  final String title;
  final String shortDescription;
  final String content;
  final DateTime createdAt;
  final String? category;

  TipArticle({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.content,
    required this.createdAt,
    this.category,
  });
}
