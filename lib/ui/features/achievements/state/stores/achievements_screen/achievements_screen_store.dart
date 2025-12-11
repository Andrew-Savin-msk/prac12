import 'package:mobx/mobx.dart';
import 'package:prac12/core/models/achievements/achievement_model.dart';
import 'package:prac12/domain/usecases/achievements/get_achievements_usecase.dart';

class AchievementsScreenStore {
  AchievementsScreenStore(this._getAchievementsUseCase) {
    _hasAchievements = Computed(() => achievements.isNotEmpty);
    _unlockedCount = Computed(() => achievements.where((a) => a.isUnlocked).length);
    refresh();
  }

  final GetAchievementsUseCase _getAchievementsUseCase;

  ObservableList<Achievement> achievements = ObservableList<Achievement>();

  late final Computed<bool> _hasAchievements;
  bool get hasAchievements => _hasAchievements.value;

  late final Computed<int> _unlockedCount;
  int get unlockedCount => _unlockedCount.value;

  void refresh() {
    final newAchievements = _getAchievementsUseCase();
    runInAction(() {
      achievements
        ..clear()
        ..addAll(newAchievements);
    });
  }
}

