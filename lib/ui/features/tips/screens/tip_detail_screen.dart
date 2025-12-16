import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/tips/state/tip_detail_screen_store.dart';
import 'package:prac12/core/models/tips/tip_article_model.dart';
import 'package:prac12/domain/usecases/activity_log/log_tip_opened_usecase.dart';

import 'package:prac12/domain/usecases/tips/get_tip_by_id_usecase.dart';
import 'package:prac12/domain/usecases/tips/get_tip_comments_usecase.dart';

class TipDetailScreen extends StatelessWidget {
  TipDetailScreen({
    super.key,
    TipArticle? article,
    int? articleId,
  }) : store = TipDetailScreenStore(
          article,
          articleId,
          getIt<LogTipOpenedUseCase>(),
          getIt<GetTipByIdUseCase>(),
          getIt<GetTipCommentsUseCase>(),
        );

  final TipDetailScreenStore store;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (store.isLoading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Загрузка...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final article = store.article;
        if (article == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Ошибка')),
            body: const Center(child: Text('Статья не найдена')),
          );
        }

        final date = article.createdAt;
        final dateString =
            '${date.day.toString().padLeft(2, '0')}.'
            '${date.month.toString().padLeft(2, '0')}.'
            '${date.year}';

        return Scaffold(
          appBar: AppBar(
            title: Text(article.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        dateString,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (article.category != null) ...[
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(article.category!),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.content,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Комментарии (${store.comments.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (store.comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Комментариев пока нет'),
                    )
                  else
                    ...store.comments.map((comment) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (comment.authorProfileImage != null)
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundImage: NetworkImage(
                                          comment.authorProfileImage!,
                                        ),
                                      )
                                    else
                                      const CircleAvatar(
                                        radius: 16,
                                        child: Icon(Icons.person, size: 16),
                                      ),
                                    const SizedBox(width: 8),
                                    Text(
                                      comment.authorName ?? comment.authorUsername ?? 'Anonymous',
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  comment.bodyHtml.replaceAll(RegExp(r'<[^>]*>'), ''),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

