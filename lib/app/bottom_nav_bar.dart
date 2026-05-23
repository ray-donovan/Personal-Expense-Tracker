import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    _TabItem(icon: Icons.home_outlined, label: 'Home', path: '/dashboard'),
    _TabItem(icon: Icons.receipt_long_outlined, label: 'Expenses', path: '/expenses'),
    _TabItem(icon: Icons.account_balance_wallet_outlined, label: 'Budget', path: '/budget'),
    _TabItem(icon: Icons.settings_outlined, label: 'Settings', path: '/settings'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _tabs.indexWhere((t) => location.startsWith(t.path));
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: _CustomNavBar(
        tabs: _tabs,
        currentIndex: currentIndex,
        onTap: (index) => context.go(_tabs[index].path),
      ),
    );
  }
}

class _CustomNavBar extends StatelessWidget {
  const _CustomNavBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  final List<_TabItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  Widget _buildTab(_TabItem tab, int index, bool selected) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 6),
            Icon(tab.icon, size: 22, color: selected ? Colors.black : Colors.grey),
            const SizedBox(height: 3),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = math.max(10.0, MediaQuery.viewPaddingOf(context).bottom);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 50 + bottomPadding,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Row(
                children: [
                  // Left tabs (0, 1)
                  ...[0, 1].map((i) => _buildTab(tabs[i], i, currentIndex == i)),
                  // Centre + button
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 4),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 22),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Right tabs (2, 3)
                  ...[2, 3].map((i) => _buildTab(tabs[i], i, currentIndex == i)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.icon,
    required this.label,
    required this.path,
  });

  final IconData icon;
  final String label;
  final String path;
}
