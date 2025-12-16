import 'package:prac12/core/models/tips/tip_article_model.dart';
import 'package:prac12/domain/repositories/tips/tips_repository.dart';

class GetLatestTipsUseCase {
  final TipsRepository _repository;

  GetLatestTipsUseCase(this._repository);

  Future<List<TipArticle>> call() async {
    return await _repository.getLatestTips();
  }
}

