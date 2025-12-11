import 'package:mobx/mobx.dart';
import 'package:prac12/core/models/support/faq_item_model.dart';
import 'package:prac12/domain/usecases/support/get_faq_items_usecase.dart';

class SupportScreenStore {
  SupportScreenStore(this._getFaqItemsUseCase) {
    _hasFaq = Computed(() => faqItems.isNotEmpty);
    loadFaq();
  }

  final GetFaqItemsUseCase _getFaqItemsUseCase;

  ObservableList<FaqItem> faqItems = ObservableList.of([]);

  late final Computed<bool> _hasFaq;
  bool get hasFaq => _hasFaq.value;

  void loadFaq() {
    final items = _getFaqItemsUseCase();
    runInAction(() {
      faqItems
        ..clear()
        ..addAll(items);
    });
  }
}

