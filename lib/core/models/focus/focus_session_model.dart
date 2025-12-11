class FocusSession {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int plannedDurationMinutes;
  final bool completed;

  FocusSession({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.plannedDurationMinutes,
    required this.completed,
  });

  Duration get actualDuration => endTime.difference(startTime);
}

