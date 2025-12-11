import 'package:prac12/data/datasources/focus/focus_session_local_datasource.dart';
import 'package:prac12/core/models/focus/focus_session_model.dart';
import 'package:prac12/domain/repositories/focus/focus_session_repository.dart';

class FocusSessionRepositoryImpl implements FocusSessionRepository {
  final FocusSessionLocalDataSource _dataSource;

  FocusSessionRepositoryImpl(this._dataSource);

  @override
  List<FocusSession> getSessions() {
    return _dataSource.getSessions();
  }

  @override
  void addSession(FocusSession session) {
    _dataSource.addSession(session);
  }

  @override
  void clearHistory() {
    _dataSource.clearHistory();
  }
}

