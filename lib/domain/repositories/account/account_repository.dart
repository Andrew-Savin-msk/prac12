import 'package:prac12/core/models/account/user_account_model.dart';

abstract class AccountRepository {
  UserAccount? getCurrentUser();
  bool get isLoggedIn;
  UserAccount register({
    required String name,
    required String email,
    required String password,
  });
  void login({
    required String email,
    required String password,
  });
  void logout();
  void updateProfile({
    required String name,
    required String email,
    String? avatarUrl,
  });
}

