import 'package:prac12/data/datasources/goals/goal_local_datasource.dart';
import 'package:prac12/data/datasources/goals/goals_sqlite_data_source.dart';
import 'package:prac12/core/models/goals/goal_model.dart';
import 'package:prac12/domain/repositories/goals/goal_repository.dart';
import 'package:prac12/data/datasources/common/shared_prefs_data_source.dart';
import 'package:prac12/core/constants/shared_prefs_keys.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalLocalDataSource _dataSource;
  final GoalsSqliteDataSource _sqliteDataSource;
  final SharedPrefsDataSource _sharedPrefs;
  List<Goal>? _cachedGoals;

  GoalRepositoryImpl(
    this._dataSource,
    this._sqliteDataSource,
    this._sharedPrefs,
  );

  @override
  List<Goal> getGoals() {
    // Возвращаем кешированные цели (загружаются при инициализации)
    return _cachedGoals ?? [];
  }

  /// Загрузить цели из SQLite (асинхронно)
  Future<void> _loadGoalsFromSqlite() async {
    try {
      final goals = await _sqliteDataSource.getGoalsFromDb();
      _cachedGoals = goals;
    } catch (e) {
      print('Ошибка при загрузке целей из SQLite: $e');
      _cachedGoals = [];
    }
  }

  /// Инициализация: загрузить цели из SQLite при старте
  Future<void> initialize() async {
    await _loadGoalsFromSqlite();
  }

  @override
  Future<void> addGoal(Goal goal) async {
    // Генерируем id, если его нет
    if (goal.id == null) {
      goal.id = DateTime.now().millisecondsSinceEpoch.toString();
    }

    // Сохраняем в SQLite
    await _sqliteDataSource.insertGoalToDb(goal);

    // Обновляем кеш
    _cachedGoals ??= [];
    _cachedGoals!.add(goal);
    
    // Также сохраняем в старый data source для обратной совместимости
    _dataSource.addGoal(goal);
  }

  @override
  void deleteGoal(int index) {
    final goals = getGoals();
    if (index >= 0 && index < goals.length) {
      final goal = goals[index];
      
      // Удаляем из SQLite по id (асинхронно, но не ждём)
      if (goal.id != null) {
        _sqliteDataSource.deleteGoalFromDb(goal.id!);
      }

      // Обновляем кеш
      _cachedGoals?.removeAt(index);
      
      // Также удаляем из старого data source
      _dataSource.deleteGoal(index);
    }
  }

  @override
  Future<void> updateGoal(Goal goal) async {
    if (goal.id == null) {
      print('Ошибка: нельзя обновить цель без id');
      return;
    }

    // Обновляем в SQLite
    await _sqliteDataSource.updateGoalInDb(goal);

    // Обновляем в кеше
    if (_cachedGoals != null) {
      final index = _cachedGoals!.indexWhere((g) => g.id == goal.id);
      if (index != -1) {
        _cachedGoals![index] = goal;
      }
    }
  }

  @override
  Future<String?> getSavedSearchQuery() async {
    return await _sharedPrefs.getString(SharedPrefsKeys.goalsSearchQuery);
  }

  @override
  Future<void> saveSearchQuery(String query) async {
    if (query.isEmpty) {
      await _sharedPrefs.remove(SharedPrefsKeys.goalsSearchQuery);
    } else {
      await _sharedPrefs.setString(SharedPrefsKeys.goalsSearchQuery, query);
    }
  }
}

