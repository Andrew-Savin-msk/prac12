import 'package:prac12/core/models/achievements/achievement_model.dart';
import 'package:prac12/core/models/goals/goal_model.dart';

abstract class AchievementRepository {
  List<Achievement> getAchievements();
  void onGoalCreated(List<Goal> allGoals);
  void onGoalUpdated(List<Goal> allGoals);
  void onGoalCompleted(List<Goal> allGoals);
}

