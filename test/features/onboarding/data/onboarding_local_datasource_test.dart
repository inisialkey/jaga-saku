import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:jaga_saku/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

/// The settings-kv encoding. The key strings are asserted as LITERALS on
/// purpose: they are PRIMARY KEYs in the `settings` table, so a rename would
/// orphan every existing install's row — this test is what makes that fail CI
/// instead of failing silently in the field.
void main() {
  const kCompleted = 'onboarding_completed';
  const kStep = 'onboarding_step';
  const kQuickStart = 'onboarding_quick_start';

  late MockSettingsService settings;
  late OnboardingLocalDatasource datasource;

  void stub(String key, String? value) =>
      when(() => settings.getString(key)).thenAnswer((_) async => value);

  setUp(() {
    settings = MockSettingsService();
    datasource = OnboardingLocalDatasource(settings);
    when(() => settings.setString(any(), any())).thenAnswer((_) async {});
    for (final key in [kCompleted, kStep, kQuickStart]) {
      stub(key, null);
    }
  });

  test('all keys absent → the fresh-install defaults', () async {
    expect(await datasource.readProgress(), const OnboardingProgress());
  });

  test("'1' reads as true for both booleans", () async {
    stub(kCompleted, '1');
    stub(kQuickStart, '1');
    stub(kStep, 'summary');

    expect(
      await datasource.readProgress(),
      const OnboardingProgress(
        completed: true,
        step: OnboardingStep.summary,
        quickStartSelected: true,
      ),
    );
  });

  test('anything but 1 reads as false', () async {
    stub(kCompleted, '0');
    stub(kQuickStart, 'true');

    final progress = await datasource.readProgress();

    expect(progress.completed, isFalse);
    expect(progress.quickStartSelected, isFalse);
  });

  test('an unknown / legacy step name falls back to welcome', () async {
    stub(kStep, 'currency'); // a step this milestone dropped

    expect((await datasource.readProgress()).step, OnboardingStep.welcome);
  });

  test('writeStep persists the enum NAME, never its index', () async {
    await datasource.writeStep(OnboardingStep.accounts);

    verify(() => settings.setString(kStep, 'accounts')).called(1);
  });

  test('writeQuickStartSelected persists 1', () async {
    await datasource.writeQuickStartSelected();

    verify(() => settings.setString(kQuickStart, '1')).called(1);
  });

  test('writeCompleted persists 1 under the shared key', () async {
    await datasource.writeCompleted();

    verify(() => settings.setString(kCompleted, '1')).called(1);
  });
}
