import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Thin progress bar (style guide §13.13): 8h, radius 999, surfaceSoft track,
/// fill in a semantic color. [value] is clamped to 0..1.
class ProgressBarX extends StatelessWidget {
  const ProgressBarX({
    required this.value,
    super.key,
    this.color,
    this.height = 8,
  });

  final double value;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: LinearProgressIndicator(
        value: clamped,
        minHeight: height,
        backgroundColor: context.colors.surfaceSoft,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
      ),
    );
  }
}
