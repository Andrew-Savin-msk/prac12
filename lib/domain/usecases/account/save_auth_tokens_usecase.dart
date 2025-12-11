// Доменный слой: use-case для сохранения токенов авторизации в secure storage через репозиторий
import 'package:prac12/core/models/account/auth_tokens.dart';
import 'package:prac12/domain/repositories/account/account_repository.dart';

/// Use case для сохранения токенов авторизации
class SaveAuthTokensUseCase {
  final AccountRepository _repository;

  SaveAuthTokensUseCase(this._repository);

  Future<void> call(AuthTokens tokens) async {
    await _repository.saveAuthTokens(tokens);
  }
}
