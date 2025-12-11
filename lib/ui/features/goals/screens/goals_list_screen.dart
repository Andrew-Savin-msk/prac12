import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/goals/app_router.dart';
import 'package:prac12/ui/features/goals/widgets/goals_stats_card.dart';
import 'package:prac12/ui/features/goals/widgets/goals_search_bar.dart';
import 'package:prac12/ui/features/goals/widgets/goals_list_view.dart';
import 'package:prac12/ui/features/goals/state/stores/goals_list/goals_list_screen_store.dart';
import 'package:prac12/domain/usecases/goals/get_goals_usecase.dart';
import 'package:prac12/domain/usecases/goals/delete_goal_usecase.dart';


class GoalsListScreen extends StatelessWidget {
  GoalsListScreen({super.key})
      : store = GoalsListScreenStore(
          getIt<GetGoalsUseCase>(),
          getIt<DeleteGoalUseCase>(),
        ),
        _searchController = TextEditingController() {
    store.setSearchQuery('');
    store.refresh();
  }

  final GoalsListScreenStore store;
  final TextEditingController _searchController;

  void _deleteGoal(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить цель?'),
        content: const Text('Вы уверены, что хотите удалить эту цель?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              store.deleteByFilteredIndex(index);
              Navigator.pop(ctx);
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Менеджер целей'),
        actions: [
          IconButton(
            tooltip: 'Поддержка',
            icon: const Icon(Icons.help_outline),
            onPressed: () => context.push(Routes.support),
          ),
          IconButton(
            tooltip: 'Советы и статьи',
            icon: const Icon(Icons.menu_book),
            onPressed: () => context.push(Routes.tips),
          ),
          IconButton(
            tooltip: 'Фокус-сессии',
            icon: const Icon(Icons.timer),
            onPressed: () => context.push(Routes.focusSessions),
          ),
          IconButton(
            tooltip: 'Журнал действий',
            icon: const Icon(Icons.history),
            onPressed: () => context.push(Routes.activityLog),
          ),
          IconButton(
            tooltip: 'Выполненные',
            icon: const Icon(Icons.done_all),
            onPressed: () => context.push(Routes.completed),
          ),
          IconButton(
            tooltip: 'Ачивки',
            icon: const Icon(Icons.emoji_events),
            onPressed: () => context.push(Routes.achievements),
          ),
          IconButton(
            tooltip: 'Профиль',
            icon: const Icon(Icons.person),
            onPressed: () => context.push(Routes.profile),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Observer(
          builder: (_) {
            final goals = store.goals;

            return Column(
              children: [
                GoalsStatsCard(store: store),
                GoalsSearchBar(
                  controller: _searchController,
                  onChanged: () {
                    store.setSearchQuery(_searchController.text);
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: goals.isEmpty
                      ? const Center(child: Text('Целей пока нет'))
                      : GoalsListView(
                    goals: goals,
                    store: store,
                    onDelete: (index) => _deleteGoal(context, index),
                    onTap: (goal) async {
                      await context.push(
                        Routes.goalDetail,
                        extra: goal,
                      );
                      store.refresh();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.addGoal),
        label: const Text('Новая цель'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
