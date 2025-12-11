// Data-слой: обёртка над SQLite для работы с пользователями (Account)
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:prac12/core/models/account/user_account_model.dart';

/// Data source для работы с пользователями в SQLite базе данных
class AccountSqliteDataSource {
  static const String _databaseName = 'accounts.db';
  static const int _databaseVersion = 1;
  static const String _tableName = 'users';

  Database? _database;

  /// Получить экземпляр базы данных (создаёт при первом обращении)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Инициализация базы данных
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  /// Создание таблицы при первом запуске
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        avatarUrl TEXT
      )
    ''');
  }

  /// Преобразование UserAccount в Map для SQLite
  Map<String, Object?> _userToMap(UserAccount user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'password': user.password,
      'avatarUrl': user.avatarUrl,
    };
  }

  /// Преобразование Map из SQLite в UserAccount
  UserAccount _mapToUser(Map<String, Object?> map) {
    return UserAccount(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      avatarUrl: map['avatarUrl'] as String?,
    );
  }

  /// Получить всех пользователей из базы данных
  Future<List<UserAccount>> getUsersFromDb() async {
    try {
      final db = await database;
      final maps = await db.query(_tableName);
      return maps.map((map) => _mapToUser(map)).toList();
    } catch (e) {
      print('Ошибка при чтении пользователей из SQLite: $e');
      return [];
    }
  }

  /// Вставить пользователя в базу данных
  Future<void> insertUserToDb(UserAccount user) async {
    try {
      final db = await database;
      final map = _userToMap(user);
      await db.insert(
        _tableName,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Ошибка при вставке пользователя в SQLite: $e');
      rethrow; // Пробрасываем ошибку, чтобы обработать дубликат email
    }
  }

  /// Обновить пользователя в базе данных
  Future<void> updateUserInDb(UserAccount user) async {
    try {
      final db = await database;
      final map = _userToMap(user);
      await db.update(
        _tableName,
        map,
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } catch (e) {
      print('Ошибка при обновлении пользователя в SQLite: $e');
    }
  }

  /// Найти пользователя по email
  Future<UserAccount?> findUserByEmail(String email) async {
    try {
      final db = await database;
      final maps = await db.query(
        _tableName,
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );
      if (maps.isEmpty) return null;
      return _mapToUser(maps.first);
    } catch (e) {
      print('Ошибка при поиске пользователя по email в SQLite: $e');
      return null;
    }
  }
}
