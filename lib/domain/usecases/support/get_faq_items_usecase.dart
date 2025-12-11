import 'package:prac12/core/models/support/faq_item_model.dart';
import 'package:prac12/domain/repositories/support/support_repository.dart';

class GetFaqItemsUseCase {
  final SupportRepository _repository;

  GetFaqItemsUseCase(this._repository);

  List<FaqItem> call() {
    return _repository.getFaqItems();
  }
}

