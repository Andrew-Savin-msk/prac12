import 'package:prac12/core/models/tips/tip_article_model.dart';
import 'package:prac12/core/models/tips/tip_tag_model.dart';
import 'package:prac12/core/models/tips/tip_comment_model.dart';

abstract class TipsRepository {
  List<TipArticle> getAll();
  TipArticle? getById(String id);
  
  // Новые методы для работы с DEV.to API
  Future<List<TipArticle>> getTips({String? tag});
  Future<List<TipArticle>> getLatestTips();
  Future<TipArticle> getTipById(int id);
  Future<List<TipTag>> getTipTags();
  Future<List<TipComment>> getTipComments(int articleId);
}

