import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/templates/domain/repositories/tx_template_repository.dart';

/// Loads the Home-favorite templates (`is_favorite = 1`) ordered by
/// `sort_order` — the Home strip + Favorites manage screen. Schedule-only
/// shapes (V2-M5) are excluded.
class GetFavorites extends UseCase<List<TxTemplate>, NoParams> {
  GetFavorites(this._repository);

  final TxTemplateRepository _repository;

  @override
  Future<Either<Failure, List<TxTemplate>>> call(NoParams params) =>
      _repository.getFavorites();
}
