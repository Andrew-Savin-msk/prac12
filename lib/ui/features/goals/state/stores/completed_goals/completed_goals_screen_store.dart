import 'package:mobx/mobx.dart';

import 'package:prac12/core/models/goals/goal_model.dart';
import 'package:prac12/domain/usecases/goals/get_goals_usecase.dart';
import 'package:prac12/domain/usecases/goals/delete_goal_usecase.dart';

class CompletedGoalEntry {
  final int originalIndex;
  final Goal goal;

  CompletedGoalEntry(this.originalIndex, this.goal);
}

class CompletedGoalsScreenStore {
  CompletedGoalsScreenStore(
    this._getGoalsUseCase,
    this._deleteGoalUseCase,
  ) {
    _hasCompleted = Computed(() => completedGoals.isNotEmpty);
    _completedCount = Computed(() => completedGoals.length);
    refresh();
  }

  final GetGoalsUseCase _getGoalsUseCase;
  final DeleteGoalUseCase _deleteGoalUseCase;

  ObservableList<CompletedGoalEntry> completedGoals =
      ObservableList<CompletedGoalEntry>();

  late final Computed<bool> _hasCompleted;
  bool get hasCompleted => _hasCompleted.value;

  late final Computed<int> _completedCount;
  int get completedCount => _completedCount.value;

  void refresh() {
    final all = _getGoalsUseCase();
    final list = all
        .asMap()
        .entries
        .where((e) => e.value.isCompleted)
        .map((e) => CompletedGoalEntry(e.key, e.value))
        .toList();

    runInAction(() {
      completedGoals
        ..clear()
        ..addAll(list);
    });
  }

  void deleteAllCompleted() {
    final all = _getGoalsUseCase();
    final indicesToDelete = all
        .asMap()
        .entries
        .where((e) => e.value.isCompleted)
        .map((e) => e.key)
        .toList()
      ..sort((a, b) => b.compareTo(a)); // Delete from end to start

    for (final index in indicesToDelete) {
      _deleteGoalUseCase(index);
    }
    refresh();
  }

  void deleteByOriginalIndex(int originalIndex) {
    final all = _getGoalsUseCase();
    if (originalIndex < 0 || originalIndex >= all.length) {
      return;
    }
    _deleteGoalUseCase(originalIndex);
    refresh();
  }
}
