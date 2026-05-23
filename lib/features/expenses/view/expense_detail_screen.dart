import 'package:flutter/material.dart';
import '../model/expense_model.dart';
import 'expense_form_screen.dart';

class ExpenseDetailScreen extends StatelessWidget {
  const ExpenseDetailScreen({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) => ExpenseFormScreen(initial: expense);
}
