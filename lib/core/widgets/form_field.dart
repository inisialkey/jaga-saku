import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Form field caption (bottom-padded, secondary bodySmall). Replaces the seven
/// verbatim `_FieldLabel` copies across the form pages + reconcile sheet.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: context.colors.textSecondary),
    ),
  );
}

/// Shared outlined input decoration for the form TextFields. A function (not an
/// InputDecorationTheme) on purpose: a theme would leak into settings/search
/// fields whose `border: InputBorder.none` is outranked by an enabled/focused
/// theme border.
InputDecoration appInputDecoration(
  BuildContext context, {
  required String hint,
}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: context.colors.border),
  );
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Theme.of(context).cardColor,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: 14,
    ),
    border: border,
    enabledBorder: border,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
  );
}
