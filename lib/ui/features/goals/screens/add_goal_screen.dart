import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/goals/app_router.dart';
import 'package:prac12/ui/features/goals/state/stores/add_goal/add_goal_screen_store.dart';
import 'package:prac12/domain/usecases/goals/add_goal_usecase.dart';

class AddGoalScreen extends StatelessWidget {
  AddGoalScreen({super.key})
      : store = AddGoalScreenStore(getIt<AddGoalUseCase>()),
        _formKey = GlobalKey<FormState>() {
    store.clear();
  }

  final AddGoalScreenStore store;
  final GlobalKey<FormState> _formKey;

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
      initialDate: store.deadline ?? now,
      helpText: 'Выберите срок выполнения',
      cancelText: 'Отмена',
      confirmText: 'Готово',
    );
    if (picked != null) {
      store.setDeadline(picked);
    }
  }

  Future<void> _save(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (store.deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, выберите срок выполнения'),
        ),
      );
      return;
    }

    await store.createGoal();
    if (context.mounted) {
      context.pop(); // Возвращаемся на предыдущий экран
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая цель'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Form(
        key: _formKey,
        child: Observer(
          builder: (_) {
            final canSave = store.canSave;
            final deadline = store.deadline;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  initialValue: store.title,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Название цели',
                    hintText: 'Например: Выучить основы Dart',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Введите название';
                    }
                    if (v.trim().length < 3) {
                      return 'Минимум 3 символа';
                    }
                    return null;
                  },
                  onChanged: store.setTitle,
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Срок выполнения'),
                  subtitle: Text(
                    deadline == null
                        ? 'Не выбрано'
                        : '${deadline.day.toString().padLeft(2, '0')}.'
                        '${deadline.month.toString().padLeft(2, '0')}.'
                        '${deadline.year}',
                  ),
                  trailing: FilledButton.icon(
                    onPressed: () => _pickDate(context),
                    icon: const Icon(Icons.event),
                    label: const Text('Выбрать дату'),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: canSave ? () async => await _save(context) : null,
                  icon: const Icon(Icons.check),
                  label: const Text('Создать цель'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
