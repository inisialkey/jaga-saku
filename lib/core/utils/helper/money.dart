/// Formats an integer rupiah amount as Indonesian currency, e.g.
/// `formatRupiah(8450000)` → `Rp 8.450.000`.
///
/// Money is stored as a positive INTEGER of rupiah (see the DB schema); the
/// sign is a display concern driven by transaction type, so pass [sign]
/// (`'+'` / `'-'`) when a signed amount is wanted. Grouping uses `.` regardless
/// of the runtime locale so it never depends on intl locale data being loaded.
String formatRupiah(int amount, {String sign = ''}) {
  final digits = amount.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '${sign}Rp $buffer';
}
