import 'package:prac12/domain/repositories/goals/goal_repository.dart';

/// Use case для сохранения поискового запроса
class SaveSearchQueryUseCase {
  final GoalRepository _repository;

  SaveSearchQueryUseCase(this._repository);

  Future<void> call(String query) async {
    await _repository.saveSearchQuery(query);
  }
}
