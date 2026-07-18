import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_config.dart';
import 'package:jaga_saku/features/reminders/domain/usecases/check_budget_warnings.dart';

/// [CheckBudgetWarnings]: reuses `BudgetStatus` thresholds (warning >= 0.8,
/// critical >= 1.0, decision 2) to surface every un-warned crossing, deduped by
/// `{budgetId, period, level}`. Pure — no mocks, no plugin.
void main() {
  const usecase = CheckBudgetWarnings();
  final now = DateTime(2026, 7, 18, 10);

  // limitAmount/spent drive the ratio (level); periodStart/periodEnd only feed
  // safe-daily, so a wide window keeps every fixture in its current cycle.
  Budget budget({
    required int spent,
    int? id = 1,
    int categoryId = 7,
    int limitAmount = 100,
    String period = '2026-07',
  }) => Budget(
    id: id,
    categoryId: categoryId,
    period: period,
    limitAmount: limitAmount,
    spent: spent,
    periodStart: DateTime(2026, 7).millisecondsSinceEpoch,
    periodEnd: DateTime(2026, 8).millisecondsSinceEpoch,
  );

  test('disabled → no warnings even when over budget', () {
    final warnings = usecase(
      enabled: false,
      budgets: [budget(spent: 110)],
      now: now,
      warnedMarkers: const {},
    );
    expect(warnings, isEmpty);
  });

  test('ratio 0.85 → one warning-level crossing', () {
    final warnings = usecase(
      enabled: true,
      budgets: [budget(spent: 85)],
      now: now,
      warnedMarkers: const {},
    );
    expect(warnings, hasLength(1));
    expect(warnings.single.level, BudgetStatusLevel.warning);
    expect(warnings.single.budgetId, 1);
    expect(warnings.single.categoryId, 7);
    expect(
      warnings.single.markerKey,
      ReminderConfig.budgetMarkerKey(1, '2026-07', BudgetStatusLevel.warning),
    );
  });

  test('ratio 1.10 → one critical-level crossing', () {
    final warnings = usecase(
      enabled: true,
      budgets: [budget(spent: 110)],
      now: now,
      warnedMarkers: const {},
    );
    expect(warnings, hasLength(1));
    expect(warnings.single.level, BudgetStatusLevel.critical);
    expect(
      warnings.single.markerKey,
      ReminderConfig.budgetMarkerKey(1, '2026-07', BudgetStatusLevel.critical),
    );
  });

  test('ratio 0.5 → safe → no warning', () {
    final warnings = usecase(
      enabled: true,
      budgets: [budget(spent: 50)],
      now: now,
      warnedMarkers: const {},
    );
    expect(warnings, isEmpty);
  });

  test('already-marked crossing is not re-emitted (no duplicate)', () {
    final marker = ReminderConfig.budgetMarkerKey(
      1,
      '2026-07',
      BudgetStatusLevel.critical,
    );
    final warnings = usecase(
      enabled: true,
      budgets: [budget(spent: 110)],
      now: now,
      warnedMarkers: {marker},
    );
    expect(warnings, isEmpty);
  });

  test('null id is skipped (unpersisted / degenerate row)', () {
    final warnings = usecase(
      enabled: true,
      budgets: [budget(id: null, spent: 110)],
      now: now,
      warnedMarkers: const {},
    );
    expect(warnings, isEmpty);
  });

  test('warning and critical budgets both surface, deduped independently', () {
    final warnings = usecase(
      enabled: true,
      budgets: [budget(spent: 85), budget(id: 2, categoryId: 9, spent: 120)],
      now: now,
      warnedMarkers: const {},
    );
    expect(warnings, hasLength(2));
    expect(warnings[0].level, BudgetStatusLevel.warning);
    expect(warnings[1].level, BudgetStatusLevel.critical);
  });
}
