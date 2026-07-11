import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// An [AppCard] whose [children] are stacked and separated by 1px hairline
/// dividers. The generic grouping container behind [MenuSection] and the
/// settings / appearance / about option groups.
class HairlineCard extends StatelessWidget {
  const HairlineCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    child: Column(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) Divider(height: 1, color: context.colors.border),
          children[i],
        ],
      ],
    ),
  );
}
