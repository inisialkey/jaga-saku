import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/templates/domain/repositories/tx_template_repository.dart';

/// Hard-deletes a favorite by id. `tx_templates` is a leaf table, so a delete is
/// never FK-blocked (no archive fallback needed).
class DeleteTxTemplate extends UseCase<Unit, int> {
  DeleteTxTemplate(this._repository);

  final TxTemplateRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(int params) =>
      _repository.deleteTemplate(params);
}
