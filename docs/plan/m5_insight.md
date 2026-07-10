# M5 — Insight

Fifth domain milestone. Builds the **Insight** tab — the app's "insight-first" identity: not just a report, but a friendly read on spending habits. Presentation-only over transactions + budgets (no new table/datasource), mirroring the `home/`/`calendar/` orchestration pattern. Source of truth = `docs/jaga_saku_low_fidelity_wireframe.md` §4 + `docs/jaga_saku_ui_design.md` screen 4 + `docs/jaga_saku_ui_style_guide.md` §14 (charts) + §13.14 (insight card) + `docs/Jaga Saku Mockup.png` screen 4.

**Build-order context:** M0 ✓ → M1 ✓ → M2 ✓ → M3 ✓ → M4 ✓ → **M5 Insight** → M6 More/Settings.

**User-approved scope:** the **3 wireframe insight heuristics incl. month-over-month** · **per-section empty states**.

**Definition of done:** `flutter analyze` = 0, `dart format` clean, build_runner green, ARB id/en parity, coverage ≥40%. The Insight tab (with a month selector) shows: Monthly Overview (income/expense/saved), Expense-by-Category donut + legend, Planned vs Unplanned, Need vs Want, and rule-based Spending-Insight cards. Each section has a friendly empty state when the month has no relevant data. Insight refreshes live when transactions/budgets change.

---

## 1. Dependencies
**None.** `fl_chart ^1.1.1` is already in pubspec (M0). Reuses `ProgressBarX`, `MoneyText`, `AppCard`, `SectionHeader`, `CategoryIconAvatar`, `EmptyStateView`, `context.colors`, `TxChangeNotifier`, and the existing usecases (`GetTransactionsByMonth`, `GetCategories`, `GetBudgetsForPeriod`).

---

## 2. Insight feature (`lib/features/insight/pages/`) — presentation-only

Like `home/`, Insight adds **no** domain/data layer; it orchestrates existing usecases and computes a view-model in Dart. Replace the M0 `PlaceholderView` (`insight_page.dart` → move under `pages/`).

```
lib/features/insight/pages/
├── insight_cubit.dart     # orchestrates GetTransactionsByMonth(current & previous) + GetCategories + GetBudgetsForPeriod(current)
├── insight_state.dart     # @freezed: initial | loading | loaded(InsightReport) | error(Failure)
├── insight_page.dart
└── widgets/ expense_donut_chart.dart · monthly_overview_card.dart · category_legend.dart · planned_unplanned_card.dart · need_want_card.dart · insight_card.dart
```

- **`InsightCubit(this._getTransactionsByMonth, this._getCategories, this._getBudgetsForPeriod, this._txChanges)`** — holds `focusedMonth` (default current). `load(month)`:
  1. `GetTransactionsByMonth(month)` + `GetTransactionsByMonth(prevMonth)` (for MoM), `GetCategories(expense/income)`, `GetBudgetsForPeriod(period(month))`.
  2. Compute an **`InsightReport`** (freezed view-model):
     - **overview:** `income`, `expense`, `saved = income − expense` (transfers excluded).
     - **expenseByCategory:** `List<CategorySlice>{categoryId, name, color, amount, pct}` — sum current-month **expense** per category, sort desc, `pct = amount/totalExpense`. Drives the donut + legend.
     - **plannedVsUnplanned:** `{planned, unplanned, plannedPct, unplannedPct}` over expenses that have a `plannedStatus` (null-status expenses excluded from the split — note it; base pct on the typed subset).
     - **needVsWant:** `Map<SpendingType, {amount, pct}>` over expenses with a `spendingType` (need/want/lifestyle/emergency; nulls excluded).
     - **insights:** `List<InsightItem>` from §3 (only rules that fire).
     - `categoriesById` map for name/color resolution.
  3. Subscribe to `_txChanges.changes` → `load(focusedMonth)`; cancel in `close()` (rule 7); `isClosed`-guard.
- **Month selector:** prev/next + current; default current month. **Reuse the M4 `MonthSelector`** — promote it from `lib/features/budgets/pages/widgets/month_selector.dart` to `lib/core/widgets/` (shared by Budget + Insight; update the budget import + `widgets.dart` barrel).

---

## 3. Spending-Insight heuristics (the differentiator — §user-approved: 3 rules + MoM)

Each produces an `InsightItem{ type, text }` **only when it fires** (no card otherwise); `InsightType { warning, trendUp, tip, positive, critical }` → icon+color per style guide §13.14 (warning=orange, trendUp=blue/info, tip=info/lightbulb, positive/success=green, critical=red). Non-judgmental copy (style guide §23 — help, don't blame).

1. **Budget near/over limit (warning/critical):** using `GetBudgetsForPeriod` + `BudgetStatus`, if any budget is ≥ warning (≥80%), surface the **most-at-risk**: "Budget {kategori} sudah terpakai {pct}% bulan ini." (critical copy if ≥100%: "…melebihi batas.").
2. **Category up vs last month (trendUp):** for each expense category, compare this month vs previous; pick the **largest riser** with increase ≥ **15%** and a non-trivial amount → "Pengeluaran {kategori} naik {pct}% dibanding bulan lalu."
3. **Unplanned higher than last month (tip):** if this month's unplanned expense total > last month's → "Unplanned expense bulan ini lebih tinggi dari bulan lalu." (If lower/equal, optionally a `positive` "Unplanned kamu lebih terkendali dari bulan lalu." — optional; keep to the 3 core rules if simpler.)

Thresholds (80% / 15% / any-increase) are `// ponytail:`-commented constants — tunable, not magic-inlined. Put the rule logic in a small pure helper (`insight_rules.dart`, pure Dart, unit-tested) so it's testable without widgets — mirrors the `BudgetStatus` precedent.

---

## 4. Charts & cards (`insight/pages/widgets/`) — style guide §14, §13.14

- **`ExpenseDonutChart`** — the ONE real chart: `fl_chart` `PieChart` with a center hole (donut), one section per `CategorySlice` in the category's color, optional center total label. Below it, a `CategoryLegend` list (`CategoryIconAvatar` + name + `MoneyText` + pct). Empty (no expense) → `EmptyStateView` ("Belum ada pengeluaran bulan ini").
- **`PlannedUnplannedCard`** — two labelled `ProgressBarX` rows (planned green, unplanned warning) with amounts + pct. (ponytail: `ProgressBarX`, not an fl_chart bar — the style guide allows either; reuse what exists.)
- **`NeedWantCard`** — Need/Want/Lifestyle/Emergency rows with pct + `ProgressBarX`.
- **`MonthlyOverviewCard`** — income / expense / saved (`MoneyText`, saved in green when positive).
- **`InsightCard`** (style guide §13.14) — 32 icon container (type color) + body text; rendered per `InsightItem`. Section empty (no insights fired) → a gentle "Belum ada insight untuk bulan ini."
- **Chart rules (§14):** max 2–3 chart cards (we have the donut + two bar-style cards — fine), few colors (category colors for the donut, semantic for bars), always a fallback empty state. Per-section empty states are **user-approved**.

---

## 5. Routes / DI / l10n

- **Route:** Insight is the existing shell branch (`AppRoute.insight` → `InsightPage`, branch 2 in `app_router.dart`). Provide `InsightCubit` via `BlocProvider(create:)..load(currentMonth)` at that branch's builder, pulling usecases + `TxChangeNotifier` from `sl`.
- **DI:** no new datasource/repo — Insight reuses `GetTransactionsByMonth`, `GetCategories`, `GetBudgetsForPeriod`, `TxChangeNotifier` (all registered). Just wire the cubit at the route.
- **l10n** (both arb, id primary, parity; reuse `income`/`expense`/`insight`/`month`/`planned`/`unplanned`/`need`/`want`/`lifestyle`/`emergency` where they exist): add `monthlyOverview`, `saved`, `expenseByCategory`, `plannedVsUnplanned`, `needVsWant`, `spendingInsight`, `insightBudgetUsed` (`{category}`/`{pct}`), `insightBudgetOver` (`{category}`), `insightCategoryUp` (`{category}`/`{pct}`), `insightUnplannedUp`, `noExpenseThisMonth`, `noInsightThisMonth`, `noDataThisMonth`. ICU params for the interpolations. `gen-l10n` + `check_arb_parity.dart`.

---

## 6. Testing

`test/features/insight/` + a pure `insight_rules` test. `bloc_test` + `mocktail` (extend `mocks.dart`); `pump_app.dart` for a donut/section widget smoke test if useful.
- **`insight_rules` (pure):** budget-warning fires at ≥80% (not at 79%), critical copy ≥100%; category-up picks the largest riser ≥15% and ignores <15%/trivial; unplanned-up fires only when this > last. Deterministic inputs, exact outputs.
- **`InsightCubit`:** given mocked usecases (a month of expenses across categories + planned/spending types, a previous month, budgets) → `loaded` with correct overview totals, category slices (sorted, pcts sum ~100), planned/unplanned split, need/want split, and the expected insight items; empty month → `loaded` with zeros + empty sections (NOT `error`); a `ping` reloads.
- Aggregation math asserted numerically (income/expense/saved, a category pct, planned pct). Keep coverage ≥40%.

---

## 7. Acceptance
- [ ] `build_runner` green (freezed InsightState/InsightReport), committed
- [ ] `gen-l10n` + `check_arb_parity.dart` pass · `flutter analyze` = 0 · `dart format` clean
- [ ] `flutter test` green incl. `insight_rules` + `InsightCubit` tests; coverage ≥40%
- [ ] Insight tab shows month selector + all 5 sections; switching months recomputes
- [ ] Donut renders category slices in category colors + legend with amounts/pcts; planned/unplanned + need/want bars correct
- [ ] Insight cards fire per the 3 heuristics (budget ≥80%, category up ≥15% MoM, unplanned up MoM); none fire → gentle empty
- [ ] Empty month → per-section empty states, no broken/zero charts, no error
- [ ] Adding an expense updates Insight live (TxChangeNotifier)
- [ ] Domain-purity test passes; `insight_rules` pure; no new datasource

## 8. Not in M5
Settings/appearance/name-editing (M6), line/trend history charts beyond MoM (V2), category drill-down screens, export of insights (V2), custom date ranges (month-only for MVP), notifications.

---

### Reference-pattern note
Insight is the third **presentation-only feature** (after Home, Calendar) and reuses the `BudgetStatus`-style **pure calculation helper** precedent (`insight_rules`). It also subscribes to the general `TxChangeNotifier` bus. Nothing new to record unless a novel aggregation convention emerges.
