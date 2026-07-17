/// Builds the stable, readable export filename
/// `jaga-saku-transactions-YYYYMMDD-HHmm.csv` from [now]. Manual zero-padding —
/// no `intl` — so it is deterministic and locale-independent (mirrors M1's
/// backup filename convention). Pure function; the caller injects the clock.
String exportFileName(DateTime now) {
  String two(int n) => n.toString().padLeft(2, '0');
  final date =
      '${now.year.toString().padLeft(4, '0')}'
      '${two(now.month)}${two(now.day)}';
  final time = '${two(now.hour)}${two(now.minute)}';
  return 'jaga-saku-transactions-$date-$time.csv';
}
