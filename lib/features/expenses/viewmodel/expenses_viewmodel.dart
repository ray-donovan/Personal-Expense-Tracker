import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/expense_model.dart';

class ExpensesNotifier extends Notifier<List<Expense>> {
  @override
  List<Expense> build() => [];

  void add(Expense expense) {
    state = [...state, expense];
  }

  void update(Expense expense) {
    state = [
      for (final e in state)
        if (e.id == expense.id) expense else e,
    ];
  }

  void delete(String id) {
    state = state.where((e) => e.id != id).toList();
  }
}

final expensesProvider =
    NotifierProvider<ExpensesNotifier, List<Expense>>(ExpensesNotifier.new);
