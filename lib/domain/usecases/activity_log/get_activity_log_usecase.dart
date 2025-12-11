import 'package:prac12/core/models/activity_log/log_entry_model.dart';
import 'package:prac12/domain/repositories/activity_log/activity_log_repository.dart';

class GetActivityLogUseCase {
  final ActivityLogRepository _repository;

  GetActivityLogUseCase(this._repository);

  List<LogEntry> call() {
    return _repository.getEntries();
  }
}

