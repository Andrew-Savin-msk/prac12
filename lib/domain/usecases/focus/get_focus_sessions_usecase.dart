import 'package:prac12/core/models/focus/focus_session_model.dart';
import 'package:prac12/domain/repositories/focus/focus_session_repository.dart';

class GetFocusSessionsUseCase {
  final FocusSessionRepository _repository;

  GetFocusSessionsUseCase(this._repository);

  List<FocusSession> call() {
    return _repository.getSessions();
  }
}

