class FeedbackMessage {
  final String id;
  final String subject;
  final String message;
  final String? contact;
  final DateTime createdAt;

  FeedbackMessage({
    required this.id,
    required this.subject,
    required this.message,
    this.contact,
    required this.createdAt,
  });
}

