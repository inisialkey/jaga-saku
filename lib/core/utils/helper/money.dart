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
