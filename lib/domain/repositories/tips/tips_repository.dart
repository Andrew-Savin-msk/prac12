import 'package:prac12/core/models/tips/tip_article_model.dart';

abstract class TipsRepository {
  List<TipArticle> getAll();
  TipArticle? getById(String id);
}

