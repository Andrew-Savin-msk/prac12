import 'package:prac12/data/datasources/account/account_local_datasource.dart';
import 'package:prac12/data/datasources/account/account_secure_storage_data_source.dart';
import 'package:prac12/core/models/account/user_account_model.dart';
import 'package:prac12/core/models/account/auth_tokens.dart';
import 'package:prac12/domain/repositories/account/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountLocalDataSource _dataSource;
  final AccountSecureStorageDataSource _secureStorage;

  AccountRepositoryImpl(this._dataSource, this._secureStorage);

  @override
  UserAccount? getCurrentUser() {
    return _dataSource.getCurrentUser();
  }

  @override
  bool get isLoggedIn => _dataSource.isLoggedIn;

  @override
  UserAccount register({
    required String name,
    required String email,
    required String password,
  }) {
    return _dataSource.register(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  void login({
    required String email,
    required String password,
  }) {
    _dataSource.login(email: email, password: password);
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
  void updateProfile({
    required String name,
    required String email,
    String? avatarUrl,
  }) {
    _dataSource.updateProfile(
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );
  }
}

