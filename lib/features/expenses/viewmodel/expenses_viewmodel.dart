import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/expense_model.dart';
import '../repository/expense_repository.dart';

final _expenseRepositoryProvider = Provider((_) => ExpenseRepository());

class ExpensesNotifier extends Notifier<List<Expense>> {
  late final ExpenseRepository _repo;

  @override
  List<Expense> build() {
    _repo = ref.read(_expenseRepositoryProvider);
    return _repo.getAll();
  }

  Future<void> add(Expense expense) async {
    await _repo.save(expense);
    state = [...state, expense];
  }

  Future<void> update(Expense expense) async {
    await _repo.save(expense);
    state = [
      for (final e in state)
        if (e.id == expense.id) expense else e,
    ];
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    state = state.where((e) => e.id != id).toList();
  }
}

final expensesProvider =
    NotifierProvider<ExpensesNotifier, List<Expense>>(ExpensesNotifier.new);
