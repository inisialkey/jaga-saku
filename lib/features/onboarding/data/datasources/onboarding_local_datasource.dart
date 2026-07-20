import 'package:jaga_saku/core/utils/services/settings/settings_keys.dart';
import 'package:jaga_saku/core/utils/services/settings/settings_service.dart';
import 'package:jaga_saku/features/onboarding/domain/entities/onboarding_progress.dart';

/// Settings-kv wrapper for onboarding state (V5-M1). No new table, no schema
/// migration — same shape as `ReminderLocalDatasource`. Booleans encode as
/// `'1'` (the `PinSecureDatasource` convention); an absent key reads false.
///
/// [SettingsKeys.onboardingCompleted] is shared with
/// `Migrations.grandfatherOnboarding`; the other two keys are private to this
/// feature and, like every `settings` key, are PRIMARY KEYS — never rename.
class OnboardingLocalDatasource {
  OnboardingLocalDatasource(this._settings);

  final SettingsService _settings;

  static const String _kStep = 'onboarding_step';
  static const String _kQuickStart = 'onboarding_quick_start';

  /// Reads all three keys into an [OnboardingProgress]. Every absent key falls
  /// back to the entity default, so a fresh DB reads as "not started, step 1".
  Future<OnboardingProgress> readProgress() async {
    final completed = await _settings.getString(
      SettingsKeys.onboardingCompleted,
    );
    final step = await _settings.getString(_kStep);
    final quickStart = await _settings.getString(_kQuickStart);
    return OnboardingProgress(
      completed: completed == '1',
      step: OnboardingStep.fromName(step),
      quickStartSelected: quickStart == '1',
    );
  }

  /// Persists the step by [OnboardingStep.name] — never its index, so
  /// reordering the enum can't corrupt a resumed session.
  Future<void> writeStep(OnboardingStep step) =>
      _settings.setString(_kStep, step.name);

  Future<void> writeQuickStartSelected() =>
      _settings.setString(_kQuickStart, '1');

  Future<void> writeCompleted() =>
      _settings.setString(SettingsKeys.onboardingCompleted, '1');
}
