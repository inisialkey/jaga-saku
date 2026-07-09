import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Lightweight loading indicator (style guide §17 — small spinner with
/// optional context label). Used by the blocking loading dialog
/// (`context.show()`).
class Loading extends StatelessWidget {
  const Loading({super.key, this.showMessage = true});

  final bool showMessage;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: AppColors.primary,
        ),
      ),
      if (showMessage) ...[
        const SizedBox(height: AppSpacing.md),
        Text(
          Strings.of(context)!.pleaseWait,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ],
  );
}
