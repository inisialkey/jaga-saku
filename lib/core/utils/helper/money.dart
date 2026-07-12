/// Groups a run of decimal digits into dot-separated thousands, e.g.
/// `groupDigits('1000000')` → `1.000.000`. Grouping uses `.` regardless of the
/// runtime locale so it never depends on intl locale data being loaded.
///
/// Shared by [formatRupiah] and the calculator keypad ([CalcEngine.format]) so
/// both render thousands identically.
String groupDigits(String digits) {
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Formats an integer rupiah amount as Indonesian currency, e.g.
/// `formatRupiah(8450000)` → `Rp 8.450.000`.
///
/// Money is stored as a positive INTEGER of rupiah (see the DB schema); the
/// sign is a display concern driven by transaction type, so pass [sign]
/// (`'+'` / `'-'`) when a signed amount is wanted.
String formatRupiah(int amount, {String sign = ''}) =>
    '${sign}Rp ${groupDigits(amount.abs().toString())}';

/// Compact Indonesian rupiah for tight gutters (chart y-axis, hero). Full
/// [formatRupiah] below 1.000; then `rb` (ribu, 1e3), `jt` (juta, 1e6), `M`
/// (miliar, 1e9). One decimal, comma separator, trailing `,0` trimmed:
/// `12_000→"12rb"`, `1_500_000→"1,5jt"`, `8_450_000→"8,5jt"`,
/// `2_500_000_000→"2,5M"`. Rounding is half-up on the scaled value, so
/// `1_950_000→"2jt"` (1.95 → 2.0). ponytail: single ID format — the app is
/// ID-first; formatting, not an l10n key.
String formatCompactRupiah(int amount) {
  final neg = amount < 0;
  final v = amount.abs();
  String body;
  if (v < 1000) return formatRupiah(amount); // full form, incl. 0
  if (v < 1000000) {
    body = '${_compact(v, 1000)}rb';
  } else if (v < 1000000000) {
    body = '${_compact(v, 1000000)}jt';
  } else {
    body = '${_compact(v, 1000000000)}M';
  }
  return neg ? '-$body' : body;
}

/// `value/unit` to one decimal, `.` → `,`, trailing `,0` dropped
/// (`1_950_000/1e6 → "2"`; `1_500_000/1e6 → "1,5"`).
String _compact(int value, int unit) {
  final scaled = (value / unit * 10).round() / 10; // 1-decimal, round half-up
  var s = scaled.toStringAsFixed(1).replaceAll('.', ',');
  if (s.endsWith(',0')) s = s.substring(0, s.length - 2);
  return s;
}
