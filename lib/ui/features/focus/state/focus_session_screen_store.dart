import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:prac12/core/models/focus/focus_session_model.dart';
import 'package:prac12/domain/usecases/focus/get_focus_sessions_usecase.dart';
import 'package:prac12/domain/usecases/focus/add_focus_session_usecase.dart';
import 'package:prac12/domain/usecases/focus/clear_focus_history_usecase.dart';

class FocusSessionScreenStore {
  FocusSessionScreenStore(
    this._getFocusSessionsUseCase,
    this._addFocusSessionUseCase,
    this._clearFocusHistoryUseCase,
  ) {
    _formattedTime = Computed(() {
      final minutes = remainingSeconds ~/ 60;
      final seconds = remainingSeconds % 60;
      final mm = minutes.toString().padLeft(2, '0');
      final ss = seconds.toString().padLeft(2, '0');
      return '$mm:$ss';
    });
    _hasHistory = Computed(() => history.isNotEmpty);
    _canStart = Computed(() => !isRunning);
    _canPause = Computed(() => isRunning && !isPaused);
    _canResume = Computed(() => isRunning && isPaused);
    _canCancel = Computed(() => isRunning);
    _loadHistory();
  }

  final GetFocusSessionsUseCase _getFocusSessionsUseCase;
  final AddFocusSessionUseCase _addFocusSessionUseCase;
  final ClearFocusHistoryUseCase _clearFocusHistoryUseCase;

  Timer? _timer;

  final Observable<int> _plannedDurationMinutes = Observable(25); // дефолт Pomodoro
  int get plannedDurationMinutes => _plannedDurationMinutes.value;
  set plannedDurationMinutes(int value) => _plannedDurationMinutes.value = value;

  final Observable<int> _remainingSeconds = Observable(25 * 60);
  int get remainingSeconds => _remainingSeconds.value;
  set remainingSeconds(int value) => _remainingSeconds.value = value;

  final Observable<bool> _isRunning = Observable(false);
  bool get isRunning => _isRunning.value;
  set isRunning(bool value) => _isRunning.value = value;

  final Observable<bool> _isPaused = Observable(false);
  bool get isPaused => _isPaused.value;
  set isPaused(bool value) => _isPaused.value = value;

  final Observable<DateTime?> _currentStartTime = Observable(null);
  DateTime? get currentStartTime => _currentStartTime.value;
  set currentStartTime(DateTime? value) => _currentStartTime.value = value;

  ObservableList<FocusSession> history = ObservableList.of([]);

  late final Computed<String> _formattedTime;
  String get formattedTime => _formattedTime.value;

  late final Computed<bool> _hasHistory;
  bool get hasHistory => _hasHistory.value;

  late final Computed<bool> _canStart;
  bool get canStart => _canStart.value;

  late final Computed<bool> _canPause;
  bool get canPause => _canPause.value;

  late final Computed<bool> _canResume;
  bool get canResume => _canResume.value;

  late final Computed<bool> _canCancel;
  bool get canCancel => _canCancel.value;

  void setPlannedDurationMinutes(int value) {
    if (!isRunning) {
      runInAction(() {
        plannedDurationMinutes = value;
        remainingSeconds = value * 60;
      });
    }
  }

  void _tick() {
    if (!isRunning || isPaused) return;
    if (remainingSeconds > 0) {
      runInAction(() {
        remainingSeconds--;
      });
    } else {
      _completeSession();
    }
  }

  void startSession() {
    if (isRunning) return;

    runInAction(() {
      currentStartTime = DateTime.now();
      remainingSeconds = plannedDurationMinutes * 60;
      isRunning = true;
      isPaused = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void pauseSession() {
    if (!isRunning) return;
    runInAction(() {
      isPaused = true;
    });
  }

  void resumeSession() {
    if (!isRunning) return;
    runInAction(() {
      isPaused = false;
    });
  }

  void cancelSession() {
    if (!isRunning || currentStartTime == null) {
      _resetState();
      return;
    }

    final endTime = DateTime.now();
    final session = FocusSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: currentStartTime!,
      endTime: endTime,
      plannedDurationMinutes: plannedDurationMinutes,
      completed: false,
    );

    _addFocusSessionUseCase(session);
    _resetState();
    _loadHistory();
  }

  void _completeSession() {
    if (currentStartTime == null) {
      _resetState();
      return;
    }

    final endTime = DateTime.now();
    final session = FocusSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: currentStartTime!,
      endTime: endTime,
      plannedDurationMinutes: plannedDurationMinutes,
      completed: true,
    );

    _addFocusSessionUseCase(session);
    _resetState();
    _loadHistory();
  }

  void clearHistory() {
    _clearFocusHistoryUseCase();
    _loadHistory();
  }

  void _resetState() {
    _timer?.cancel();
    _timer = null;
    runInAction(() {
      isRunning = false;
      isPaused = false;
      currentStartTime = null;
      remainingSeconds = plannedDurationMinutes * 60;
    });
  }

  void _loadHistory() {
    final newSessions = _getFocusSessionsUseCase();
    runInAction(() {
      history
        ..clear()
        ..addAll(newSessions);
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}

