import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_file.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_preview.dart';

/// Contract for backup export / validation / restore. Implemented in the data
/// layer; every method returns `Either<Failure, T>` — the repository never
/// throws (rule 4).
abstract class BackupRepository {
  /// Reads all seven tables and serializes them into a [BackupFile] envelope
  /// (its `schemaVersion` bound to `Migrations.latestVersion`).
  Future<Either<Failure, BackupFile>> export();

  /// Parses + validates a picked file's [rawJson]. `Right(BackupData)` when it
  /// is a restorable Jaga Saku backup; `Left(BackupFailure)` with the mapped
  /// reason otherwise.
  Future<Either<Failure, BackupData>> validate(String rawJson);

  /// Atomically full-replaces the database with [data] (all-or-nothing — any
  /// failure rolls back and leaves the DB unchanged). Returns the restored
  /// [BackupPreview] counts.
  Future<Either<Failure, BackupPreview>> restore(BackupData data);
}
