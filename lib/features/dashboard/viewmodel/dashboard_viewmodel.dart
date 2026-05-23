import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/dashboard_model.dart';
import '../../expenses/viewmodel/expenses_viewmodel.dart';
import '../../budget/viewmodel/budget_viewmodel.dart';

// Fallback palette when a category has no colour assigned
const _kFallbackColors = [
  Color(0xFF1A1A2E),
  Color(0xFF0F3460),
  Color(0xFF533483),
  Color(0xFF2B2D42),
  Color(0xFF8D99AE),
  Color(0xFF16213E),
];

final dashboardProvider = Provider<DashboardSummary>((ref) {
  final expenses = ref.watch(expensesProvider);
  final categories = ref.watch(budgetProvider);
  final now = DateTime.now();

  final totalExpenses = expenses.fold(0.0, (sum, e) => sum + e.amount);

  final thisMonthExpenses = expenses
      .where((e) => e.date.year == now.year && e.date.month == now.month)
      .toList();

  final totalThisMonth =
      thisMonthExpenses.fold(0.0, (sum, e) => sum + e.amount);

  final totalToday = thisMonthExpenses
      .where((e) => e.date.day == now.day)
      .fold(0.0, (sum, e) => sum + e.amount);

  // Build category breakdown scoped to this month only
  final amountByCategoryId = <String, double>{};
  for (final e in thisMonthExpenses) {
    amountByCategoryId[e.categoryId] =
        (amountByCategoryId[e.categoryId] ?? 0) + e.amount;
  }

  final breakdown = <CategoryBreakdown>[];
  if (totalThisMonth > 0) {
    int colorIdx = 0;
    amountByCategoryId.forEach((catId, amount) {
      final cat = categories.where((c) => c.id == catId).firstOrNull;
      final color = cat != null
          ? Color(cat.colorValue)
          : _kFallbackColors[colorIdx % _kFallbackColors.length];
      breakdown.add(CategoryBreakdown(
        categoryId: catId,
        name: cat?.name ?? 'Other',
        color: color,
        amount: amount,
        percentage: amount / totalThisMonth,
      ));
      colorIdx++;
    });
    breakdown.sort((a, b) => b.amount.compareTo(a.amount));
  }

  return DashboardSummary(
    totalExpenses: totalExpenses,
    totalThisMonth: totalThisMonth,
    totalToday: totalToday,
    monthlyBreakdown: breakdown,
  );
});
