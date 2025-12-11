import 'package:prac12/core/models/account/user_account_model.dart';
import 'package:prac12/core/models/account/auth_tokens.dart';

abstract class AccountRepository {
  UserAccount? getCurrentUser();
  bool get isLoggedIn;
  Future<void> initialize();
  Future<UserAccount> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> login({
    required String email,
    required String password,
  });
  void logout();
  Future<void> updateProfile({
    required String name,
    required String email,
    String? avatarUrl,
  });
  Future<void> saveAuthTokens(AuthTokens tokens);
  Future<AuthTokens?> getAuthTokens();
  Future<void> clearAuthTokens();
  Future<void> saveUserData(UserAccount user);
  Future<void> restoreSession();
}

