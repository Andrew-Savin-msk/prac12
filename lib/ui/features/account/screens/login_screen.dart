import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/account/state/stores/login_screen/login_screen_store.dart';
import 'package:prac12/domain/usecases/account/login_usecase.dart';
import 'package:prac12/ui/features/goals/app_router.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key})
      : store = LoginScreenStore(getIt<LoginUseCase>());

  final LoginScreenStore store;

  Future<void> _handleLogin(BuildContext context) async {
    final success = await store.login();
    if (success && context.mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
      ),
      body: Observer(
        builder: (_) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                onSubmitted: (_) {
                  if (store.canLogin) {
                    _handleLogin(context);
                  }
                },
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
                onPressed: store.canLogin
                    ? () => _handleLogin(context)
                    : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Войти'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  await context.push(Routes.register);
                },
                child: const Text('Нет аккаунта? Зарегистрироваться'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

