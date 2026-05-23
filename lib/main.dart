import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'features/expenses/model/expense_model.dart';
import 'features/budget/model/budget_model.dart' as budget;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(budget.CategoryAdapter());
  await Future.wait([
    Hive.openBox<String>('userSettings'),
    Hive.openBox<Expense>('expenses'),
    Hive.openBox<budget.Category>('categories'),
  ]);
  runApp(const ProviderScope(child: App()));
}
