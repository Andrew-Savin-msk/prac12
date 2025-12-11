import 'package:prac12/core/models/achievements/achievement_model.dart';

class AchievementLocalDataSource {
  final List<Achievement> _achievements = [
    Achievement(
      id: 'first_goal',
      title: 'Первая цель',
      description: 'Создайте свою первую цель',
      imageUrl: 'https://picsum.photos/id/237/600/400',
      isUnlocked: false,
    ),
    Achievement(
      id: 'five_goals',
      title: '5 целей',
      description: 'Создано 5 или более целей',
      imageUrl: 'https://picsum.photos/id/1025/600/400',
      isUnlocked: false,
    ),
    Achievement(
      id: 'first_completed_goal',
      title: 'Первая выполненная цель',
      description: 'Завершена хотя бы одна цель',
      imageUrl: 'https://picsum.photos/id/1011/600/400',
      isUnlocked: false,
    ),
    Achievement(
      id: 'three_completed_goals',
      title: '3 выполненные цели',
      description: 'Завершено 3 или более целей',
      imageUrl: 'https://picsum.photos/id/1003/600/400',
      isUnlocked: false,
    ),
    Achievement(
      id: 'perfect_goal',
      title: 'Идеальная цель',
      description: 'Хотя бы одна цель с полностью выполненными подзадачами',
      imageUrl: 'https://picsum.photos/id/1035/600/400',
      isUnlocked: false,
    ),
  ];

  List<Achievement> getAchievements() {
    return List.unmodifiable(_achievements);
  }

  void unlockAchievement(String id) {
    try {
      final achievement = _achievements.firstWhere((a) => a.id == id);
      achievement.isUnlocked = true;
    } catch (e) {
      // Achievement not found
    }
  }

  bool isAchievementUnlocked(String id) {
    try {
      final achievement = _achievements.firstWhere((a) => a.id == id);
      return achievement.isUnlocked;
    } catch (e) {
      return false;
    }
  }
}

