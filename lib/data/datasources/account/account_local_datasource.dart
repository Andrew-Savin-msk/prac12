import 'package:prac12/core/models/account/user_account_model.dart';

class AccountLocalDataSource {
  UserAccount? _currentUser;
  final List<UserAccount> _registeredUsers = [];

  UserAccount? getCurrentUser() => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  UserAccount register({
    required String name,
    required String email,
    required String password,
  }) {
    final exists = _registeredUsers.any((u) => u.email == email);
    if (exists) {
      throw Exception('Пользователь с таким email уже существует');
    }

    final user = UserAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
    );

    _registeredUsers.add(user);
    _currentUser = user;
    return user;
  }

  void login({
    required String email,
    required String password,
  }) {
    final user = _registeredUsers.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => throw Exception('Неверный email или пароль'),
    );
    _currentUser = user;
  }

  void logout() {
    _currentUser = null;
  }

  void updateProfile({
    required String name,
    required String email,
    String? avatarUrl,
  }) {
    if (_currentUser == null) return;

    _currentUser!
      ..name = name
      ..email = email
      ..avatarUrl = avatarUrl;
  }
}

