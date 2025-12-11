import 'package:prac12/data/datasources/account/account_local_datasource.dart';
import 'package:prac12/data/datasources/account/account_secure_storage_data_source.dart';
import 'package:prac12/core/models/account/user_account_model.dart';
import 'package:prac12/core/models/account/auth_tokens.dart';
import 'package:prac12/domain/repositories/account/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountLocalDataSource _dataSource;
  final AccountSecureStorageDataSource _secureStorage;

  AccountRepositoryImpl(this._dataSource, this._secureStorage);
  
  /// Инициализация: загрузить пользователей из SQLite при старте
  Future<void> initialize() async {
    await _dataSource.initialize();
  }

  @override
  UserAccount? getCurrentUser() {
    return _dataSource.getCurrentUser();
  }

  @override
  bool get isLoggedIn => _dataSource.isLoggedIn;

  @override
  Future<UserAccount> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _dataSource.register(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _dataSource.login(email: email, password: password);
  }

  @override
  void logout() {
    _dataSource.logout();
    // Очищаем токены при выходе
    clearAuthTokens();
  }

  @override
  Future<void> saveAuthTokens(AuthTokens tokens) async {
    await _secureStorage.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      userId: tokens.userId,
      userEmail: tokens.userEmail,
    );
  }

  @override
  Future<AuthTokens?> getAuthTokens() async {
    return await _secureStorage.readTokens();
  }

  @override
  Future<void> clearAuthTokens() async {
    await _secureStorage.clearTokens();
  }

  @override
  Future<void> saveUserData(UserAccount user) async {
    await _secureStorage.saveUserData(user);
  }

  @override
  Future<void> restoreSession() async {
    // Если пользователь уже залогинен, ничего не делаем
    if (_dataSource.isLoggedIn) {
      return;
    }

    // Восстанавливаем сессию ТОЛЬКО из secure storage
    // Читаем полные данные пользователя из secure storage
    final user = await _secureStorage.readUserData();
    if (user == null) {
      // Нет сохранённых данных пользователя - очищаем токены
      await clearAuthTokens();
      return;
    }

    // Устанавливаем пользователя как текущего
    // Добавляем в список зарегистрированных, если его там нет
    _dataSource.setCurrentUser(user);
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String email,
    String? avatarUrl,
  }) async {
    await _dataSource.updateProfile(
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );
  }
}

