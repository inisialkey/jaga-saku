import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:jaga_saku/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

/// Rule 4: a throwing datasource becomes `Left(CacheFailure())` on every
/// method — the repository never lets a raw exception reach the UI.
void main() {
  setUpAll(registerFallbackValues);

  late MockOnboardingLocalDatasource datasource;
  late OnboardingRepositoryImpl repository;

  setUp(() {
    datasource = MockOnboardingLocalDatasource();
    repository = OnboardingRepositoryImpl(datasource);
  });

  test('getProgress passes the datasource value through as a Right', () async {
    when(() => datasource.readProgress()).thenAnswer(
      (_) async => const OnboardingProgress(step: OnboardingStep.accounts),
    );

    final result = await repository.getProgress();

    expect(
      result,
      const Right<Failure, OnboardingProgress>(
        OnboardingProgress(step: OnboardingStep.accounts),
      ),
    );
  });

  test('the three writers return Right(unit)', () async {
    when(() => datasource.writeStep(any())).thenAnswer((_) async {});
    when(() => datasource.writeQuickStartSelected()).thenAnswer((_) async {});
    when(() => datasource.writeCompleted()).thenAnswer((_) async {});

    expect(await repository.setStep(OnboardingStep.value), const Right(unit));
    expect(await repository.markQuickStartSelected(), const Right(unit));
    expect(await repository.complete(), const Right(unit));
  });

  test(
    'every method maps a throwing datasource to Left(CacheFailure)',
    () async {
      when(() => datasource.readProgress()).thenThrow(Exception('boom'));
      when(() => datasource.writeStep(any())).thenThrow(Exception('boom'));
      when(
        () => datasource.writeQuickStartSelected(),
      ).thenThrow(Exception('boom'));
      when(() => datasource.writeCompleted()).thenThrow(Exception('boom'));

      const left = Left<Failure, Never>(CacheFailure());
      expect(await repository.getProgress(), left);
      expect(await repository.setStep(OnboardingStep.value), left);
      expect(await repository.markQuickStartSelected(), left);
      expect(await repository.complete(), left);
    },
  );
}
