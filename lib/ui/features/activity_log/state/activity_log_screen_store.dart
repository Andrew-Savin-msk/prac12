import 'package:mobx/mobx.dart';
import 'package:prac12/core/models/activity_log/log_entry_model.dart';
import 'package:prac12/domain/usecases/activity_log/get_activity_log_usecase.dart';
import 'package:prac12/domain/usecases/activity_log/clear_activity_log_usecase.dart';

class ActivityLogScreenStore {
  ActivityLogScreenStore(
    this._getActivityLogUseCase,
    this._clearActivityLogUseCase,
  ) {
    _hasEntries = Computed(() => entries.isNotEmpty);
    refresh();
  }

  final GetActivityLogUseCase _getActivityLogUseCase;
  final ClearActivityLogUseCase _clearActivityLogUseCase;

  ObservableList<LogEntry> entries = ObservableList.of([]);

  late final Computed<bool> _hasEntries;
  bool get hasEntries => _hasEntries.value;

  void refresh() {
    final newEntries = _getActivityLogUseCase();
    runInAction(() {
      entries
        ..clear()
        ..addAll(newEntries);
    });
  }

  void clear() {
    _clearActivityLogUseCase();
    refresh();
  }
}

