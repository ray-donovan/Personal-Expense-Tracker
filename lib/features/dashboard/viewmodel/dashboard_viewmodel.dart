import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/dashboard_model.dart';
import '../../expenses/viewmodel/expenses_viewmodel.dart';

final dashboardProvider = Provider<DashboardSummary>((ref) {
  final expenses = ref.watch(expensesProvider);
  final now = DateTime.now();

  final totalExpenses = expenses.fold(0.0, (sum, e) => sum + e.amount);

  final totalThisMonth = expenses
      .where((e) => e.date.year == now.year && e.date.month == now.month)
      .fold(0.0, (sum, e) => sum + e.amount);

  final totalToday = expenses
      .where(
        (e) =>
            e.date.year == now.year &&
            e.date.month == now.month &&
            e.date.day == now.day,
      )
      .fold(0.0, (sum, e) => sum + e.amount);

  final expensesByCategory = <String, double>{};
  for (final e in expenses) {
    expensesByCategory[e.categoryId] =
        (expensesByCategory[e.categoryId] ?? 0) + e.amount;
  }

  return DashboardSummary(
    totalExpenses: totalExpenses,
    totalThisMonth: totalThisMonth,
    totalToday: totalToday,
    expensesByCategory: expensesByCategory,
  );
});
