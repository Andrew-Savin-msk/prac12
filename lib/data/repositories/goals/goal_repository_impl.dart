import 'package:prac12/data/datasources/goals/goal_local_datasource.dart';
import 'package:prac12/core/models/goals/goal_model.dart';
import 'package:prac12/domain/repositories/goals/goal_repository.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalLocalDataSource _dataSource;

  GoalRepositoryImpl(this._dataSource);

  @override
  List<Goal> getGoals() {
    return _dataSource.getGoals();
  }

  @override
  void addGoal(Goal goal) {
    _dataSource.addGoal(goal);
  }

  @override
  void deleteGoal(int index) {
    _dataSource.deleteGoal(index);
  }
}

