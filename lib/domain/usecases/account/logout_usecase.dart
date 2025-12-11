import 'package:prac12/domain/repositories/account/account_repository.dart';
import 'package:prac12/domain/repositories/activity_log/activity_log_repository.dart';

class LogoutUseCase {
  final AccountRepository _accountRepository;
  final ActivityLogRepository _activityLogRepository;

  LogoutUseCase(
    this._accountRepository,
    this._activityLogRepository,
  );

  void call() {
    _accountRepository.logout();
    _activityLogRepository.logAuthLogout();
  }
}

