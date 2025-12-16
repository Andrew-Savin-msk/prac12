import 'package:mobx/mobx.dart';
import 'package:prac12/core/models/tips/tip_article_model.dart';
import 'package:prac12/core/models/tips/tip_comment_model.dart';
import 'package:prac12/domain/usecases/activity_log/log_tip_opened_usecase.dart';
import 'package:prac12/domain/usecases/tips/get_tip_by_id_usecase.dart';
import 'package:prac12/domain/usecases/tips/get_tip_comments_usecase.dart';

class TipDetailScreenStore {
  TipDetailScreenStore(
    TipArticle? article,
    int? articleId,
    this._logTipOpenedUseCase,
    this._getTipByIdUseCase,
    this._getTipCommentsUseCase,
  ) {
    if (article != null) {
      _article = Observable(article);
      _loadComments(int.tryParse(article.id));
      _logTipOpened();
    } else if (articleId != null) {
      _loadArticleAndComments(articleId);
    }
  }

  final LogTipOpenedUseCase _logTipOpenedUseCase;
  final GetTipByIdUseCase _getTipByIdUseCase;
  final GetTipCommentsUseCase _getTipCommentsUseCase;

  Observable<TipArticle?> _article = Observable(null);
  TipArticle? get article => _article.value;

  final ObservableList<TipComment> comments = ObservableList.of([]);

  final Observable<bool> _isLoading = Observable(true);
  bool get isLoading => _isLoading.value;

  Future<void> _loadArticleAndComments(int articleId) async {
    runInAction(() {
      _isLoading.value = true;
    });

    try {
      final article = await _getTipByIdUseCase(articleId);
      runInAction(() {
        _article.value = article;
        _isLoading.value = false;
      });
      _loadComments(articleId);
      _logTipOpened();
    } catch (e) {
      runInAction(() {
        _isLoading.value = false;
      });
      print('Error loading article: $e');
    }
  }

  Future<void> _loadComments(int? articleId) async {
    if (articleId == null) return;

    try {
      final commentsList = await _getTipCommentsUseCase(articleId);
      runInAction(() {
        comments.clear();
        comments.addAll(commentsList);
      });
    } catch (e) {
      print('Error loading comments: $e');
    }
  }

  void _logTipOpened() {
    final article = _article.value;
    if (article != null) {
      _logTipOpenedUseCase(article.title);
    }
  }
}

