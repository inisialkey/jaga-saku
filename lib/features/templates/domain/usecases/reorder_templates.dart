import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/templates/domain/repositories/tx_template_repository.dart';

/// Persists a new favorite ordering — each id's `sort_order` becomes its index
/// in [call]'s list.
class ReorderTemplates extends UseCase<Unit, List<int>> {
  ReorderTemplates(this._repository);

  final TxTemplateRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(List<int> params) =>
      _repository.reorderTemplates(params);
}
