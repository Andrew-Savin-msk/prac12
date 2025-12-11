import 'package:prac12/data/datasources/tips/tips_local_datasource.dart';
import 'package:prac12/core/models/tips/tip_article_model.dart';
import 'package:prac12/domain/repositories/tips/tips_repository.dart';

class TipsRepositoryImpl implements TipsRepository {
  final TipsLocalDataSource _dataSource;

  TipsRepositoryImpl(this._dataSource);

  @override
  List<TipArticle> getAll() {
    return _dataSource.getAll();
  }

  @override
  TipArticle? getById(String id) {
    return _dataSource.getById(id);
  }
}

