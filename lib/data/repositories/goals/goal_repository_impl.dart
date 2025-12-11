import 'package:prac12/data/datasources/goals/goal_local_datasource.dart';
import 'package:prac12/core/models/goals/goal_model.dart';
import 'package:prac12/domain/repositories/goals/goal_repository.dart';
import 'package:prac12/data/datasources/common/shared_prefs_data_source.dart';
import 'package:prac12/core/constants/shared_prefs_keys.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalLocalDataSource _dataSource;
  final SharedPrefsDataSource _sharedPrefs;

  GoalRepositoryImpl(this._dataSource, this._sharedPrefs);

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

