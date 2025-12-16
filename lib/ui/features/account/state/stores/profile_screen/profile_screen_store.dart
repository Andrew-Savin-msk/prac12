import 'package:mobx/mobx.dart';
import 'package:prac12/core/models/account/user_account_model.dart';
import 'package:prac12/domain/usecases/account/get_current_user_usecase.dart';
import 'package:prac12/domain/usecases/account/restore_session_usecase.dart';

class ProfileScreenStore {
  ProfileScreenStore(
    this._getCurrentUserUseCase,
    this._restoreSessionUseCase,
  ) {
    _isLoggedIn = Computed(() => user != null);
    _restoreAndLoad();
  }

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final RestoreSessionUseCase _restoreSessionUseCase;

  final Observable<UserAccount?> _user = Observable(null);
  UserAccount? get user => _user.value;
  set user(UserAccount? value) => _user.value = value;

  late final Computed<bool> _isLoggedIn;
  bool get isLoggedIn => _isLoggedIn.value;

  /// Загрузить текущего пользователя из Supabase (GET /user)
  Future<void> loadCurrentUser() async {
    print('=== ProfileScreenStore.loadCurrentUser START ===');
    try {
      print('Calling _getCurrentUserUseCase()...');
      final currentUser = await _getCurrentUserUseCase();
      print('User received: ${currentUser.id}, ${currentUser.email}');
      runInAction(() {
        user = currentUser;
      });
      print('User set in store');
      print('=== ProfileScreenStore.loadCurrentUser SUCCESS ===');
    } catch (e, stackTrace) {
      print('ERROR loading current user from remote: $e');
      print('Stack trace: $stackTrace');
      runInAction(() {
        user = null;
      });
      print('User set to null in store');
      print('=== ProfileScreenStore.loadCurrentUser ERROR ===');
    }
  }

  /// Восстановить сессию и загрузить пользователя
  Future<void> _restoreAndLoad() async {
    // Сначала пытаемся восстановить сессию по токенам
    await _restoreSessionUseCase();
    // Затем загружаем текущего пользователя
    // Если токена нет, используем локального пользователя
    await loadCurrentUser();
  }
  
  /// Инициализировать пользователя из локального хранилища
  void initializeFromLocal() {
    // Можно добавить логику для загрузки локального пользователя, если нужно
  }
}

