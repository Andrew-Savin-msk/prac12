import 'package:prac12/core/models/tips/tip_article_model.dart';
import 'package:prac12/domain/repositories/tips/tips_repository.dart';

class GetTipsUseCase {
  final TipsRepository _repository;

  GetTipsUseCase(this._repository);

  List<TipArticle> call() {
    return _repository.getAll();
  }
}

