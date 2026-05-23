class DashboardSummary {
  final double totalExpenses;
  final double totalThisMonth;
  final double totalToday;
  final Map<String, double> expensesByCategory;

  const DashboardSummary({
    required this.totalExpenses,
    required this.totalThisMonth,
    required this.totalToday,
    required this.expensesByCategory,
  });

  static const empty = DashboardSummary(
    totalExpenses: 0,
    totalThisMonth: 0,
    totalToday: 0,
    expensesByCategory: {},
  );
}
