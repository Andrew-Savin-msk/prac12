import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/account/state/stores/profile_screen/profile_screen_store.dart';
import 'package:prac12/domain/usecases/account/get_current_user_usecase.dart';
import 'package:prac12/domain/usecases/account/logout_usecase.dart';
import 'package:prac12/ui/features/goals/app_router.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key})
      : store = ProfileScreenStore(getIt<GetCurrentUserUseCase>());

  final ProfileScreenStore store;

  void _handleLogout() {
    getIt<LogoutUseCase>()();
    store.loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          Observer(
            builder: (_) {
              if (!store.isLoggedIn) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Выйти',
                onPressed: _handleLogout,
              );
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (!store.isLoggedIn) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Вы не вошли в аккаунт',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Вы можете пользоваться приложением и без аккаунта',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () async {
                        await context.push(Routes.login);
                        store.loadCurrentUser();
                      },
                      child: const Text('Войти'),
                    ),
                  ],
                ),
              ),
            );
          }

          final user = store.user!;
          final initial = user.name.isNotEmpty
              ? user.name[0].toUpperCase()
              : '?';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 32),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: user.avatarUrl != null
                      ? ClipOval(
                          child: Image.network(
                            user.avatarUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Text(
                              initial,
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Text(
                          initial,
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                user.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.email),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                user.email,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () async {
                    await context.push(Routes.editProfile);
                    store.loadCurrentUser();
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Редактировать профиль'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

