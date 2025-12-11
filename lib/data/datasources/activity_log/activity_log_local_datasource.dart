import 'package:prac12/core/models/activity_log/log_entry_model.dart';

class ActivityLogLocalDataSource {
  final List<LogEntry> _entries = [];

  List<LogEntry> getEntries() {
    return List.unmodifiable(_entries);
  }

  void addEntry(LogEntry entry) {
    _entries.insert(0, entry);
  }

  void clear() {
    _entries.clear();
  }
}

