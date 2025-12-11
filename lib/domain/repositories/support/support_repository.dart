import 'package:prac12/core/models/support/faq_item_model.dart';
import 'package:prac12/core/models/support/feedback_message_model.dart';

abstract class SupportRepository {
  List<FaqItem> getFaqItems();
  List<FeedbackMessage> getFeedbackMessages();
  void sendFeedback({
    required String subject,
    required String message,
    String? contact,
  });
}

