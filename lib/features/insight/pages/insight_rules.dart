import 'package:equatable/equatable.dart';

/// Visual family of a spending-insight card (style guide §13.14) — drives the
/// icon + color the [InsightCard] renders and, in M5, also selects the localized
/// message template (each type is produced by exactly one rule branch below):
///
/// - [warning]  → budget ≥ 80% used (`insightBudgetUsed`)
/// - [critical] → budget ≥ 100% used (`insightBudgetOver`)
/// - [trendUp]  → a category rose ≥ 15% vs last month (`insightCategoryUp`)
/// - [tip]      → unplanned spending is higher than last month (`insightUnplannedUp`)
enum InsightType { warning, trendUp, tip, critical }

/// One fired spending-insight, as **pure data** — no localized text (rule 19 /
/// non-judgmental copy stays in the widget layer via `Strings`). [category] and
/// [pct] are the interpolation params the [InsightCard] feeds into the ARB
/// template chosen by [type].
class InsightItem extends Equatable {
  const InsightItem({required this.type, this.category, this.pct});

  final InsightType type;

  /// Category name for the `{category}` placeholder (budget / trend rules).
  final String? category;

  /// Whole-number percent for the `{pct}` placeholder (budget / trend rules).
  final int? pct;

  @override
  List<Object?> get props => [type, category, pct];
}

/// One budget's live gauge for the budget rule — its category name + how much of
/// the limit is used as a whole-number percent (from `BudgetStatus.percent`,
/// computed by the cubit so this helper stays free of the budget-period clock).
class BudgetGauge extends Equatable {
  const BudgetGauge({required this.categoryName, required this.percent});

  final String categoryName;
  final int percent;

  @override
  List<Object?> get props => [categoryName, percent];
}

/// One expense category's this-month vs last-month totals for the trend rule.
class CategoryTrend extends Equatable {
  const CategoryTrend({
    required this.categoryName,
    required this.current,
    required this.previous,
  });

  final String categoryName;
  final int current;
  final int previous;

  @override
  List<Object?> get props => [categoryName, current, previous];
}

// ── Tunable thresholds (ponytail: named, not magic-inlined) ──────────────────

/// ponytail: surface a budget insight once a budget is ≥ 80% used; tune here.
const int kBudgetWarnPercent = 80;

/// ponytail: use the critical (over-limit) copy at ≥ 100% used.
const int kBudgetOverPercent = 100;

/// ponytail: only flag a category that rose ≥ 15% month-over-month.
const int kCategoryRisePercent = 15;

/// ponytail: ignore trivial risers — the absolute increase must clear Rp10.000
/// so a 500→1.000 jump (+100%) does not produce noise. Raise if still noisy.
const int kCategoryRiseMinIncrease = 10000;

/// Pure spending-insight engine (mirrors the `BudgetStatus` precedent — **no
/// Flutter, no DB**). Applies the three user-approved heuristics to already
/// aggregated inputs and returns only the cards that fire, ordered
/// budget → category → unplanned (the wireframe §4 order). Deterministic:
/// same inputs → same list.
List<InsightItem> computeInsights({
  required List<BudgetGauge> budgets,
  required List<CategoryTrend> categoryTrends,
  required int currentUnplanned,
  required int previousUnplanned,
}) {
  final items = <InsightItem>[];

  final budget = _mostAtRiskBudget(budgets);
  if (budget != null) items.add(budget);

  final riser = _largestRiser(categoryTrends);
  if (riser != null) items.add(riser);

  if (currentUnplanned > previousUnplanned) {
    items.add(const InsightItem(type: InsightType.tip));
  }

  return items;
}

/// Rule 1 — the single most-at-risk budget at ≥ [kBudgetWarnPercent], or null
/// when every budget is comfortably under. Critical copy once ≥
/// [kBudgetOverPercent].
InsightItem? _mostAtRiskBudget(List<BudgetGauge> budgets) {
  BudgetGauge? top;
  for (final b in budgets) {
    if (b.percent < kBudgetWarnPercent) continue;
    if (top == null || b.percent > top.percent) top = b;
  }
  if (top == null) return null;
  return InsightItem(
    type: top.percent >= kBudgetOverPercent
        ? InsightType.critical
        : InsightType.warning,
    category: top.categoryName,
    pct: top.percent,
  );
}

/// Rule 2 — the category with the largest month-over-month rise that clears both
/// the [kCategoryRisePercent] rate and the [kCategoryRiseMinIncrease] amount
/// floor, or null. A brand-new category (previous == 0) has no meaningful
/// percentage, so it is excluded (ponytail: MoM % is undefined at 0 — a "new
/// category" insight is a V2 idea).
InsightItem? _largestRiser(List<CategoryTrend> trends) {
  InsightItem? best;
  var bestPct = 0;
  var bestIncrease = 0;
  for (final t in trends) {
    if (t.previous <= 0 || t.current <= t.previous) continue;
    final increase = t.current - t.previous;
    if (increase < kCategoryRiseMinIncrease) continue;
    final pct = (increase / t.previous * 100).round();
    if (pct < kCategoryRisePercent) continue;
    final wins =
        best == null ||
        pct > bestPct ||
        (pct == bestPct && increase > bestIncrease);
    if (wins) {
      best = InsightItem(
        type: InsightType.trendUp,
        category: t.categoryName,
        pct: pct,
      );
      bestPct = pct;
      bestIncrease = increase;
    }
  }
  return best;
}
