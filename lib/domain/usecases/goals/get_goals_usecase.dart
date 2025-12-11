import 'package:prac12/core/models/goals/goal_model.dart';
import 'package:prac12/domain/repositories/goals/goal_repository.dart';

class GetGoalsUseCase {
  final GoalRepository _repository;

  GetGoalsUseCase(this._repository);

  List<Goal> call() {
    return _repository.getGoals();
  }
}

