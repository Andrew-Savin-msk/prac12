import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/goals/widgets/progress_text.dart';
import 'package:prac12/ui/features/goals/state/stores/goals_list/goals_list_screen_store.dart';
import 'package:prac12/domain/usecases/goals/get_goals_usecase.dart';

class GoalsStatsCard extends StatelessWidget {
  final GoalsListScreenStore store;

  const GoalsStatsCard({super.key, required this.store});

  double _averageProgress() {
    final goals = getIt<GetGoalsUseCase>()();
    if (goals.isEmpty) return 0;
    return goals.map((g) => g.progress).reduce((a, b) => a + b) / goals.length;
  }

  int _completedCount() => getIt<GetGoalsUseCase>()().where((g) => g.isCompleted).length;

  int _totalCount() => getIt<GetGoalsUseCase>()().length;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final _ = store.refreshCounter;
        final totalCount = _totalCount();
        final completedCount = _completedCount();
        final averageProgress = _averageProgress();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(children: [
              Text(
                    '$totalCount',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Text('Всего целей'),
            ]),
            Column(children: [
              Text(
                    '$completedCount',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Text('Выполнено'),
            ]),
            Column(children: [
                  ProgressText(progress: averageProgress),
            ]),
          ],
        ),
      ),
        );
      },
    );
  }
}
