/// Swatch set for the account / category color picker.
///
/// Colors are stored in the DB as ARGB `int` (`accounts.color` /
/// `categories.color` are `INTEGER`) — never as a Flutter `Color` — so the
/// domain layer stays pure. These are the semantic + chart hues used by the
/// M0 seed and the expense donut later (M5).
class CategoryColors {
  CategoryColors._();

  /// ARGB values offered by the color-picker swatch grid.
  static const List<int> swatches = [
    0xFF16A34A, // primary green
    0xFF22C55E, // income green
    0xFF3B82F6, // transfer blue
    0xFF0EA5E9, // info sky
    0xFF14B8A6, // teal
    0xFFF59E0B, // warning amber
    0xFFEF4444, // expense red
    0xFFEC4899, // pink
    0xFF8B5CF6, // violet
    0xFF64748B, // slate
  ];

  /// First swatch — used as the default when a row has no color assigned.
  static int get fallback => swatches.first;
}
