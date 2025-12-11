import 'package:prac12/domain/repositories/account/account_repository.dart';
import 'package:prac12/domain/repositories/activity_log/activity_log_repository.dart';

class UpdateProfileUseCase {
  final AccountRepository _accountRepository;
  final ActivityLogRepository _activityLogRepository;

  UpdateProfileUseCase(
    this._accountRepository,
    this._activityLogRepository,
  );

  void call({
    required String name,
    required String email,
    String? avatarUrl,
  }) {
    _accountRepository.updateProfile(
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );
    _activityLogRepository.logProfileUpdated(name, email);
  }
}

