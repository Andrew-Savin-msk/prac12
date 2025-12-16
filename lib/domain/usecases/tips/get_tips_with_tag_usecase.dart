import 'package:prac12/core/models/tips/tip_article_model.dart';
import 'package:prac12/domain/repositories/tips/tips_repository.dart';

class GetTipsWithTagUseCase {
  final TipsRepository _repository;

  GetTipsWithTagUseCase(this._repository);

  Future<List<TipArticle>> call({String? tag}) async {
    return await _repository.getTips(tag: tag);
  }
}

