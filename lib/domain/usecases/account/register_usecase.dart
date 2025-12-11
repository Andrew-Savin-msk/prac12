import 'package:prac12/core/models/account/user_account_model.dart';
import 'package:prac12/domain/repositories/account/account_repository.dart';
import 'package:prac12/domain/repositories/activity_log/activity_log_repository.dart';

class RegisterUseCase {
  final AccountRepository _accountRepository;
  final ActivityLogRepository _activityLogRepository;

  RegisterUseCase(
    this._accountRepository,
    this._activityLogRepository,
  );

  UserAccount call({
    required String name,
    required String email,
    required String password,
  }) {
    final user = _accountRepository.register(
      name: name,
      email: email,
      password: password,
    );
    _activityLogRepository.logAuthLogin(email);
    return user;
  }
}

