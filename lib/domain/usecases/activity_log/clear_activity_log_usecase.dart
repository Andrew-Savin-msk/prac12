import 'package:prac12/domain/repositories/activity_log/activity_log_repository.dart';

class ClearActivityLogUseCase {
  final ActivityLogRepository _repository;

  ClearActivityLogUseCase(this._repository);

  void call() {
    _repository.clear();
  }
}

