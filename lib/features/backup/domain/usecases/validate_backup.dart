import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';
import 'package:jaga_saku/features/backup/domain/repositories/backup_repository.dart';

/// Parses + validates a picked file's raw JSON into a restorable [BackupData],
/// or a `Left(BackupFailure)` describing why it can't be restored.
class ValidateBackup extends UseCase<BackupData, String> {
  ValidateBackup(this._repository);

  final BackupRepository _repository;

  @override
  Future<Either<Failure, BackupData>> call(String params) =>
      _repository.validate(params);
}
