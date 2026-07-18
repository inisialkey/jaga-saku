import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_config.dart';
import 'package:jaga_saku/features/reminders/domain/entities/reminder_decisions.dart';

/// PURE decision (rule 19): reuse `BudgetStatus` to find every budget that has
/// crossed a warning boundary (80% `warning` / 100% `critical`, decision 2) and
/// has NOT already been notified for that `{budgetId, period, level}`. The
/// feature owns NO threshold math — it reads `BudgetStatus.compute` verbatim, so
/// the boundaries stay the single source of truth.
class CheckBudgetWarnings {
  const CheckBudgetWarnings();

  List<BudgetWarning> call({
    required bool enabled,
    required List<Budget> budgets,
    required DateTime now,
    required Set<String> warnedMarkers,
  }) {
    if (!enabled) return const [];
    final out = <BudgetWarning>[];
    for (final budget in budgets) {
      final id = budget.id;
      if (id == null) continue; // unpersisted / degenerate row — nothing to id
      final level = BudgetStatus.compute(
        limitAmount: budget.limitAmount,
        spent: budget.spent,
        now: now,
        periodStart: budget.periodStart,
        periodEnd: budget.periodEnd,
      ).level;
      if (level == BudgetStatusLevel.safe) continue;
      final key = ReminderConfig.budgetMarkerKey(id, budget.period, level);
      if (warnedMarkers.contains(key)) continue; // already warned this period
      out.add(
        BudgetWarning(
          budgetId: id,
          categoryId: budget.categoryId,
          level: level,
          markerKey: key,
        ),
      );
    }
    return out;
  }
}
