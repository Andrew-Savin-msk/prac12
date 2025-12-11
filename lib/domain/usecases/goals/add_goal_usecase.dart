import 'package:prac12/core/models/goals/goal_model.dart';
import 'package:prac12/domain/repositories/goals/goal_repository.dart';
import 'package:prac12/domain/repositories/achievements/achievement_repository.dart';
import 'package:prac12/domain/repositories/activity_log/activity_log_repository.dart';

class AddGoalUseCase {
  final GoalRepository _goalRepository;
  final AchievementRepository _achievementRepository;
  final ActivityLogRepository _activityLogRepository;

  AddGoalUseCase(
    this._goalRepository,
    this._achievementRepository,
    this._activityLogRepository,
  );

  void call(Goal goal) {
    _goalRepository.addGoal(goal);
    final allGoals = _goalRepository.getGoals();
    _achievementRepository.onGoalCreated(allGoals);
    _achievementRepository.onGoalUpdated(allGoals);
    _activityLogRepository.logGoalCreated(goal.title);
  }
}

