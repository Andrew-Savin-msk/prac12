import 'package:prac12/core/models/tips/tip_tag_model.dart';
import 'package:prac12/domain/repositories/tips/tips_repository.dart';

class GetTipTagsUseCase {
  final TipsRepository _repository;

  GetTipTagsUseCase(this._repository);

  Future<List<TipTag>> call() async {
    return await _repository.getTipTags();
  }
}

