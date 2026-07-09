import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Rounded icon container (style guide §12 "Category Icon Container"): 40×40,
/// radius 12, soft category-color background, icon in the category color.
/// Reused by account tiles, category rows and every transaction tile (M2+).
///
/// Takes the raw stored values ([icon] catalog key + [color] ARGB int) and
/// resolves them here so callers never touch [AppIcons] / [Color] directly.
class CategoryIconAvatar extends StatelessWidget {
  const CategoryIconAvatar({
    required this.icon,
    super.key,
    this.color,
    this.size = 40,
  });

  /// [AppIcons] catalog key.
  final String? icon;

  /// ARGB color value; falls back to the brand green.
  final int? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final resolved = color != null ? Color(color!) : AppColors.primary;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: resolved.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(AppIcons.resolve(icon), size: size * 0.55, color: resolved),
    );
  }
}
