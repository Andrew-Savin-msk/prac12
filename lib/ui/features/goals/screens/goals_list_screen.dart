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
import 'package:prac12/domain/usecases/goals/get_saved_search_query_usecase.dart';
import 'package:prac12/domain/usecases/goals/save_search_query_usecase.dart';


class GoalsListScreen extends StatefulWidget {
  const GoalsListScreen({super.key});

  @override
  State<GoalsListScreen> createState() => _GoalsListScreenState();
}

class _GoalsListScreenState extends State<GoalsListScreen> {
  late final GoalsListScreenStore store;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    store = GoalsListScreenStore(
      getIt<GetGoalsUseCase>(),
      getIt<DeleteGoalUseCase>(),
      getIt<GetSavedSearchQueryUseCase>(),
      getIt<SaveSearchQueryUseCase>(),
    );
    // Синхронизируем контроллер с сохранённым значением после загрузки
    _syncControllerWithStore();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Обновляем список при возврате на экран
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        store.refresh();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _syncControllerWithStore() async {
    // Ждём, чтобы store успел загрузить данные асинхронно
    await Future.delayed(const Duration(milliseconds: 50));
    if (mounted && store.searchQuery.isNotEmpty) {
      _searchController.text = store.searchQuery;
    }
  }


  void _deleteGoal(int index) {
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
            onPressed: () async {
              await context.push(Routes.completed);
              // Обновляем список после возврата с экрана выполненных целей
              if (mounted) {
                store.refresh();
              }
            },
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
                    onDelete: (index) => _deleteGoal(index),
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
        onPressed: () async {
          await context.push(Routes.addGoal);
          // Обновляем список после возврата с экрана добавления цели
          if (mounted) {
            store.refresh();
          }
        },
        label: const Text('Новая цель'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
