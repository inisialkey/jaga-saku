import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Records that the user took the Quick Start escape hatch. Not derivable from
/// the DB (a Quick-Start Cash account looks identical to a hand-made one), which
/// is why it is persisted at all.
class MarkQuickStartSelected extends UseCase<Unit, NoParams> {
  MarkQuickStartSelected(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) =>
      _repository.markQuickStartSelected();
}
