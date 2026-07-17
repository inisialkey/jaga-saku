import 'dart:convert';

import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';

/// Encodes a [BackupData] into the on-disk JSON envelope and decodes it back.
/// The envelope's `data` keys are the **snake_case table names** (so restore
/// iterates table→rows directly), while [BackupData]'s Dart fields are
/// camelCase — this class is the single place the two naming schemes are mapped.
///
/// Pure + `const` (no DI): the repository owns a `const BackupSerializer()`.
class BackupSerializer {
  const BackupSerializer();

  static const String appName = 'Jaga Saku';

  /// Builds the `{app, schemaVersion, exportedAt, data{...}}` envelope and
  /// serializes it to JSON text ready to write to disk.
  String encode({
    required int schemaVersion,
    required int exportedAt,
    required BackupData data,
  }) => jsonEncode(<String, Object?>{
    'app': appName,
    'schemaVersion': schemaVersion,
    'exportedAt': exportedAt,
    'data': <String, Object?>{
      'settings': data.settings,
      'accounts': data.accounts,
      'categories': data.categories,
      'transactions': data.transactions,
      'budgets': data.budgets,
      'tx_templates': data.txTemplates,
      'recurring': data.recurring,
    },
  });

  /// Parses JSON text into the envelope record. Throws `FormatException` /
  /// `TypeError` on malformed input — `BackupValidator` catches and classifies.
  ({int schemaVersion, int exportedAt, BackupData data}) decode(String json) =>
      decodeEnvelope(jsonDecode(json) as Map<String, Object?>);

  /// Builds the envelope record from an already-decoded map. Lets the validator
  /// reuse the map it parsed for structural checks — no second `jsonDecode`.
  ({int schemaVersion, int exportedAt, BackupData data}) decodeEnvelope(
    Map<String, Object?> map,
  ) {
    final data = map['data']! as Map<String, Object?>;
    return (
      schemaVersion: map['schemaVersion']! as int,
      exportedAt: map['exportedAt']! as int,
      data: BackupData(
        settings: _rows(data['settings']),
        accounts: _rows(data['accounts']),
        categories: _rows(data['categories']),
        transactions: _rows(data['transactions']),
        budgets: _rows(data['budgets']),
        txTemplates: _rows(data['tx_templates']),
        recurring: _rows(data['recurring']),
      ),
    );
  }

  /// Casts a JSON array of objects to typed row maps; a missing table key
  /// defaults to an empty list (tolerant of older / partial envelopes).
  List<Map<String, Object?>> _rows(Object? value) =>
      ((value as List<Object?>?) ?? const [])
          .map((e) => Map<String, Object?>.from(e! as Map))
          .toList();
}
