import 'package:prac12/core/models/focus/focus_session_model.dart';

class FocusSessionLocalDataSource {
  final List<FocusSession> _sessions = [];

  List<FocusSession> getSessions() {
    return List.unmodifiable(_sessions);
  }

  void addSession(FocusSession session) {
    _sessions.insert(0, session);
  }

  void clearHistory() {
    _sessions.clear();
  }
}

