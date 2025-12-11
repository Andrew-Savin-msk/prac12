import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/account/state/stores/registration/registration_screen_store.dart';
import 'package:prac12/domain/usecases/account/register_usecase.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key})
      : store = RegistrationScreenStore(getIt<RegisterUseCase>());

  final RegistrationScreenStore store;

  Future<void> _handleRegister(BuildContext context) async {
    final success = await store.register();
    if (success && context.mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
      body: Observer(
        builder: (_) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Имя',
                  border: OutlineInputBorder(),
                ),
                onChanged: store.setName,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: store.setEmail,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onChanged: store.setPassword,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Подтвердите пароль',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onChanged: store.setConfirmPassword,
                onSubmitted: (_) {
                  if (store.canRegister) {
                    _handleRegister(context);
                  }
                },
              ),
              if (store.password.isNotEmpty &&
                  store.confirmPassword.isNotEmpty &&
                  store.password != store.confirmPassword) ...[
                const SizedBox(height: 8),
                Text(
                  'Пароли не совпадают',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ],
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
                onPressed: store.canRegister
                    ? () => _handleRegister(context)
                    : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Зарегистрироваться'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

