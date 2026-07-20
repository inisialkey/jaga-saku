import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:jaga_saku/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Loads the persisted onboarding progress. Read by `OnboardingService.load()`
/// (the router gate's input) and by `OnboardingCubit.load()` (to resume at the
/// last step).
class GetOnboardingProgress extends UseCase<OnboardingProgress, NoParams> {
  GetOnboardingProgress(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, OnboardingProgress>> call(NoParams params) =>
      _repository.getProgress();
}
