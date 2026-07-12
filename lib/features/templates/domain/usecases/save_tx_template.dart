import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/templates/domain/repositories/tx_template_repository.dart';

/// Creates or updates a favorite (insert when [TxTemplate.id] is null). Returns
/// the row id.
class SaveTxTemplate extends UseCase<int, TxTemplate> {
  SaveTxTemplate(this._repository);

  final TxTemplateRepository _repository;

  @override
  Future<Either<Failure, int>> call(TxTemplate params) =>
      _repository.saveTemplate(params);
}
