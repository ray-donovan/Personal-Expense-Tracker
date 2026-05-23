import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../viewmodel/dashboard_viewmodel.dart';
import '../model/dashboard_model.dart';
import '../../../shared/widgets/empty_expenses_state.dart';
import '../../settings/viewmodel/settings_viewmodel.dart';
import '../../expenses/viewmodel/expenses_viewmodel.dart';
import '../../budget/viewmodel/budget_viewmodel.dart';
import '../../expenses/model/expense_model.dart';
import '../../budget/model/budget_model.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardProvider);
    final userName = ref.watch(userNameProvider);
    final allExpenses = ref.watch(expensesProvider);
    final categories = ref.watch(budgetProvider);
    final breakdown = summary.monthlyBreakdown;

    final recentExpenses = ([...allExpenses]
          ..sort((a, b) => b.date.compareTo(a.date)))
        .take(7)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: CustomScrollView(
        physics: const ScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: false,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
            ),
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: const Color(0xCCF0F0F0)),
              ),
            ),
            title: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  const TextSpan(
                    text: 'Hi, ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: userName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  'This Month',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'RM ${summary.totalThisMonth.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.5,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                _SegmentedBar(breakdown: breakdown),
                const SizedBox(height: 16),
                if (breakdown.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _CategoryLegend(breakdown: breakdown),
                  ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Expenses',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/expenses'),
                        child: const Text(
                          'View all',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF007AFF),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (summary.totalExpenses == 0)
                    const Expanded(child: EmptyExpensesState())
                  else
                    ...recentExpenses.map((expense) {
                      final cat = categories
                          .where((c) => c.id == expense.categoryId)
                          .firstOrNull;
                      return _RecentExpenseTile(expense: expense, cat: cat);
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _relativeDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final d = DateTime(date.year, date.month, date.day);
  final diff = today.difference(d).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return DateFormat('d MMM').format(date);
}

class _RecentExpenseTile extends StatelessWidget {
  const _RecentExpenseTile({required this.expense, required this.cat});
  final Expense expense;
  final Category? cat;

  @override
  Widget build(BuildContext context) {
    final catColor = cat != null ? Color(cat!.colorValue) : Colors.black12;
    return GestureDetector(
      onTap: () => context.push('/expenses/detail', extra: expense),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: catColor.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: cat != null && cat!.icon.isNotEmpty
                    ? Text(cat!.icon, style: const TextStyle(fontSize: 20))
                    : Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: catColor,
                          shape: BoxShape.circle,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _relativeDate(expense.date),
                    style: const TextStyle(fontSize: 13, color: Colors.black45),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'RM ${expense.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedBar extends StatelessWidget {
  const _SegmentedBar({required this.breakdown});
  final List<CategoryBreakdown> breakdown;

  @override
  Widget build(BuildContext context) {
    if (breakdown.isEmpty) {
      return Container(
        height: 12,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          for (int i = 0; i < breakdown.length; i++)
            Flexible(
              flex: (breakdown[i].percentage * 1000).round(),
              child: Container(
                height: 12,
                color: breakdown[i].color,
                margin: EdgeInsets.only(right: i < breakdown.length - 1 ? 2 : 0),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryLegend extends StatelessWidget {
  const _CategoryLegend({required this.breakdown});
  final List<CategoryBreakdown> breakdown;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: breakdown.map((slice) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: slice.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                slice.name,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
            Text(
              '${(slice.percentage * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}