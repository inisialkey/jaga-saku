import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_file.freezed.dart';

/// The export artifact returned by `ExportBackup`: the fully-serialized JSON
/// envelope text ([content], ready to write to disk) plus its metadata. The
/// cubit writes [content] to a file and hands the resulting path to the share
/// sheet.
@freezed
abstract class BackupFile with _$BackupFile {
  const factory BackupFile({
    /// DB schema the backup was written against — bound to
    /// `Migrations.latestVersion`, never a literal.
    required int schemaVersion,

    /// Epoch millis the export ran; drives the filename + last-export metadata.
    required int exportedAt,

    /// Total rows across all seven tables (surfaced as "N items").
    required int itemCount,

    /// The serialized JSON envelope text, ready to persist to disk.
    required String content,
  }) = _BackupFile;
}
