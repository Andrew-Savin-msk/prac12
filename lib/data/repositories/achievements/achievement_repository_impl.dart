import 'package:prac12/data/datasources/achievements/achievement_local_datasource.dart';
import 'package:prac12/data/datasources/activity_log/activity_log_local_datasource.dart';
import 'package:prac12/core/models/achievements/achievement_model.dart';
import 'package:prac12/core/models/activity_log/log_entry_model.dart';
import 'package:prac12/core/models/goals/goal_model.dart';
import 'package:prac12/domain/repositories/achievements/achievement_repository.dart';

class AchievementRepositoryImpl implements AchievementRepository {
  final AchievementLocalDataSource _dataSource;
  final ActivityLogLocalDataSource _logDataSource;

  AchievementRepositoryImpl(
    this._dataSource,
    this._logDataSource,
  );

  @override
  List<Achievement> getAchievements() {
    return _dataSource.getAchievements();
  }

  @override
  void onGoalCreated(List<Goal> allGoals) {
    _unlockIf('first_goal', () => allGoals.isNotEmpty);
    _unlockIf('five_goals', () => allGoals.length >= 5);
  }

  @override
  void onGoalUpdated(List<Goal> allGoals) {
    final hasPerfectGoal = allGoals.any((g) => g.progress >= 100);
    _unlockIf('perfect_goal', () => hasPerfectGoal);
  }

  @override
  void onGoalCompleted(List<Goal> allGoals) {
    final completedCount = allGoals.where((g) => g.isCompleted).length;
    _unlockIf('first_completed_goal', () => completedCount >= 1);
    _unlockIf('three_completed_goals', () => completedCount >= 3);
  }

  void _unlockIf(String id, bool Function() condition) {
    if (!_dataSource.isAchievementUnlocked(id) && condition()) {
      _dataSource.unlockAchievement(id);
      final achievements = _dataSource.getAchievements();
      final achievement = achievements.firstWhere((a) => a.id == id);
      _logDataSource.addEntry(
        LogEntry(
          timestamp: DateTime.now(),
          type: 'achievement_unlocked',
          title: 'Открыта ачивка',
          description: 'Ачивка: "${achievement.title}"',
        ),
      );
    }
  }
}

