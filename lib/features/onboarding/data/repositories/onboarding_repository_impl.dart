import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:jaga_saku/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:jaga_saku/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Folds every datasource call to `Either<Failure, T>` and never throws
/// (rule 4) — the `SecurityRepositoryImpl` shape.
///
/// Deliberately does NOT ping `TxChangeNotifier`: onboarding settings are not a
/// derived money view. Account creation already pings it through
/// `AccountRepositoryImpl._guardWrite`.
class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._datasource);

  final OnboardingLocalDatasource _datasource;

  @override
  Future<Either<Failure, OnboardingProgress>> getProgress() =>
      _guard(_datasource.readProgress);

  @override
  Future<Either<Failure, Unit>> setStep(OnboardingStep step) =>
      _guard(() async {
        await _datasource.writeStep(step);
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> markQuickStartSelected() => _guard(() async {
    await _datasource.writeQuickStartSelected();
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> complete() => _guard(() async {
    await _datasource.writeCompleted();
    return unit;
  });

  /// Runs [action], mapping any thrown error to a logged [CacheFailure] so the
  /// UI only ever sees a localized [Failure] (rule 4 / rule 17).
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } catch (e, s) {
      log.e('Onboarding failure', error: e, stackTrace: s);
      return const Left(CacheFailure());
    }
  }
}
