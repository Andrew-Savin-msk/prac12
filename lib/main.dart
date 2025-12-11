import 'package:flutter/material.dart';
import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/goals/app_router.dart';
import 'package:prac12/domain/repositories/goals/goal_repository.dart';
import 'package:prac12/data/repositories/goals/goal_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencyInjection();
  
  // Инициализируем репозиторий целей: загружаем данные из SQLite
  final goalRepository = getIt<GoalRepository>() as GoalRepositoryImpl;
  await goalRepository.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = buildRouter();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Goals',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      routerConfig: router,
    );
  }
}

