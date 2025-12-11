// Доменный слой: use-case для очистки токенов авторизации из secure storage через репозиторий
import 'package:prac12/domain/repositories/account/account_repository.dart';

/// Use case для очистки токенов авторизации
class ClearAuthTokensUseCase {
  final AccountRepository _repository;

  ClearAuthTokensUseCase(this._repository);

  Future<void> call() async {
    await _repository.clearAuthTokens();
  }
}
