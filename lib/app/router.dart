import 'package:go_router/go_router.dart';
import '../features/dashboard/view/dashboard_screen.dart';
import '../features/expenses/view/expenses_screen.dart';
import '../features/budget/view/budget_screen.dart';
import '../features/settings/view/settings_screen.dart';
import 'bottom_nav_bar.dart';

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppBottomNavBar(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: DashboardScreen()),
        ),
        GoRoute(
          path: '/expenses',
          name: 'expenses',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ExpensesScreen()),
        ),
        GoRoute(
          path: '/budget',
          name: 'budget',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: BudgetScreen()),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SettingsScreen()),
        ),
      ],
    ),
  ],
);
