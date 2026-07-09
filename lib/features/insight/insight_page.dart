import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/shell/widgets/placeholder_view.dart';

/// M0 placeholder for the Insight tab (charts + insight cards land later).
class InsightPage extends StatelessWidget {
  const InsightPage({super.key});

  @override
  Widget build(BuildContext context) => PlaceholderView(
    title: Strings.of(context)?.insight ?? 'Insight',
    icon: Icons.insights_rounded,
  );
}
