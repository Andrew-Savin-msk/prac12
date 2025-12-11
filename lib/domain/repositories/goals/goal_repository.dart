import 'package:prac12/core/models/goals/goal_model.dart';

abstract class GoalRepository {
  List<Goal> getGoals();
  Future<void> addGoal(Goal goal);
  void deleteGoal(int index);
  Future<void> updateGoal(Goal goal);
  Future<String?> getSavedSearchQuery();
  Future<void> saveSearchQuery(String query);
}

