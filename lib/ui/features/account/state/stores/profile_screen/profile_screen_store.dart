import 'package:mobx/mobx.dart';
import 'package:prac12/core/models/account/user_account_model.dart';
import 'package:prac12/domain/usecases/account/get_current_user_usecase.dart';
import 'package:prac12/domain/usecases/account/get_auth_tokens_usecase.dart';

class ProfileScreenStore {
  ProfileScreenStore(
    this._getCurrentUserUseCase,
    this._getAuthTokensUseCase,
  ) {
    _isLoggedIn = Computed(() => user != null);
    loadCurrentUser();
    _loadAuthTokens();
  }

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetAuthTokensUseCase _getAuthTokensUseCase;

  final Observable<UserAccount?> _user = Observable(null);
  UserAccount? get user => _user.value;
  set user(UserAccount? value) => _user.value = value;

  late final Computed<bool> _isLoggedIn;
  bool get isLoggedIn => _isLoggedIn.value;

  void loadCurrentUser() {
    runInAction(() {
      user = _getCurrentUserUseCase();
    });
  }

  /// Загрузить токены авторизации из secure storage (технический метод)
  Future<void> _loadAuthTokens() async {
    try {
      final tokens = await _getAuthTokensUseCase();
      // Токены загружены, можно использовать для проверки авторизации
      // или для других технических целей
      if (tokens != null) {
        // Токены есть - пользователь был авторизован
        // В реальном приложении здесь можно проверить валидность токена
      }
    } catch (e) {
      // Игнорируем ошибки при чтении токенов
    }
  }
}

