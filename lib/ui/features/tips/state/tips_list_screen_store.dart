import 'package:mobx/mobx.dart';
import 'package:prac12/core/models/tips/tip_article_model.dart';
import 'package:prac12/domain/usecases/tips/get_tips_usecase.dart';

class TipsListScreenStore {
  TipsListScreenStore(this._getTipsUseCase) {
    _filteredArticles = Computed(() {
      final query = _searchQuery.value;
      if (query.trim().isEmpty) return articles.toList();
      final q = query.toLowerCase().trim();
      return articles
          .where((a) =>
              a.title.toLowerCase().contains(q) ||
              a.shortDescription.toLowerCase().contains(q) ||
              (a.category?.toLowerCase().contains(q) ?? false))
          .toList();
    });
    _hasArticles = Computed(() => filteredArticles.isNotEmpty);
    loadArticles();
  }

  final GetTipsUseCase _getTipsUseCase;

  ObservableList<TipArticle> articles = ObservableList.of([]);

  final Observable<String> _searchQuery = Observable('');
  String get searchQuery => _searchQuery.value;
  set searchQuery(String value) => _searchQuery.value = value;

  late final Computed<List<TipArticle>> _filteredArticles;
  List<TipArticle> get filteredArticles => _filteredArticles.value;

  late final Computed<bool> _hasArticles;
  bool get hasArticles => _hasArticles.value;

  void loadArticles() {
    final list = _getTipsUseCase();
    runInAction(() {
      articles
        ..clear()
        ..addAll(list);
    });
  }

  void setSearchQuery(String value) {
    runInAction(() {
      searchQuery = value;
    });
  }
}

