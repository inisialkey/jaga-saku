import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_data.freezed.dart';

/// The seven local tables as raw DAO row maps — the pass-through payload of a
/// backup. Column conventions are preserved verbatim: money = `int` rupiah,
/// dates = `int` millis, colors = `int` ARGB, bools = `int` 1/0. Values are
/// `Object?` (never `dynamic`, rule 2) and are NEVER re-mapped to Dart types —
/// each row must round-trip byte-identically so restore can re-insert with the
/// original primary keys and referential integrity intact.
///
/// Freezed generates `==`/`hashCode` with `DeepCollectionEquality` over these
/// collection fields, so a decode→encode round-trip compares equal in tests.
@freezed
abstract class BackupData with _$BackupData {
  const factory BackupData({
    @Default(<Map<String, Object?>>[]) List<Map<String, Object?>> settings,
    @Default(<Map<String, Object?>>[]) List<Map<String, Object?>> accounts,
    @Default(<Map<String, Object?>>[]) List<Map<String, Object?>> categories,
    @Default(<Map<String, Object?>>[]) List<Map<String, Object?>> transactions,
    @Default(<Map<String, Object?>>[]) List<Map<String, Object?>> budgets,
    @Default(<Map<String, Object?>>[]) List<Map<String, Object?>> txTemplates,
    @Default(<Map<String, Object?>>[]) List<Map<String, Object?>> recurring,
  }) = _BackupData;
}
