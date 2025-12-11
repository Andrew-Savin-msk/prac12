import 'package:prac12/core/models/focus/focus_session_model.dart';
import 'package:prac12/domain/repositories/focus/focus_session_repository.dart';
import 'package:prac12/domain/repositories/activity_log/activity_log_repository.dart';

class AddFocusSessionUseCase {
  final FocusSessionRepository _focusSessionRepository;
  final ActivityLogRepository _activityLogRepository;

  AddFocusSessionUseCase(
    this._focusSessionRepository,
    this._activityLogRepository,
  );

  void call(FocusSession session) {
    _focusSessionRepository.addSession(session);
    if (session.completed) {
      _activityLogRepository.log(
        type: 'focus_completed',
        title: 'Фокус-сессия завершена',
        description:
            'Длительность: ${session.plannedDurationMinutes} минут, фактически: ${session.actualDuration.inMinutes} минут',
      );
    } else {
      _activityLogRepository.log(
        type: 'focus_cancelled',
        title: 'Фокус-сессия прервана',
        description:
            'Фактическая длительность: ${session.actualDuration.inMinutes} минут',
      );
    }
  }
}

