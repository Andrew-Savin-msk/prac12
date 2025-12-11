import 'package:prac12/domain/repositories/activity_log/activity_log_repository.dart';

class LogTipOpenedUseCase {
  final ActivityLogRepository _repository;

  LogTipOpenedUseCase(this._repository);

  void call(String tipTitle) {
    _repository.log(
      type: 'tip_opened',
      title: 'Открыта статья',
      description: tipTitle,
    );
  }
}

