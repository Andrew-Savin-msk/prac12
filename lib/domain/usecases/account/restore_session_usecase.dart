// Доменный слой: use-case для восстановления сессии пользователя по токенам из secure storage
import 'package:prac12/domain/repositories/account/account_repository.dart';

/// Use case для восстановления сессии пользователя
class RestoreSessionUseCase {
  final AccountRepository _repository;

  RestoreSessionUseCase(this._repository);

  Future<void> call() async {
    await _repository.restoreSession();
  }
}
