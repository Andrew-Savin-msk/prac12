import 'package:prac12/data/datasources/tips/tips_local_datasource.dart';
import 'package:prac12/data/datasources/tips/tips_remote_datasource.dart';
import 'package:prac12/core/models/tips/tip_article_model.dart';
import 'package:prac12/core/models/tips/tip_tag_model.dart';
import 'package:prac12/core/models/tips/tip_comment_model.dart';
import 'package:prac12/domain/repositories/tips/tips_repository.dart';

class TipsRepositoryImpl implements TipsRepository {
  final TipsLocalDataSource _localDataSource;
  final TipsRemoteDataSource _remoteDataSource;

  TipsRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
  );

  @override
  List<TipArticle> getAll() {
    return _localDataSource.getAll();
  }

  @override
  TipArticle? getById(String id) {
    return _localDataSource.getById(id);
  }

  @override
  Future<List<TipArticle>> getTips({String? tag}) async {
    return await _remoteDataSource.fetchArticles(tag: tag);
  }

  @override
  Future<List<TipArticle>> getLatestTips() async {
    return await _remoteDataSource.fetchLatestArticles();
  }

  @override
  Future<TipArticle> getTipById(int id) async {
    return await _remoteDataSource.fetchArticleById(id);
  }

  @override
  Future<List<TipTag>> getTipTags() async {
    return await _remoteDataSource.fetchTags();
  }

  @override
  Future<List<TipComment>> getTipComments(int articleId) async {
    return await _remoteDataSource.fetchComments(articleId);
  }
}

