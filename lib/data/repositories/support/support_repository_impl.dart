import 'package:prac12/data/datasources/support/support_local_datasource.dart';
import 'package:prac12/core/models/support/faq_item_model.dart';
import 'package:prac12/core/models/support/feedback_message_model.dart';
import 'package:prac12/domain/repositories/support/support_repository.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportLocalDataSource _dataSource;

  SupportRepositoryImpl(this._dataSource);

  @override
  List<FaqItem> getFaqItems() {
    return _dataSource.getFaqItems();
  }

  @override
  List<FeedbackMessage> getFeedbackMessages() {
    return _dataSource.getFeedbackMessages();
  }

  @override
  void sendFeedback({
    required String subject,
    required String message,
    String? contact,
  }) {
    final feedback = FeedbackMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subject: subject,
      message: message,
      contact: contact,
      createdAt: DateTime.now(),
    );
    _dataSource.addFeedback(feedback);
  }
}

