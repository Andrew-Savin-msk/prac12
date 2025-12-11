import 'package:prac12/core/models/tips/tip_article_model.dart';
import 'package:prac12/domain/repositories/tips/tips_repository.dart';

class GetTipByIdUseCase {
  final TipsRepository _repository;

  GetTipByIdUseCase(this._repository);

  TipArticle? call(String id) {
    return _repository.getById(id);
  }
}

