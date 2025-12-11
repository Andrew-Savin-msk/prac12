import 'package:prac12/core/models/account/auth_tokens.dart';
import 'package:prac12/domain/repositories/account/account_repository.dart';
import 'package:prac12/domain/repositories/activity_log/activity_log_repository.dart';
import 'package:prac12/domain/usecases/account/save_auth_tokens_usecase.dart';

class LoginUseCase {
  final AccountRepository _accountRepository;
  final ActivityLogRepository _activityLogRepository;
  final SaveAuthTokensUseCase _saveAuthTokensUseCase;

  LoginUseCase(
    this._accountRepository,
    this._activityLogRepository,
    this._saveAuthTokensUseCase,
  );

  Future<void> call({
    required String email,
    required String password,
  }) async {
    await _accountRepository.login(email: email, password: password);
    _activityLogRepository.logAuthLogin(email);
    
    // После успешного логина сохраняем токены и полные данные пользователя в secure storage
    final user = _accountRepository.getCurrentUser();
    if (user != null) {
      // Создаём токены на основе данных пользователя
      // В реальном приложении токены приходят с сервера
      final tokens = AuthTokens(
        accessToken: 'access_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'refresh_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}',
        userId: user.id,
        userEmail: user.email, // Сохраняем email для восстановления сессии
      );
      await _saveAuthTokensUseCase(tokens);
      
      // Сохраняем полные данные пользователя в secure storage для восстановления сессии
      await _accountRepository.saveUserData(user);
    }
  }
}

