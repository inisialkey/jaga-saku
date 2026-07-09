import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/shell/widgets/placeholder_view.dart';

/// M0 placeholder for the full-screen Add Transaction flow (opened via the
/// center FAB). The real amount input + selectors land in M2.
class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderView(
    title: Strings.of(context)?.addTransaction ?? 'Add Transaction',
    icon: Icons.add_circle_outline_rounded,
    showClose: true,
  );
}
