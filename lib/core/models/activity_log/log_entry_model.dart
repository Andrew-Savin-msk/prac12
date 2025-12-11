class LogEntry {
  final DateTime timestamp;
  final String type;
  final String title;
  final String? description;

  LogEntry({
    required this.timestamp,
    required this.type,
    required this.title,
    this.description,
  });
}

