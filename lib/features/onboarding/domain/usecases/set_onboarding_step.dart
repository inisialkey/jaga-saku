import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:jaga_saku/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Persists the current step so a kill-and-relaunch mid-flow resumes where the
/// user left off (§14).
class SetOnboardingStep extends UseCase<Unit, OnboardingStep> {
  SetOnboardingStep(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(OnboardingStep params) =>
      _repository.setStep(params);
}
