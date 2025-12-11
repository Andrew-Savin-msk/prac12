import 'package:mobx/mobx.dart';

import 'package:prac12/core/models/goals/goal_model.dart';
import 'package:prac12/domain/usecases/goals/add_goal_usecase.dart';

class AddGoalScreenStore {
  AddGoalScreenStore(this._addGoalUseCase) {
    _canSave = Computed(() => title.trim().length >= 3 && deadline != null);
  }

  final AddGoalUseCase _addGoalUseCase;

  final Observable<String> _title = Observable('');
  String get title => _title.value;
  set title(String value) => _title.value = value;

  final Observable<DateTime?> _deadline = Observable(null);
  DateTime? get deadline => _deadline.value;
  set deadline(DateTime? value) => _deadline.value = value;

  late final Computed<bool> _canSave;
  bool get canSave => _canSave.value;

  void setTitle(String value) {
    runInAction(() {
      title = value;
    });
  }

  void setDeadline(DateTime value) {
    runInAction(() {
      deadline = value;
    });
  }

  void clear() {
    runInAction(() {
      title = '';
      deadline = null;
    });
  }

  Future<void> createGoal() async {
    if (!canSave) return;

    final goal = Goal(
      title: title.trim(),
      deadline: deadline!,
    );

    await _addGoalUseCase(goal);

    clear();
  }
}
