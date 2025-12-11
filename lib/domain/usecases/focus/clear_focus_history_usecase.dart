import 'package:prac12/domain/repositories/focus/focus_session_repository.dart';

class ClearFocusHistoryUseCase {
  final FocusSessionRepository _repository;

  ClearFocusHistoryUseCase(this._repository);

  void call() {
    _repository.clearHistory();
  }
}

