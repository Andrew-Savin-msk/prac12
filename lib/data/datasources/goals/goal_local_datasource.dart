import 'package:prac12/core/models/goals/goal_model.dart';

class GoalLocalDataSource {
  final List<Goal> _goals = [];

  List<Goal> getGoals() {
    return List.unmodifiable(_goals);
  }

  void addGoal(Goal goal) {
    _goals.add(goal);
  }

  void deleteGoal(int index) {
    if (index >= 0 && index < _goals.length) {
      _goals.removeAt(index);
    }
  }
}

