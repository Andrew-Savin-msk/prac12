import 'package:prac12/core/models/support/faq_item_model.dart';
import 'package:prac12/core/models/support/feedback_message_model.dart';

class SupportLocalDataSource {
  final List<FaqItem> _faqItems = [
    FaqItem(
      id: 'goals_purpose',
      question: 'Для чего нужно это приложение?',
      answer:
          'Приложение помогает ставить цели, разбивать их на подзадачи и отслеживать прогресс.',
    ),
    FaqItem(
      id: 'account_optional',
      question: 'Нужно ли обязательно входить в аккаунт?',
      answer:
          'Нет, вы можете пользоваться приложением и без аккаунта. Аккаунт нужен для персонализации и синхронизации (в будущем).',
    ),
    FaqItem(
      id: 'focus_sessions',
      question: 'Что такое фокус-сессии?',
      answer:
          'Это таймер, который помогает концентрироваться на задачах в течение ограниченного времени (например, 25 минут).',
    ),
    FaqItem(
      id: 'achievements',
      question: 'Как открываются ачивки?',
      answer:
          'Ачивки открываются автоматически при выполнении определённых действий: создание целей, их завершение, достижение прогресса и т.д.',
    ),
    FaqItem(
      id: 'activity_log',
      question: 'Что такое журнал действий?',
      answer:
          'Журнал действий показывает историю вашей активности в приложении: создание целей, вход в аккаунт, открытие статей и другие события.',
    ),
  ];

  final List<FeedbackMessage> _feedbackMessages = [];

  List<FaqItem> getFaqItems() {
    return List.unmodifiable(_faqItems);
  }

  List<FeedbackMessage> getFeedbackMessages() {
    return List.unmodifiable(_feedbackMessages);
  }

  void addFeedback(FeedbackMessage feedback) {
    _feedbackMessages.insert(0, feedback);
  }
}

