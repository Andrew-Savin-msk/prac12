import 'package:mobx/mobx.dart';

import 'package:prac12/core/models/goals/goal_model.dart';
import 'package:prac12/domain/usecases/goals/get_goals_usecase.dart';
import 'package:prac12/domain/usecases/goals/delete_goal_usecase.dart';
import 'package:prac12/domain/usecases/goals/get_saved_search_query_usecase.dart';
import 'package:prac12/domain/usecases/goals/save_search_query_usecase.dart';

class GoalsListScreenStore {
  GoalsListScreenStore(
    this._getGoalsUseCase,
    this._deleteGoalUseCase,
    this._getSavedSearchQueryUseCase,
    this._saveSearchQueryUseCase,
  ) {
    _hasGoals = Computed(() => goals.isNotEmpty);
    _loadSavedSearchQuery();
  }

  final GetGoalsUseCase _getGoalsUseCase;
  final DeleteGoalUseCase _deleteGoalUseCase;
  final GetSavedSearchQueryUseCase _getSavedSearchQueryUseCase;
  final SaveSearchQueryUseCase _saveSearchQueryUseCase;

  final Observable<String> _searchQuery = Observable('');
  String get searchQuery => _searchQuery.value;
  set searchQuery(String value) => _searchQuery.value = value;

  ObservableList<Goal> goals = ObservableList<Goal>();

  final Observable<int> _refreshCounter = Observable(0);
  int get refreshCounter => _refreshCounter.value;
  set refreshCounter(int value) => _refreshCounter.value = value;

  late final Computed<bool> _hasGoals;
  bool get hasGoals => _hasGoals.value;

  void setSearchQuery(String value) {
    runInAction(() {
      searchQuery = value;
    });
    _applyFilter();
    // Сохраняем поисковый запрос в SharedPreferences
    _saveSearchQueryUseCase(value);
  }

  /// Загрузить сохранённый поисковый запрос при инициализации
  Future<void> _loadSavedSearchQuery() async {
    final savedQuery = await _getSavedSearchQueryUseCase();
    if (savedQuery != null && savedQuery.isNotEmpty) {
      runInAction(() {
        searchQuery = savedQuery;
      });
    }
    refresh();
  }

  void refresh() {
    _applyFilter();
  }

  void _applyFilter() {
    final all = _getGoalsUseCase();
    final q = _searchQuery.value.toLowerCase();

    final filtered = q.isEmpty
        ? all
        : all.where((g) => g.title.toLowerCase().contains(q)).toList();

    runInAction(() {
      goals
        ..clear()
        ..addAll(filtered);
      refreshCounter++;
    });
  }

  void deleteByFilteredIndex(int index) {
    if (index < 0 || index >= goals.length) return;

    final goal = goals[index];
    final all = _getGoalsUseCase();
    final originalIndex = all.indexOf(goal);

    if (originalIndex != -1) {
      _deleteGoalUseCase(originalIndex);
    }

    _applyFilter();
  }
}
