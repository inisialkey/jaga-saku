import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';

/// Hosts the 4 bottom-nav branches in an indexed stack and the center Add FAB.
/// Add is not a tab — the FAB pushes the full-screen `/add` route on the root
/// navigator and returns to the active branch on close.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context);
    final items = [
      BottomNavItem(icon: Icons.home_rounded, label: s?.home ?? 'Home'),
      BottomNavItem(
        icon: Icons.calendar_today_rounded,
        label: s?.calendar ?? 'Calendar',
      ),
      BottomNavItem(
        icon: Icons.insights_rounded,
        label: s?.insight ?? 'Insight',
      ),
      BottomNavItem(icon: Icons.more_horiz_rounded, label: s?.more ?? 'More'),
    ];

    return Scaffold(
      body: navigationShell,
      floatingActionButton: AddButton(
        onPressed: () => context.push(AppRoute.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNav(
        items: items,
        currentIndex: navigationShell.currentIndex,
        onTap: _goBranch,
      ),
    );
  }

  void _goBranch(int index) => navigationShell.goBranch(
    index,
    // Re-tapping the active tab pops back to its initial location.
    initialLocation: index == navigationShell.currentIndex,
  );
}
