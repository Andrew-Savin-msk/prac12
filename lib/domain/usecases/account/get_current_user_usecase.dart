import 'package:prac12/core/models/account/user_account_model.dart';
import 'package:prac12/domain/repositories/account/account_repository.dart';

class GetCurrentUserUseCase {
  final AccountRepository _accountRepository;

  GetCurrentUserUseCase(this._accountRepository);

  /// Получить текущего пользователя из Supabase (GET /user)
  Future<UserAccount> call() async {
    return await _accountRepository.getCurrentUserFromRemote();
  }
}

