import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/goals/app_router.dart';
import 'package:prac12/ui/features/goals/widgets/goal_card.dart';
import 'package:prac12/ui/features/goals/state/stores/completed_goals/completed_goals_screen_store.dart';
import 'package:prac12/domain/usecases/goals/get_goals_usecase.dart';
import 'package:prac12/domain/usecases/goals/delete_goal_usecase.dart';

class CompletedGoalsScreen extends StatelessWidget {
  CompletedGoalsScreen({super.key})
      : store = CompletedGoalsScreenStore(
          getIt<GetGoalsUseCase>(),
          getIt<DeleteGoalUseCase>(),
        );

  final CompletedGoalsScreenStore store;

  Future<void> _deleteAllCompleted(BuildContext context) async {
    final count = store.completedCount;
    if (count == 0) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить выполненные цели?'),
        content: Text(
          'Будут удалены $count выполненных целей. Действие необратимо.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (ok == true) {
      store.deleteAllCompleted();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Удалено целей: $count')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выполненные цели'),
        leading: BackButton(onPressed: () => context.pop()),
        actions: [
          Observer(
            builder: (_) => IconButton(
              tooltip: 'Удалить все',
              onPressed:
              store.hasCompleted ? () => _deleteAllCompleted(context) : null,
              icon: const Icon(Icons.delete_sweep),
            ),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          final entries = store.completedGoals;

          if (entries.isEmpty) {
            return const _EmptyCompletedState();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final entry = entries[i];
              final goal = entry.goal;
              final originalIndex = entry.originalIndex;

              return GoalCard(
                goal: goal,
                onDelete: () => store.deleteByOriginalIndex(originalIndex),
                onTap: () async {
                  await context.push(
                    Routes.goalDetail,
                    extra: goal,
                  );
                  store.refresh();
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyCompletedState extends StatelessWidget {
  const _EmptyCompletedState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 64),
            const SizedBox(height: 12),
            const Text(
              'Нет выполненных целей',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Отметьте все подзадачи внутри цели, и она попадёт сюда автоматически',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
