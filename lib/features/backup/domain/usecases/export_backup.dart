import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_file.dart';
import 'package:jaga_saku/features/backup/domain/repositories/backup_repository.dart';

/// Serializes the whole database into a [BackupFile] envelope. Also invoked as
/// the mandatory safety-backup immediately before a destructive restore.
class ExportBackup extends UseCase<BackupFile, NoParams> {
  ExportBackup(this._repository);

  final BackupRepository _repository;

  @override
  Future<Either<Failure, BackupFile>> call(NoParams params) =>
      _repository.export();
}
