import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Standard modal bottom-sheet body (style guide §19): drag handle, optional
/// centered title, 20 padding, safe-area aware. The 24 top radius comes from
/// `bottomSheetTheme`. Wrap the sheet content passed to `showModalBottomSheet`.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({required this.child, super.key, this.title});

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          if (title != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              title!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Flexible(child: child),
        ],
      ),
    ),
  );
}
