import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Rounded soft-tint icon square (style guide §12): [size]×[size], radius
/// [AppRadius.md], soft category-color background, icon in the category color.
///
/// Default ctor takes raw stored values ([icon] catalog key + [color] ARGB int),
/// resolved via [AppIcons]/[Color]. [CategoryIconAvatar.glyph] takes an
/// already-resolved [IconData] + [Color] for decorative feature glyphs.
class CategoryIconAvatar extends StatelessWidget {
  const CategoryIconAvatar({
    required this.icon,
    super.key,
    this.color,
    this.size = 40,
  }) : _glyphIcon = null,
       _glyphColor = null,
       _iconSize = null;

  /// Decorative glyph from a resolved [icon] + [color]. [iconSize] overrides the
  /// default `size * 0.55` so a swap keeps each call site's exact icon size.
  const CategoryIconAvatar.glyph({
    required IconData icon,
    required Color color,
    super.key,
    this.size = 40,
    double? iconSize,
  }) : _glyphIcon = icon,
       _glyphColor = color,
       _iconSize = iconSize,
       icon = null,
       color = null;

  /// [AppIcons] catalog key.
  final String? icon;

  /// ARGB color value; falls back to the brand green.
  final int? color;
  final IconData? _glyphIcon;
  final Color? _glyphColor;
  final double? _iconSize;
  final double size;

  @override
  Widget build(BuildContext context) {
    final resolved =
        _glyphColor ?? (color != null ? Color(color!) : AppColors.primary);
    final iconData = _glyphIcon ?? AppIcons.resolve(icon);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: resolved.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(iconData, size: _iconSize ?? size * 0.55, color: resolved),
    );
  }
}
