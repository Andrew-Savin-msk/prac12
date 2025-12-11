import 'package:prac12/core/models/account/user_account_model.dart';
import 'package:prac12/data/datasources/account/account_sqlite_data_source.dart';

class AccountLocalDataSource {
  final AccountSqliteDataSource _sqliteDataSource;
  
  UserAccount? _currentUser;
  final List<UserAccount> _registeredUsers = [];

  AccountLocalDataSource(this._sqliteDataSource);

  UserAccount? getCurrentUser() => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  
  /// Инициализация: загрузить пользователей из SQLite при старте
  Future<void> initialize() async {
    try {
      final users = await _sqliteDataSource.getUsersFromDb();
      _registeredUsers.clear();
      _registeredUsers.addAll(users);
    } catch (e) {
      print('Ошибка при загрузке пользователей из SQLite: $e');
    }
  }

  Future<UserAccount> register({
    required String name,
    required String email,
    required String password,
  }) async {
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

    // Сохраняем в SQLite
    await _sqliteDataSource.insertUserToDb(user);
    
    _registeredUsers.add(user);
    _currentUser = user;
    return user;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    // Сначала ищем в памяти
    try {
      final user = _registeredUsers.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      _currentUser = user;
      return;
    } catch (e) {
      // Если не найден в памяти, ищем в SQLite
      final user = await _sqliteDataSource.findUserByEmail(email);
      if (user != null && user.password == password) {
        // Добавляем в память для быстрого доступа
        if (!_registeredUsers.any((u) => u.id == user.id)) {
          _registeredUsers.add(user);
        }
        _currentUser = user;
        return;
      }
      throw Exception('Неверный email или пароль');
    }
  }

  void logout() {
    _currentUser = null;
  }

  /// Установить текущего пользователя (используется при восстановлении сессии из secure storage)
  void setCurrentUser(UserAccount user) {
    _currentUser = user;
    // Добавляем в список зарегистрированных, если его там нет
    if (!_registeredUsers.any((u) => u.id == user.id)) {
      _registeredUsers.add(user);
    }
  }

  /// Восстановить сессию по email (если пользователь найден в списке зарегистрированных)
  Future<void> restoreSessionByEmail(String email) async {
    // Сначала ищем в памяти
    try {
      final user = _registeredUsers.firstWhere(
        (u) => u.email == email,
      );
      _currentUser = user;
      return;
    } catch (e) {
      // Если не найден в памяти, ищем в SQLite
      final user = await _sqliteDataSource.findUserByEmail(email);
      if (user != null) {
        // Добавляем в память для быстрого доступа
        if (!_registeredUsers.any((u) => u.id == user.id)) {
          _registeredUsers.add(user);
        }
        _currentUser = user;
      }
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    String? avatarUrl,
  }) async {
    if (_currentUser == null) return;

    _currentUser!
      ..name = name
      ..email = email
      ..avatarUrl = avatarUrl;
    
    // Обновляем в SQLite
    await _sqliteDataSource.updateUserInDb(_currentUser!);
  }
}

