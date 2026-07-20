import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:jaga_saku/features/onboarding/onboarding_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

/// The gate's ChangeNotifier: the cold-start read, the Left→fail-open posture,
/// and — the load-bearing one — that nothing but [OnboardingService.markCompleted]
/// ever notifies the router.
void main() {
  setUpAll(registerFallbackValues);

  late MockGetOnboardingProgress getProgress;

  OnboardingService build() => OnboardingService(getProgress: getProgress);

  void stubProgress(OnboardingProgress progress) =>
      when(() => getProgress(any())).thenAnswer((_) async => Right(progress));

  setUp(() {
    getProgress = MockGetOnboardingProgress();
    stubProgress(const OnboardingProgress());
  });

  test('load on a fresh install reads incomplete and notifies once', () async {
    final service = build();
    var notified = 0;
    service.addListener(() => notified++);

    await service.load();

    expect(service.isCompleted, isFalse);
    expect(notified, 1);
  });

  test('load carries the persisted progress through', () async {
    stubProgress(
      const OnboardingProgress(
        step: OnboardingStep.summary,
        quickStartSelected: true,
      ),
    );
    final service = build();

    await service.load();

    expect(service.progress.step, OnboardingStep.summary);
    expect(service.progress.quickStartSelected, isTrue);
    expect(service.isCompleted, isFalse);
  });

  // A storage fault must never lock a user out of their own data. A fresh
  // install is NOT this case — an absent key is a Right(completed: false).
  test('load on a Left FAILS OPEN — treated as already onboarded', () async {
    when(
      () => getProgress(any()),
    ).thenAnswer((_) async => const Left(CacheFailure()));
    final service = build();

    await service.load();

    expect(service.isCompleted, isTrue);
  });

  test('markCompleted flips the gate and notifies', () async {
    final service = build();
    await service.load();
    var notified = 0;
    service.addListener(() => notified++);

    service.markCompleted();

    expect(service.isCompleted, isTrue);
    expect(notified, 1);
  });

  test('markCompleted twice notifies only once', () async {
    final service = build();
    await service.load();
    var notified = 0;
    service.addListener(() => notified++);

    service
      ..markCompleted()
      ..markCompleted();

    expect(notified, 1);
  });

  // Regression tripwire, mirroring `app_lock_service_test.dart:46`. A router
  // refresh re-parses the stack from the ENCODED route state and drops any
  // non-JSON `extra` (no extraCodec is configured). During onboarding the user
  // can be standing on /accounts/form, whose `extra` carries the suggested-chip
  // prefill Account — a spurious notify would blank it mid-typing. The service
  // therefore exposes no step mutator at all: markCompleted is the only
  // notifying transition after load().
  test(
    'the service never notifies for a step change — /accounts/form extra survives',
    () async {
      stubProgress(const OnboardingProgress(step: OnboardingStep.accounts));
      final service = build();
      await service.load();
      var notified = 0;
      service.addListener(() => notified++);

      // A step change is internal PageView + cubit state; the gate input the
      // router reads is only `isCompleted`, which has not moved.
      stubProgress(const OnboardingProgress(step: OnboardingStep.summary));

      expect(service.progress.step, OnboardingStep.accounts);
      expect(notified, 0);
      // If a future change adds a step setter that notifies, this assertion is
      // what should be made to fail — do not delete it, fix the setter.
      expect(service.isCompleted, isFalse);
    },
  );
}
