import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// The center "Add" action (style guide §18): 56 circle, green fill, white
/// plus, medium shadow. Used as the shell's floating action button.
class AddButton extends StatelessWidget {
  const AddButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: Strings.of(context)?.add ?? 'Add',
    child: SizedBox(
      width: 56,
      height: 56,
      child: Material(
        color: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 6,
        shadowColor: AppColors.primary.withValues(alpha: 0.4),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: const Icon(
            Icons.add_rounded,
            color: AppColors.white,
            size: 28,
          ),
        ),
      ),
    ),
  );
}
