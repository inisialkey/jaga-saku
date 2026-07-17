import 'package:jaga_saku/features/export/domain/entities/export_row.dart';

/// Hand-rolled RFC-4180 CSV serializer for [ExportRow]s (no `csv` package — the
/// structure is simple enough to build + unit-test directly). Fixed-ASCII,
/// non-localized headers keep the file spreadsheet-portable across locales.
///
/// Lines are `\r\n`-separated (RFC-4180) with no trailing newline; an empty row
/// list still yields a valid header-only file. String cells go through
/// [_escape], which handles both RFC quoting and a spreadsheet formula-injection
/// guard.
class CsvSerializer {
  const CsvSerializer();

  /// Column order is the export schema (§4) — keep in lockstep with [_line].
  static const String _header =
      'date,type,source,account,target_account,category,amount,'
      'planned_status,spending_type,note,receipt_attached,created_at';

  /// Serializes [rows] into a single CSV string (header + one line per row).
  String serialize(List<ExportRow> rows) {
    final buffer = StringBuffer(_header);
    for (final row in rows) {
      buffer
        ..write('\r\n')
        ..write(_line(row));
    }
    return buffer.toString();
  }

  String _line(ExportRow row) => <String>[
    _isoDate(row.date),
    row.type.value,
    row.source.value,
    _escape(row.account),
    _escape(row.targetAccount ?? ''),
    _escape(row.category ?? ''),
    row.amount.toString(),
    row.plannedStatus?.value ?? '',
    row.spendingType?.value ?? '',
    _escape(row.note ?? ''),
    _yesNo(row.receiptAttached),
    _isoDateTime(row.createdAt),
  ].join(',');

  static String _yesNo(bool value) => value ? 'yes' : 'no';

  static String _isoDate(int millis) {
    final d = DateTime.fromMillisecondsSinceEpoch(millis);
    return '${_four(d.year)}-${_two(d.month)}-${_two(d.day)}';
  }

  static String _isoDateTime(int millis) {
    final d = DateTime.fromMillisecondsSinceEpoch(millis);
    return '${_four(d.year)}-${_two(d.month)}-${_two(d.day)} '
        '${_two(d.hour)}:${_two(d.minute)}';
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
  static String _four(int n) => n.toString().padLeft(4, '0');

  /// Escapes one string cell:
  /// 1. **Formula-injection guard** — a leading `= + - @` can execute in a
  ///    spreadsheet, so prefix a single quote.
  /// 2. **RFC-4180 quoting** — if the (guarded) value holds `,` `"` `\n` `\r`,
  ///    wrap it in double-quotes and double any inner quote.
  static String _escape(String raw) {
    var value = raw;
    if (value.isNotEmpty && _formulaLeads.contains(value[0])) {
      value = "'$value";
    }
    if (value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r')) {
      value = '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static const String _formulaLeads = '=+-@';
}
