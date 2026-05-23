import 'package:hive/hive.dart';
import '../model/expense_model.dart';

class ExpenseRepository {
  static const _boxName = 'expenses';

  Box<Expense> get _box => Hive.box<Expense>(_boxName);

  List<Expense> getAll() => _box.values.toList();

  Future<void> save(Expense expense) => _box.put(expense.id, expense);

  Future<void> delete(String id) => _box.delete(id);
}
