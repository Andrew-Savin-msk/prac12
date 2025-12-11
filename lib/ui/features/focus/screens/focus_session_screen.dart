import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/focus/state/focus_session_screen_store.dart';
import 'package:prac12/domain/usecases/focus/get_focus_sessions_usecase.dart';
import 'package:prac12/domain/usecases/focus/add_focus_session_usecase.dart';
import 'package:prac12/domain/usecases/focus/clear_focus_history_usecase.dart';

class FocusSessionScreen extends StatelessWidget {
  FocusSessionScreen({super.key})
      : store = FocusSessionScreenStore(
          getIt<GetFocusSessionsUseCase>(),
          getIt<AddFocusSessionUseCase>(),
          getIt<ClearFocusHistoryUseCase>(),
        );

  final FocusSessionScreenStore store;

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фокус-сессии'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Блок таймера
            Observer(
              builder: (_) => Column(
                children: [
                  Text(
                    store.formattedTime,
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Выбор длительности (только когда таймер не запущен)
                  if (store.canStart)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Длительность: '),
                        DropdownButton<int>(
                          value: store.plannedDurationMinutes,
                          items: [15, 20, 25, 30, 45, 60]
                              .map((minutes) => DropdownMenuItem(
                                    value: minutes,
                                    child: Text('$minutes мин'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              store.setPlannedDurationMinutes(value);
                            }
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Кнопки управления
            Observer(
              builder: (_) => Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    onPressed: store.canStart ? store.startSession : null,
                    child: const Text('Старт'),
                  ),
                  ElevatedButton(
                    onPressed: store.canPause ? store.pauseSession : null,
                    child: const Text('Пауза'),
                  ),
                  ElevatedButton(
                    onPressed: store.canResume ? store.resumeSession : null,
                    child: const Text('Продолжить'),
                  ),
                  OutlinedButton(
                    onPressed: store.canCancel ? store.cancelSession : null,
                    child: const Text('Сброс'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Заголовок "История"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'История сессий',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Observer(
                  builder: (_) => IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: store.hasHistory ? store.clearHistory : null,
                    tooltip: 'Очистить историю',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // История
            Expanded(
              child: Observer(
                builder: (_) {
                  if (!store.hasHistory) {
                    return const Center(
                      child: Text(
                        'История пуста. Запустите первую фокус-сессию.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: store.history.length,
                    itemBuilder: (context, index) {
                      final session = store.history[index];
                      final start = session.startTime;
                      final durationMinutes = session.actualDuration.inMinutes;

                      final dateString = _formatDateTime(start);

                      final statusText =
                          session.completed ? 'Завершена' : 'Прервана';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text('$statusText • $durationMinutes мин'),
                          subtitle: Text('Начало: $dateString'),
                          trailing: session.completed
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green)
                              : const Icon(Icons.cancel, color: Colors.orange),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

