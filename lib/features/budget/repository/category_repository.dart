import 'package:hive/hive.dart';
import '../model/budget_model.dart';

class CategoryRepository {
  static const _boxName = 'categories';

  Box<Category> get _box => Hive.box<Category>(_boxName);

  List<Category> getAll() => _box.values.toList();

  Future<void> save(Category category) => _box.put(category.id, category);

  Future<void> delete(String id) => _box.delete(id);
}
