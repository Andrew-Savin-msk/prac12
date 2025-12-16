import 'package:prac12/core/models/tips/tip_comment_model.dart';
import 'package:prac12/domain/repositories/tips/tips_repository.dart';

class GetTipCommentsUseCase {
  final TipsRepository _repository;

  GetTipCommentsUseCase(this._repository);

  Future<List<TipComment>> call(int articleId) async {
    return await _repository.getTipComments(articleId);
  }
}

