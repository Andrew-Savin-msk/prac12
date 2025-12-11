import 'package:mobx/mobx.dart';
import 'package:prac12/domain/usecases/support/send_feedback_usecase.dart';

class FeedbackScreenStore {
  FeedbackScreenStore(this._sendFeedbackUseCase) {
    _canSend = Computed(() =>
        subject.trim().isNotEmpty && message.trim().isNotEmpty && !isSending);
  }

  final SendFeedbackUseCase _sendFeedbackUseCase;

  final Observable<String> _subject = Observable('');
  String get subject => _subject.value;
  set subject(String value) => _subject.value = value;

  final Observable<String> _message = Observable('');
  String get message => _message.value;
  set message(String value) => _message.value = value;

  final Observable<String> _contact = Observable('');
  String get contact => _contact.value;
  set contact(String value) => _contact.value = value;

  final Observable<String?> _errorMessage = Observable(null);
  String? get errorMessage => _errorMessage.value;
  set errorMessage(String? value) => _errorMessage.value = value;

  final Observable<bool> _isSending = Observable(false);
  bool get isSending => _isSending.value;
  set isSending(bool value) => _isSending.value = value;

  final Observable<bool> _isSent = Observable(false);
  bool get isSent => _isSent.value;
  set isSent(bool value) => _isSent.value = value;

  late final Computed<bool> _canSend;
  bool get canSend => _canSend.value;

  void setSubject(String value) {
    runInAction(() {
      subject = value;
      errorMessage = null;
    });
  }

  void setMessage(String value) {
    runInAction(() {
      message = value;
      errorMessage = null;
    });
  }

  void setContact(String value) {
    runInAction(() {
      contact = value;
      errorMessage = null;
    });
  }

  void clearStatus() {
    runInAction(() {
      errorMessage = null;
      isSent = false;
    });
  }

  Future<void> send() async {
    if (!canSend) return;

    runInAction(() {
      isSending = true;
      errorMessage = null;
    });

    try {
      _sendFeedbackUseCase(
        subject: subject.trim(),
        message: message.trim(),
        contact: contact.trim().isEmpty ? null : contact.trim(),
      );
      runInAction(() {
        isSent = true;
        subject = '';
        message = '';
        contact = '';
      });
    } catch (e) {
      runInAction(() {
        errorMessage = 'Не удалось отправить отзыв.';
      });
    } finally {
      runInAction(() {
        isSending = false;
      });
    }
  }
}

