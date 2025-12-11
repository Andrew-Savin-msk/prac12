import 'package:prac12/core/models/focus/focus_session_model.dart';

abstract class FocusSessionRepository {
  List<FocusSession> getSessions();
  void addSession(FocusSession session);
  void clearHistory();
}

