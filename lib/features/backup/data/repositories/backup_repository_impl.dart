import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/features/backup/data/datasources/backup_local_datasource.dart';
import 'package:jaga_saku/features/backup/data/models/backup_serializer.dart';
import 'package:jaga_saku/features/backup/data/models/backup_validator.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_file.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_preview.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_validation.dart';
import 'package:jaga_saku/features/backup/domain/repositories/backup_repository.dart';
import 'package:sqflite/sqflite.dart';

/// Wraps [BackupLocalDatasource] plus the pure serializer/validator and never
/// throws: every datasource call is guarded and mapped to `Right`/`Left(Failure)`
/// (rule 4). Validation reasons map to a typed [BackupFailure] so the cubit can
/// localize a friendly message (rule 17); `schemaVersion` binds to
/// `Migrations.latestVersion`, never a literal.
class BackupRepositoryImpl implements BackupRepository {
  BackupRepositoryImpl(this._datasource);

  final BackupLocalDatasource _datasource;
  final BackupSerializer _serializer = const BackupSerializer();
  final BackupValidator _validator = const BackupValidator();

  @override
  Future<Either<Failure, BackupFile>> export() => _guard(() async {
    final tables = await _datasource.readAllTables();
    final data = BackupData(
      settings: tables['settings']!,
      accounts: tables['accounts']!,
      categories: tables['categories']!,
      transactions: tables['transactions']!,
      budgets: tables['budgets']!,
      txTemplates: tables['tx_templates']!,
      recurring: tables['recurring']!,
    );
    final exportedAt = DateTime.now().millisecondsSinceEpoch;
    return BackupFile(
      schemaVersion: Migrations.latestVersion,
      exportedAt: exportedAt,
      itemCount: _itemCount(data),
      content: _serializer.encode(
        schemaVersion: Migrations.latestVersion,
        exportedAt: exportedAt,
        data: data,
      ),
    );
  });

  @override
  Future<Either<Failure, BackupData>> validate(String rawJson) async {
    final result = _validator.validate(rawJson);
    return switch (result.reason) {
      BackupValidationReason.ok => Right<Failure, BackupData>(result.data!),
      BackupValidationReason.notJson ||
      BackupValidationReason.missingEnvelope => const Left<Failure, BackupData>(
        BackupFailure(BackupFailureReason.invalidFile),
      ),
      BackupValidationReason.unsupportedSchemaVersion =>
        const Left<Failure, BackupData>(
          BackupFailure(BackupFailureReason.unsupportedVersion),
        ),
      BackupValidationReason.corruptData => const Left<Failure, BackupData>(
        BackupFailure(BackupFailureReason.corrupt),
      ),
    };
  }

  @override
  Future<Either<Failure, BackupPreview>> restore(BackupData data) =>
      _guard(() async {
        await _datasource.restore(data);
        return _previewOf(data);
      });

  BackupPreview _previewOf(BackupData d) => BackupPreview(
    accounts: d.accounts.length,
    transactions: d.transactions.length,
    categories: d.categories.length,
    budgets: d.budgets.length,
    recurring: d.recurring.length,
    templates: d.txTemplates.length,
    settings: d.settings.length,
  );

  int _itemCount(BackupData d) =>
      d.settings.length +
      d.accounts.length +
      d.categories.length +
      d.transactions.length +
      d.budgets.length +
      d.txTemplates.length +
      d.recurring.length;

  /// Runs [action], mapping any failure to a [Failure]. Errors are logged (not
  /// surfaced raw) so the UI only ever sees a localized [Failure] (rule 4/17).
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on DatabaseException catch (e, s) {
      log.e('Backup DB failure', error: e, stackTrace: s);
      return const Left(CacheFailure());
    } catch (e, s) {
      log.e('Backup failure', error: e, stackTrace: s);
      return const Left(CacheFailure());
    }
  }
}
