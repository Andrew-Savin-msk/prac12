import 'package:prac12/domain/repositories/account/account_repository.dart';
import 'package:prac12/domain/repositories/activity_log/activity_log_repository.dart';

class LoginUseCase {
  final AccountRepository _accountRepository;
  final ActivityLogRepository _activityLogRepository;

  LoginUseCase(
    this._accountRepository,
    this._activityLogRepository,
  );

  void call({
    required String email,
    required String password,
  }) {
    _accountRepository.login(email: email, password: password);
    _activityLogRepository.logAuthLogin(email);
  }
}

