import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_preview.dart';
import 'package:jaga_saku/features/backup/domain/repositories/backup_repository.dart';

/// Atomically full-replaces the database with a validated [BackupData], returning
/// the restored [BackupPreview] counts. The cubit writes a safety backup first.
class RestoreBackup extends UseCase<BackupPreview, BackupData> {
  RestoreBackup(this._repository);

  final BackupRepository _repository;

  @override
  Future<Either<Failure, BackupPreview>> call(BackupData params) =>
      _repository.restore(params);
}
