import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/tips/state/tips_list_screen_store.dart';
import 'package:prac12/domain/usecases/tips/get_tips_usecase.dart';
import 'package:prac12/ui/features/goals/app_router.dart';

class TipsListScreen extends StatelessWidget {
  TipsListScreen({super.key})
      : store = TipsListScreenStore(getIt<GetTipsUseCase>());

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
                            context.push(
                              Routes.tipDetail,
                              extra: article,
                            );
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

