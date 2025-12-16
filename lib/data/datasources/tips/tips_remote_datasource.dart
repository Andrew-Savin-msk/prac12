import 'package:dio/dio.dart';
import 'package:prac12/core/models/tips/tip_article_model.dart';
import 'package:prac12/core/models/tips/tip_tag_model.dart';
import 'package:prac12/core/models/tips/tip_comment_model.dart';
import 'package:prac12/data/datasources/remote/api/exceptions.dart';
import 'package:prac12/data/datasources/tips/devto_api_client.dart';
import 'package:prac12/data/datasources/tips/devto_article_mapper.dart';
import 'package:prac12/data/datasources/tips/devto_tag_mapper.dart';
import 'package:prac12/data/datasources/tips/devto_comment_mapper.dart';

class TipsRemoteDataSource {
  final DevtoApiClient _apiClient;

  TipsRemoteDataSource(this._apiClient);

  /// Получить статьи (GET /articles)
  Future<List<TipArticle>> fetchArticles({String? tag}) async {
    try {
      print('Fetching articles${tag != null ? ' with tag: $tag' : ''}');
      final dtos = await _apiClient.getArticles(tag: tag);
      print('Received ${dtos.length} articles from API');
      final articles = dtos.map((dto) => DevtoArticleMapper.toDomain(dto)).toList();
      print('Mapped to ${articles.length} domain articles');
      return articles;
    } on DioException catch (e) {
      print('DioException in fetchArticles: ${e.message}');
      print('Response: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      rethrow;
    } catch (e, stackTrace) {
      print('Exception in fetchArticles: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Получить последние статьи (GET /articles/latest)
  Future<List<TipArticle>> fetchLatestArticles() async {
    try {
      final dtos = await _apiClient.getLatestArticles();
      return dtos.map((dto) => DevtoArticleMapper.toDomain(dto)).toList();
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Получить статью по ID (GET /articles/{id})
  Future<TipArticle> fetchArticleById(int id) async {
    try {
      final dto = await _apiClient.getArticleById(id);
      return DevtoArticleMapper.toDomain(dto);
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Получить теги (GET /tags)
  Future<List<TipTag>> fetchTags() async {
    try {
      print('Fetching tags');
      final dtos = await _apiClient.getTags();
      print('Received ${dtos.length} tags from API');
      final tags = dtos.map((dto) => DevtoTagMapper.toDomain(dto)).toList();
      print('Mapped to ${tags.length} domain tags');
      return tags;
    } on DioException catch (e) {
      print('DioException in fetchTags: ${e.message}');
      print('Response: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      rethrow;
    } catch (e, stackTrace) {
      print('Exception in fetchTags: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Получить комментарии по ID статьи (GET /comments?a_id=...)
  Future<List<TipComment>> fetchComments(int articleId) async {
    try {
      final dtos = await _apiClient.getCommentsByArticleId(articleId);
      return dtos.map((dto) => DevtoCommentMapper.toDomain(dto)).toList();
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}

