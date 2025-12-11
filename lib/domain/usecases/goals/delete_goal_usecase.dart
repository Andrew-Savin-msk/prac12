import 'package:prac12/domain/repositories/goals/goal_repository.dart';
import 'package:prac12/domain/repositories/activity_log/activity_log_repository.dart';

class DeleteGoalUseCase {
  final GoalRepository _goalRepository;
  final ActivityLogRepository _activityLogRepository;

  DeleteGoalUseCase(
    this._goalRepository,
    this._activityLogRepository,
  );

  void call(int index) {
    final goals = _goalRepository.getGoals();
    if (index >= 0 && index < goals.length) {
      final goalTitle = goals[index].title;
      _goalRepository.deleteGoal(index);
      _activityLogRepository.logGoalDeleted(goalTitle);
    }
  }
}

