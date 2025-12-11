import 'package:prac12/domain/repositories/goals/goal_repository.dart';

/// Use case для получения сохранённого поискового запроса
class GetSavedSearchQueryUseCase {
  final GoalRepository _repository;

  GetSavedSearchQueryUseCase(this._repository);

  Future<String?> call() async {
    return await _repository.getSavedSearchQuery();
  }
}
