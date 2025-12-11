import 'package:prac12/core/models/goals/goal_model.dart';
import 'package:prac12/domain/repositories/goals/goal_repository.dart';
import 'package:prac12/domain/repositories/achievements/achievement_repository.dart';
import 'package:prac12/domain/repositories/activity_log/activity_log_repository.dart';

class UpdateGoalSubtasksUseCase {
  final GoalRepository _goalRepository;
  final AchievementRepository _achievementRepository;
  final ActivityLogRepository _activityLogRepository;

  UpdateGoalSubtasksUseCase(
    this._goalRepository,
    this._achievementRepository,
    this._activityLogRepository,
  );

  void call(Goal goal, List<Subtask> subtasks) {
    goal.subtasks = subtasks;
    final allGoals = _goalRepository.getGoals();
    final goalIndex = allGoals.indexOf(goal);
    if (goalIndex != -1) {
      allGoals[goalIndex].subtasks = List<Subtask>.from(subtasks);
    }
    
    final wasCompleted = goal.isCompleted;
    _achievementRepository.onGoalUpdated(allGoals);
    
    if (wasCompleted) {
      _achievementRepository.onGoalCompleted(allGoals);
      _activityLogRepository.logGoalCompleted(goal.title);
    }
  }
}

