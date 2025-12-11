import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/achievements/state/stores/achievements_screen/achievements_screen_store.dart';
import 'package:prac12/core/models/achievements/achievement_model.dart';
import 'package:prac12/domain/usecases/achievements/get_achievements_usecase.dart';

class AchievementsScreen extends StatelessWidget {
  AchievementsScreen({super.key})
      : store = AchievementsScreenStore(getIt<GetAchievementsUseCase>());

  final AchievementsScreenStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ачивки'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Observer(
        builder: (_) {
          final achievements = store.achievements;
          final unlockedCount = store.unlockedCount;
          final totalCount = achievements.length;

          if (achievements.isEmpty) {
            return const _EmptyState();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Открыто $unlockedCount из $totalCount',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: achievements.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final a = achievements[i];
                    return _AchievementTile(achievement: a);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final Achievement achievement;
  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.isUnlocked;
    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.5,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        leading: _Thumb(url: achievement.imageUrl, isUnlocked: isUnlocked),
        title: Text(
          achievement.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (!isUnlocked)
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  'Пока не открыто',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
        trailing: Icon(
          isUnlocked ? Icons.verified : Icons.lock_outline,
          color: isUnlocked ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final String url;
  final bool isUnlocked;
  const _Thumb({required this.url, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: url,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            placeholder: (c, _) => const SizedBox(
              width: 72,
              height: 72,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            errorWidget: (c, _, __) => const SizedBox(
              width: 72,
              height: 72,
              child: Icon(Icons.broken_image),
            ),
          ),
          if (!isUnlocked)
            Container(
              width: 72,
              height: 72,
              color: Colors.black.withValues(alpha: 0.3),
              child: const Icon(
                Icons.lock,
                color: Colors.white,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Text('Ачивок пока нет'),
      ),
    );
  }
}

