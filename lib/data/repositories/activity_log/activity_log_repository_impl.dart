import 'package:prac12/data/datasources/activity_log/activity_log_local_datasource.dart';
import 'package:prac12/core/models/activity_log/log_entry_model.dart';
import 'package:prac12/domain/repositories/activity_log/activity_log_repository.dart';

class ActivityLogRepositoryImpl implements ActivityLogRepository {
  final ActivityLogLocalDataSource _dataSource;

  ActivityLogRepositoryImpl(this._dataSource);

  @override
  List<LogEntry> getEntries() {
    return _dataSource.getEntries();
  }

  @override
  void log({
    required String type,
    required String title,
    String? description,
    DateTime? timestamp,
  }) {
    final entry = LogEntry(
      timestamp: timestamp ?? DateTime.now(),
      type: type,
      title: title,
      description: description,
    );
    _dataSource.addEntry(entry);
  }

  @override
  void clear() {
    _dataSource.clear();
  }

  @override
  void logGoalCreated(String goalTitle) {
    log(
      type: 'goal_created',
      title: 'Создана цель',
      description: 'Цель: "$goalTitle"',
    );
  }

  @override
  void logGoalDeleted(String goalTitle) {
    log(
      type: 'goal_deleted',
      title: 'Удалена цель',
      description: 'Цель: "$goalTitle"',
    );
  }

  @override
  void logGoalCompleted(String goalTitle) {
    log(
      type: 'goal_completed',
      title: 'Завершена цель',
      description: 'Цель: "$goalTitle"',
    );
  }

  @override
  void logAuthLogin(String email) {
    log(
      type: 'auth_login',
      title: 'Вход в аккаунт',
      description: 'Email: $email',
    );
  }

  @override
  void logAuthLogout() {
    log(
      type: 'auth_logout',
      title: 'Выход из аккаунта',
      description: null,
    );
  }

  @override
  void logProfileUpdated(String name, String email) {
    log(
      type: 'profile_updated',
      title: 'Профиль обновлён',
      description: 'Имя: $name, Email: $email',
    );
  }

  @override
  void logAchievementUnlocked(String achievementTitle) {
    log(
      type: 'achievement_unlocked',
      title: 'Открыта ачивка',
      description: 'Ачивка: "$achievementTitle"',
    );
  }
}

