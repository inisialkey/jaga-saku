import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Section title row (style guide §11): H2 title on the left, optional
/// trailing text action (e.g. "See All") on the right.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    super.key,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (actionLabel != null && onAction != null)
          TextButtonX(label: actionLabel!, onPressed: onAction),
      ],
    ),
  );
}
