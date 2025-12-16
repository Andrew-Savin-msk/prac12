import 'package:mobx/mobx.dart';
import 'package:prac12/core/models/tips/tip_article_model.dart';
import 'package:prac12/core/models/tips/tip_tag_model.dart';
import 'package:prac12/domain/usecases/tips/get_tips_with_tag_usecase.dart';
import 'package:prac12/domain/usecases/tips/get_latest_tips_usecase.dart';
import 'package:prac12/domain/usecases/tips/get_tip_tags_usecase.dart';

class TipsListScreenStore {
  TipsListScreenStore(
    this._getTipsWithTagUseCase,
    this._getLatestTipsUseCase,
    this._getTipTagsUseCase,
  ) {
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
    loadInitialData();
  }

  final GetTipsWithTagUseCase _getTipsWithTagUseCase;
  final GetLatestTipsUseCase _getLatestTipsUseCase;
  final GetTipTagsUseCase _getTipTagsUseCase;

  ObservableList<TipArticle> articles = ObservableList.of([]);
  ObservableList<TipTag> tags = ObservableList.of([]);

  final Observable<String> _searchQuery = Observable('');
  String get searchQuery => _searchQuery.value;
  set searchQuery(String value) => _searchQuery.value = value;

  final Observable<bool> _isLoading = Observable(false);
  bool get isLoading => _isLoading.value;

  final Observable<bool> _showLatest = Observable(false);
  bool get showLatest => _showLatest.value;

  final Observable<String?> _selectedTag = Observable<String?>(null);
  String? get selectedTag => _selectedTag.value;

  late final Computed<List<TipArticle>> _filteredArticles;
  List<TipArticle> get filteredArticles => _filteredArticles.value;

  late final Computed<bool> _hasArticles;
  bool get hasArticles => _hasArticles.value;

  Future<void> loadInitialData() async {
    runInAction(() {
      _isLoading.value = true;
    });

    try {
      // Загружаем теги и статьи параллельно
      final results = await Future.wait([
        _getTipTagsUseCase(),
        _getTipsWithTagUseCase(),
      ]);

      runInAction(() {
        tags.clear();
        tags.addAll(results[0] as List<TipTag>);
        articles.clear();
        articles.addAll(results[1] as List<TipArticle>);
        _isLoading.value = false;
      });
      
      print('Loaded ${tags.length} tags and ${articles.length} articles');
    } catch (e, stackTrace) {
      runInAction(() {
        _isLoading.value = false;
      });
      print('Error loading tips: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> loadArticles({String? tag}) async {
    runInAction(() {
      _isLoading.value = true;
      _selectedTag.value = tag;
      _showLatest.value = false;
    });

    try {
      final list = await _getTipsWithTagUseCase(tag: tag);
      runInAction(() {
        articles.clear();
        articles.addAll(list);
        _isLoading.value = false;
      });
    } catch (e, stackTrace) {
      runInAction(() {
        _isLoading.value = false;
      });
      print('Error loading articles: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> loadLatestArticles() async {
    runInAction(() {
      _isLoading.value = true;
      _showLatest.value = true;
      _selectedTag.value = null;
    });

    try {
      final list = await _getLatestTipsUseCase();
      runInAction(() {
        articles.clear();
        articles.addAll(list);
        _isLoading.value = false;
      });
    } catch (e, stackTrace) {
      runInAction(() {
        _isLoading.value = false;
      });
      print('Error loading latest articles: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void setSearchQuery(String value) {
    runInAction(() {
      searchQuery = value;
    });
  }
}

