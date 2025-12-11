// Доменный слой: use-case для получения токенов авторизации из secure storage через репозиторий
import 'package:prac12/core/models/account/auth_tokens.dart';
import 'package:prac12/domain/repositories/account/account_repository.dart';

/// Use case для получения токенов авторизации
class GetAuthTokensUseCase {
  final AccountRepository _repository;

  GetAuthTokensUseCase(this._repository);

  Future<AuthTokens?> call() async {
    return await _repository.getAuthTokens();
  }
}
