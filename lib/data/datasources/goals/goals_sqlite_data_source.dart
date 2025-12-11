// Data-слой: обёртка над SQLite для работы с целями (Goals)
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:prac12/core/models/goals/goal_model.dart';

/// Data source для работы с целями в SQLite базе данных
class GoalsSqliteDataSource {
  static const String _databaseName = 'goals.db';
  static const int _databaseVersion = 1;
  static const String _tableName = 'goals';

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
        title TEXT NOT NULL,
        deadline INTEGER NOT NULL,
        subtasks TEXT NOT NULL
      )
    ''');
  }

  /// Преобразование Goal в Map для SQLite
  Map<String, Object?> _goalToMap(Goal goal) {
    final subtasksJson = jsonEncode(
      goal.subtasks.map((s) => {
        'title': s.title,
        'done': s.done,
      }).toList(),
    );

    return {
      'id': goal.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'title': goal.title,
      'deadline': goal.deadline.millisecondsSinceEpoch,
      'subtasks': subtasksJson,
    };
  }

  /// Преобразование Map из SQLite в Goal
  Goal _mapToGoal(Map<String, Object?> map) {
    final subtasksJson = jsonDecode(map['subtasks'] as String) as List;
    final subtasks = subtasksJson
        .map((s) => Subtask(
              title: s['title'] as String,
              done: s['done'] as bool? ?? false,
            ))
        .toList();

    return Goal(
      id: map['id'] as String?,
      title: map['title'] as String,
      deadline: DateTime.fromMillisecondsSinceEpoch(map['deadline'] as int),
      subtasks: subtasks,
    );
  }

  /// Получить все цели из базы данных
  Future<List<Goal>> getGoalsFromDb() async {
    try {
      final db = await database;
      final maps = await db.query(
        _tableName,
        orderBy: 'deadline ASC',
      );
      return maps.map((map) => _mapToGoal(map)).toList();
    } catch (e) {
      print('Ошибка при чтении целей из SQLite: $e');
      return [];
    }
  }

  /// Вставить цель в базу данных
  Future<void> insertGoalToDb(Goal goal) async {
    try {
      final db = await database;
      final map = _goalToMap(goal);
      await db.insert(
        _tableName,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Ошибка при вставке цели в SQLite: $e');
    }
  }

  /// Обновить цель в базе данных
  Future<void> updateGoalInDb(Goal goal) async {
    if (goal.id == null) {
      print('Ошибка: нельзя обновить цель без id');
      return;
    }
    try {
      final db = await database;
      final map = _goalToMap(goal);
      await db.update(
        _tableName,
        map,
        where: 'id = ?',
        whereArgs: [goal.id],
      );
    } catch (e) {
      print('Ошибка при обновлении цели в SQLite: $e');
    }
  }

  /// Удалить цель из базы данных по id
  Future<void> deleteGoalFromDb(String id) async {
    try {
      final db = await database;
      await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Ошибка при удалении цели из SQLite: $e');
    }
  }

  /// Очистить все цели из базы данных
  Future<void> clearAllGoals() async {
    try {
      final db = await database;
      await db.delete(_tableName);
    } catch (e) {
      print('Ошибка при очистке целей из SQLite: $e');
    }
  }
}
