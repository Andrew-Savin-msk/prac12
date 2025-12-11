import 'package:flutter/material.dart';
import 'package:prac12/core/di/injection.dart';
import 'package:prac12/ui/features/tips/state/tip_detail_screen_store.dart';
import 'package:prac12/core/models/tips/tip_article_model.dart';
import 'package:prac12/domain/usecases/activity_log/log_tip_opened_usecase.dart';

class TipDetailScreen extends StatelessWidget {
  TipDetailScreen({super.key, required TipArticle article})
      : store = TipDetailScreenStore(
          article,
          getIt<LogTipOpenedUseCase>(),
        );

  final TipDetailScreenStore store;

  @override
  Widget build(BuildContext context) {
    final article = store.article;
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
            ],
          ),
        ),
      ),
    );
  }
}

