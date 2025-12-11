import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/activity_log/state/activity_log_screen_store.dart';
import 'package:prac12/domain/usecases/activity_log/get_activity_log_usecase.dart';
import 'package:prac12/domain/usecases/activity_log/clear_activity_log_usecase.dart';

class ActivityLogScreen extends StatelessWidget {
  ActivityLogScreen({super.key})
      : store = ActivityLogScreenStore(
          getIt<GetActivityLogUseCase>(),
          getIt<ClearActivityLogUseCase>(),
        ) {
    // Обновляем список при создании экрана
    store.refresh();
  }

  final ActivityLogScreenStore store;

  String _formatDateTime(DateTime dateTime) {
    final time = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    final date = '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
    return '$time, $date';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Журнал действий'),
        actions: [
          Observer(
            builder: (_) {
              if (!store.hasEntries) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Очистить',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Очистить журнал?'),
                      content: const Text('Вы уверены, что хотите очистить весь журнал действий?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Отмена'),
                        ),
                        FilledButton(
                          onPressed: () {
                            store.clear();
                            Navigator.pop(ctx);
                          },
                          child: const Text('Очистить'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (!store.hasEntries) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Журнал пуст. Действия появятся здесь по мере работы в приложении.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: store.entries.length,
            itemBuilder: (context, index) {
              final entry = store.entries[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    entry.title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        _formatDateTime(entry.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (entry.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          entry.description!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

