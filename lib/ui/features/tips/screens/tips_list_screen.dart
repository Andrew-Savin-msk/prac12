import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/tips/state/tips_list_screen_store.dart';
import 'package:prac12/domain/usecases/tips/get_tips_with_tag_usecase.dart';
import 'package:prac12/domain/usecases/tips/get_latest_tips_usecase.dart';
import 'package:prac12/domain/usecases/tips/get_tip_tags_usecase.dart';
import 'package:prac12/ui/features/goals/app_router.dart';

class TipsListScreen extends StatelessWidget {
  TipsListScreen({super.key})
      : store = TipsListScreenStore(
          getIt<GetTipsWithTagUseCase>(),
          getIt<GetLatestTipsUseCase>(),
          getIt<GetTipTagsUseCase>(),
        );

  final TipsListScreenStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Советы и статьи'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Переключатель Latest / All
            Observer(
              builder: (_) => Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Все статьи'),
                      selected: !store.showLatest,
                      onSelected: (selected) {
                        if (selected) {
                          store.loadArticles();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Последние'),
                      selected: store.showLatest,
                      onSelected: (selected) {
                        if (selected) {
                          store.loadLatestArticles();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Фильтр по тегам
            Observer(
              builder: (_) => SizedBox(
                height: 40,
                child: store.tags.isEmpty
                    ? const SizedBox.shrink()
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: store.tags.length,
                        itemBuilder: (context, index) {
                          final tag = store.tags[index];
                          final isSelected = store.selectedTag == tag.name;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(tag.name),
                              selected: isSelected,
                              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                              checkmarkColor: Theme.of(context).primaryColor,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : null,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (_) {
                                // Если тег уже выбран - снимаем выбор, иначе выбираем его
                                if (isSelected) {
                                  store.loadArticles(tag: null);
                                } else {
                                  store.loadArticles(tag: tag.name);
                                }
                              },
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 8),
            // Поисковая строка
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Поиск по статьям...',
                border: OutlineInputBorder(),
              ),
              onChanged: store.setSearchQuery,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Observer(
                builder: (_) {
                  if (store.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final items = store.filteredArticles;

                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        'Статей пока нет.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final article = items[index];
                      final date = article.createdAt;
                      final dateString =
                          '${date.day.toString().padLeft(2, '0')}.'
                          '${date.month.toString().padLeft(2, '0')}.'
                          '${date.year}';

                      return Card(
                        child: ListTile(
                          title: Text(article.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                article.shortDescription,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    dateString,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                  if (article.category != null) ...[
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: Text(
                                        article.category!,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Передаем ID статьи (int) вместо объекта
                            final articleId = int.tryParse(article.id);
                            if (articleId != null) {
                              context.push(
                                Routes.tipDetail,
                                extra: articleId,
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

