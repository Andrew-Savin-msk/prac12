import 'package:mobx/mobx.dart';
import 'package:prac12/core/models/account/user_account_model.dart';
import 'package:prac12/domain/usecases/account/get_current_user_usecase.dart';
import 'package:prac12/domain/usecases/account/get_auth_tokens_usecase.dart';
import 'package:prac12/domain/usecases/account/restore_session_usecase.dart';

class ProfileScreenStore {
  ProfileScreenStore(
    this._getCurrentUserUseCase,
    this._getAuthTokensUseCase,
    this._restoreSessionUseCase,
  ) {
    _isLoggedIn = Computed(() => user != null);
    _restoreAndLoad();
  }

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetAuthTokensUseCase _getAuthTokensUseCase;
  final RestoreSessionUseCase _restoreSessionUseCase;

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

  /// Восстановить сессию и загрузить пользователя
  Future<void> _restoreAndLoad() async {
    // Сначала пытаемся восстановить сессию по токенам
    await _restoreSessionUseCase();
    // Затем загружаем текущего пользователя
    loadCurrentUser();
  }
}

