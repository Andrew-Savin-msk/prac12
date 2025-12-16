import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:prac12/data/datasources/tips/dto/devto_article_dto.dart';
import 'package:prac12/data/datasources/tips/dto/devto_tag_dto.dart';
import 'package:prac12/data/datasources/tips/dto/devto_comment_dto.dart';

part 'devto_api_client.g.dart';

@RestApi()
abstract class DevtoApiClient {
  factory DevtoApiClient(Dio dio, {String baseUrl}) = _DevtoApiClient;

  @GET('/articles')
  Future<List<DevtoArticleDto>> getArticles({
    @Query('tag') String? tag,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  @GET('/articles/latest')
  Future<List<DevtoArticleDto>> getLatestArticles({
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  @GET('/articles/{id}')
  Future<DevtoArticleDto> getArticleById(
    @Path('id') int id,
  );

  @GET('/tags')
  Future<List<DevtoTagDto>> getTags({
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  @GET('/comments')
  Future<List<DevtoCommentDto>> getCommentsByArticleId(
    @Query('a_id') int articleId,
  );
}

