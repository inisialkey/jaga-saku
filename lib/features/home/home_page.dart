import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/shell/widgets/placeholder_view.dart';

/// M0 placeholder for the Home dashboard (Total Balance, Budget Guard, Daily
/// Review, Recent Transactions land in M3+).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderView(
    title: Strings.of(context)?.home ?? 'Home',
    icon: Icons.home_rounded,
  );
}
