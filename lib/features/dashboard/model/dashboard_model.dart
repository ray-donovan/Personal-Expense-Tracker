import 'package:flutter/material.dart';

class CategoryBreakdown {
  const CategoryBreakdown({
    required this.categoryId,
    required this.name,
    required this.color,
    required this.amount,
    required this.percentage,
  });

  final String categoryId;
  final String name;
  final Color color;
  final double amount;
  final double percentage;
}

class DashboardSummary {
  final double totalExpenses;
  final double totalThisMonth;
  final double totalToday;
  final List<CategoryBreakdown> monthlyBreakdown;

  const DashboardSummary({
    required this.totalExpenses,
    required this.totalThisMonth,
    required this.totalToday,
    required this.monthlyBreakdown,
  });

  static const empty = DashboardSummary(
    totalExpenses: 0,
    totalThisMonth: 0,
    totalToday: 0,
    monthlyBreakdown: [],
  );
}
