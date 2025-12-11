import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prac12/core/models/goals/goal_model.dart';
import 'package:prac12/ui/features/goals/widgets/goal_card.dart';
import 'package:prac12/ui/features/goals/state/stores/goals_list/goals_list_screen_store.dart';

class GoalsListView extends StatelessWidget {
  final List<Goal> goals;
  final Function(int) onDelete;
  final Function(Goal) onTap;
  final GoalsListScreenStore store;

  const GoalsListView({
    super.key,
    required this.goals,
    required this.onDelete,
    required this.onTap,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return const Center(child: Text('Нет подходящих целей'));
    }

    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];
        return Observer(
          builder: (_) {
            final _ = store.refreshCounter;
        return GoalCard(
          goal: goal,
          onDelete: () => onDelete(index),
          onTap: () => onTap(goal),
            );
          },
        );
      },
    );
  }
}
