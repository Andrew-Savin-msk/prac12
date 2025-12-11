import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/account/state/stores/edit_profile/edit_profile_screen_store.dart';
import 'package:prac12/domain/usecases/account/get_current_user_usecase.dart';
import 'package:prac12/domain/usecases/account/update_profile_usecase.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key})
      : store = EditProfileScreenStore(
          getIt<GetCurrentUserUseCase>(),
          getIt<UpdateProfileUseCase>(),
        );

  final EditProfileScreenStore store;

  Future<void> _handleSave(BuildContext context) async {
    final success = await store.save();
    if (success && context.mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование профиля'),
      ),
      body: Observer(
        builder: (_) {
          final nameController = TextEditingController(text: store.name);
          final emailController = TextEditingController(text: store.email);
          final avatarController = TextEditingController(text: store.avatarUrl ?? '');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Имя',
                    border: OutlineInputBorder(),
                  ),
                  controller: nameController,
                  onChanged: store.setName,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  onChanged: store.setEmail,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'URL аватара (опционально)',
                    border: OutlineInputBorder(),
                    helperText: 'Введите URL изображения',
                  ),
                  keyboardType: TextInputType.url,
                  controller: avatarController,
                  onChanged: (value) => store.setAvatarUrl(value.isEmpty ? null : value),
                ),
                if (store.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    store.errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: store.canSave
                      ? () => _handleSave(context)
                      : null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Сохранить'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

