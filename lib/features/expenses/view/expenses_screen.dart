import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../viewmodel/expenses_viewmodel.dart';
import '../../budget/viewmodel/budget_viewmodel.dart';
import '../../budget/model/budget_model.dart';
import '../model/expense_model.dart';
import '../../../shared/widgets/empty_expenses_state.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(expensesProvider);
    final categories = ref.watch(budgetProvider);

    final filtered = _query.isEmpty
        ? expenses
        : expenses
            .where((e) =>
                e.title.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    // Group expenses by date, most recent first
    final sorted = [...filtered]..sort((a, b) => b.date.compareTo(a.date));
    final grouped = <String, List<Expense>>{};
    for (final e in sorted) {
      final key = DateFormat('d MMM yyyy').format(e.date);
      grouped.putIfAbsent(key, () => []).add(e);
    }
    final dateKeys = grouped.keys.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Expenses'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search expenses...',
                hintStyle:
                    const TextStyle(fontSize: 14, color: Colors.black38),
                prefixIcon:
                    const Icon(Icons.search, size: 20, color: Colors.black38),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close,
                            size: 18, color: Colors.black38),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? _query.isNotEmpty
                    ? const _NoSearchResults()
                    : const EmptyExpensesState()
                : ListView.builder(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                    itemCount: dateKeys.length,
                    itemBuilder: (context, index) {
                      final dateLabel = dateKeys[index];
                      final dayExpenses = grouped[dateLabel]!;
                      return _DaySection(
                        dateLabel: dateLabel,
                        expenses: dayExpenses,
                        categories: categories,
                      );
                    },
                  ),
          ),
        ],
        ),
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({
    required this.dateLabel,
    required this.expenses,
    required this.categories,
  });

  final String dateLabel;
  final List<Expense> expenses;
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final dayTotal = expenses.fold(0.0, (sum, e) => sum + e.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.zero,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                ),
              ),
              Text(
                'RM ${dayTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              for (int i = 0; i < expenses.length; i++) ...[
                _ExpenseTile(
                  expense: expenses[i],
                  categories: categories,
                ),
              ],
            ],
          ),
          ),
        ),
      ],
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({required this.expense, required this.categories});

  final Expense expense;
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final cat = categories
        .where((c) => c.id == expense.categoryId)
        .firstOrNull;
    final catColor = cat != null ? Color(cat.colorValue) : Colors.black12;
    final catName = cat?.name ?? 'Uncategorised';

    return GestureDetector(
      onTap: () => context.push('/expenses/detail', extra: expense),
      behavior: HitTestBehavior.opaque,
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: catColor.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: cat != null && cat.icon.isNotEmpty
                  ? Text(cat.icon, style: const TextStyle(fontSize: 16))
                  : Container(
                      width: 8,
                      height: 8,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  catName,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
          Text(
            'RM ${expense.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _NoSearchResults extends StatelessWidget {
  const _NoSearchResults();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: Colors.black12),
          SizedBox(height: 12),
          Text('No expenses found',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black45)),
          SizedBox(height: 4),
          Text('Try a different search term',
              style: TextStyle(fontSize: 13, color: Colors.black26)),
        ],
      ),
    );
  }
}


