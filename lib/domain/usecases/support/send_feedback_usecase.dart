import 'package:prac12/domain/repositories/support/support_repository.dart';
import 'package:prac12/domain/repositories/activity_log/activity_log_repository.dart';

class SendFeedbackUseCase {
  final SupportRepository _supportRepository;
  final ActivityLogRepository _activityLogRepository;

  SendFeedbackUseCase(
    this._supportRepository,
    this._activityLogRepository,
  );

  void call({
    required String subject,
    required String message,
    String? contact,
  }) {
    _supportRepository.sendFeedback(
      subject: subject,
      message: message,
      contact: contact,
    );
    _activityLogRepository.log(
      type: 'feedback_sent',
      title: 'Отправлен отзыв',
      description: subject.isNotEmpty ? subject : null,
    );
  }
}

