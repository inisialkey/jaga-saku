import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/onboarding/domain/entities/onboarding_progress.dart';

/// Read/write contract for the onboarding `settings` kv rows (V5-M1). Every
/// method returns `Either<Failure, T>` — the impl never throws (rule 4).
abstract class OnboardingRepository {
  Future<Either<Failure, OnboardingProgress>> getProgress();

  Future<Either<Failure, Unit>> setStep(OnboardingStep step);

  Future<Either<Failure, Unit>> markQuickStartSelected();

  Future<Either<Failure, Unit>> complete();
}
