import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';

/// Contract for transaction-template (favorite) persistence. Implemented in the
/// data layer; every method returns `Either<Failure, T>` — the repository never
/// throws (rule 4).
abstract class TxTemplateRepository {
  /// Home-favorite templates (`is_favorite = 1`) ordered by `sort_order`.
  Future<Either<Failure, List<TxTemplate>>> getFavorites();

  /// Inserts (when [TxTemplate.id] is null) or updates the template. Returns the
  /// row id.
  Future<Either<Failure, int>> saveTemplate(TxTemplate template);

  /// Hard-deletes the template (`tx_templates` is a leaf table — never
  /// FK-blocked).
  Future<Either<Failure, Unit>> deleteTemplate(int id);

  /// Persists a new ordering — `sort_order` becomes each id's index.
  Future<Either<Failure, Unit>> reorderTemplates(List<int> orderedIds);
}
