import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/security/domain/repositories/security_repository.dart';

/// Overwrites the stored PIN — the caller has already verified the current one.
class ChangePin extends UseCase<Unit, String> {
  ChangePin(this._repository);

  final SecurityRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String params) =>
      _repository.changePin(params);
}
