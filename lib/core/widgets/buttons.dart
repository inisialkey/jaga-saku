import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Primary CTA (style guide §13.1): 52h, radius 14, green fill, white label,
/// pressed = darker green, disabled = muted, loading = spinner + disabled.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.expanded = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool expanded;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final button = SizedBox(
      height: 52,
      width: expanded ? double.infinity : null,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style:
            FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.disabled,
              // White on #CBD5E1 is ~1.5:1 (label vanishes); textSecondary is
              // ~3.2:1 — legible while still reading as disabled.
              disabledForegroundColor: AppColors.textSecondary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ).copyWith(
              overlayColor: WidgetStatePropertyAll(
                AppColors.primaryDark.withValues(alpha: 0.24),
              ),
            ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : _Label(label: label, icon: icon),
      ),
    );
    return button;
  }
}

/// Secondary action (style guide §13.2): 48h, primaryLight fill, primaryDark
/// text, no border. Loading = spinner + disabled (mirrors [PrimaryButton]).
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.expanded = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool expanded;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    return SizedBox(
      height: 48,
      width: expanded ? double.infinity : null,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.primaryDark,
          disabledBackgroundColor: context.colors.surfaceSoft,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryDark,
                ),
              )
            : _Label(label: label, icon: icon),
      ),
    );
  }
}

/// Tertiary text action (style guide §13.3): no background, green label.
/// Loading = spinner + disabled, mirroring [PrimaryButton] / [SecondaryButton]
/// — a text CTA that owns a write (onboarding's *Quick Start*) must be able to
/// show its OWN busy state, or the spinner lands on a button the user never
/// tapped.
class TextButtonX extends StatelessWidget {
  const TextButtonX({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: Theme.of(context).textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),
      // 16dp, not the 20dp of the filled buttons: a text button is label-height
      // only, so a 20dp spinner would grow it and shift the CTA block.
      child: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            )
          : _Label(label: label, icon: icon),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null) return Text(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: AppSpacing.sm),
        Text(label),
      ],
    );
  }
}
