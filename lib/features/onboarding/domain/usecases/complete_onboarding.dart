import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Sets the completion marker — the single write that releases the router gate.
/// Only *Start Tracking* on the summary calls it (§14): onboarding is never
/// marked complete early.
class CompleteOnboarding extends UseCase<Unit, NoParams> {
  CompleteOnboarding(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) => _repository.complete();
}
