import 'package:mobx/mobx.dart';

import 'package:prac12/core/models/goals/goal_model.dart';
import 'package:prac12/domain/usecases/goals/update_goal_subtasks_usecase.dart';

class GoalDetailScreenStore {
  GoalDetailScreenStore(
    this._updateGoalSubtasksUseCase,
  ) {
    _progress = Computed(() {
      if (subtasks.isEmpty) return 0;
      final done = subtasks.where((s) => s.done).length;
      return (done / subtasks.length) * 100;
    });
  }

  final UpdateGoalSubtasksUseCase _updateGoalSubtasksUseCase;

  final Observable<Goal?> _currentGoal = Observable(null);
  Goal? get currentGoal => _currentGoal.value;
  set currentGoal(Goal? value) => _currentGoal.value = value;

  ObservableList<Subtask> subtasks = ObservableList<Subtask>();

  late final Computed<double> _progress;
  double get progress => _progress.value;

  void attachGoal(Goal goal) {
    runInAction(() {
      currentGoal = goal;
      subtasks = ObservableList<Subtask>.of(goal.subtasks);
    });
  }

  void addSubtask(String title) {
    final text = title.trim();
    if (text.isEmpty) return;

    runInAction(() {
      subtasks.add(Subtask(title: text));
    });
    _syncBackToGoal();
  }

  void toggleSubtask(int index, bool done) {
    if (index < 0 || index >= subtasks.length) return;
    final goal = currentGoal;
    if (goal == null) return;
    final old = subtasks[index];
    final updated = Subtask(title: old.title, done: done);
    runInAction(() {
      subtasks[index] = updated;
    });
    _syncBackToGoal();
  }

  void _syncBackToGoal() {
    final goal = currentGoal;
    if (goal == null) return;

    // Вызываем асинхронно, но не ждём завершения (fire and forget)
    _updateGoalSubtasksUseCase(goal, subtasks.toList());
  }
}
