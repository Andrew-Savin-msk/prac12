import 'package:prac12/core/models/achievements/achievement_model.dart';
import 'package:prac12/domain/repositories/achievements/achievement_repository.dart';

class GetAchievementsUseCase {
  final AchievementRepository _repository;

  GetAchievementsUseCase(this._repository);

  List<Achievement> call() {
    return _repository.getAchievements();
  }
}

