# V2-M7 — Monthly Money Story / Asset Trend

Final V2 milestone. A dedicated, **view-only** monthly recap screen: narrative cards ("Kamu hemat Rp 1,2jt bulan ini", top category, biggest expense, income-vs-expense MoM, need/want, savings rate) **plus** a net-worth-over-time line chart. The story facts reuse the existing pure helpers (`insight_rules`, `TransactionAggregator`); the **asset trend is greenfield** — the app's only chart today is the expense `PieChart` (`expense_donut_chart.dart:45`), and there is **no net-worth history** anywhere (`grep networth|snapshot|LineChart|FlSpot` = empty).

**Build-order context:** V2-M0 ✓ → V2-M1 ✓ → V2-M2 ✓ → V2-M3 ✓ → V2-M4 ✓ → V2-M5 ✓ → V2-M6 ✓ (**depends on**: `TransactionAggregator.excludeCategoryIds` + `Category.systemKey`, so adjustments don't distort the story's income/expense) → **V2-M7 Money Story**. The capstone — a synthesis milestone, mostly presentation over data the earlier milestones produced.

**Source of truth:** the grill (2026-07-12). Asset trend = computed **on the fly** (SQL monthly signed deltas + a pure `AssetTrendCalculator` cumulating from the opening-balance baseline — **no snapshot table**, always consistent with edited/deleted history). Monthly granularity, 12-month window, compact `Rp …jt` axis labels (new). Share deferred (offline, no new dep).

**Definition of done:** `analyze` 0, format, build_runner green, ARB parity, coverage ≥40%, existing tests + goldens green. The Money Story screen shows the focused month's recap + a 12-month asset-trend line; edits to past transactions reflect immediately (no stale snapshot); adjustments (M6) move the trend but not the income/expense cards.

---

## 1. Dependencies
- **V2-M6** — `TransactionAggregator.excludeCategoryIds` + `Category.systemKey`, so the story's income/expense/top-category cards exclude reconciliation adjustments (while the trend includes them — they change real assets).
- Reuses `fl_chart ^1.1.1` (already a dep — only `PieChart` used so far), `insight_rules` (`computeInsights`, `BudgetGauge`, thresholds `:64-74`), `TransactionAggregator`, `MonthSelector` (`core/widgets/month_selector.dart`), `money.dart` (`formatRupiah`), `MoneyText`. **No new packages.**

## 2. Scope
- A pure `AssetTrendCalculator` (baseline + monthly deltas → month-end net-worth points).
- A SQL monthly-signed-delta aggregate + a biggest-single-expense query.
- A reusable `AssetTrendChart` (`fl_chart` `LineChart`) + a compact `formatCompactRupiah`.
- A dedicated `/money-story` screen (MonthSelector + narrative cards + trend chart), reachable from Insight.

## 3. Not in scope
- **Sharing / export** (screenshot to image, share sheet) — deferred; keeps the app offline with no `share_plus` dep and no outward surface.
- A **snapshot table** / persisted net-worth history (rejected — on-the-fly is consistent with edits and needs no sync).
- Per-account trend, category trend charts, budgets-over-time, or a home-screen mini-trend (additive later; this reuses the same calculator).
- Weekly/daily trend granularity.

---

## 4. Data model / migration changes
**None.** Net worth is reconstructed on read; no table, no column, no `_vN`, no seed. `latestVersion` unchanged (still `6` after M6). The schema-parity test is untouched — called out so no one adds a snapshot table by reflex.

## 5. Domain / model changes
- **Pure helper** `lib/features/insight/domain/asset_trend_calculator.dart` (or `core/utils/helper/`) — **flutter-free** (rule 19), unit-tested; the eighth pure calculation helper:
  - `List<TrendPoint> cumulate({ required int baseline, required List<MonthDelta> deltas })` — `baseline = Σ opening_balance` (net worth at t0); walks months in order, `running += delta[m]`, emits `TrendPoint(month, netWorth)` at each month-end. Empty deltas ⇒ a flat line at `baseline`.
  - `TrendPoint { int monthMillis; int netWorth }`, `MonthDelta { int monthMillis; int delta }` (`@freezed` or plain). Deterministic, no clock, no I/O.
- **Net-worth delta identity** (documented in the helper): across the whole portfolio, transfers net to zero (every transfer is `−amount` on one account, `+amount` on another), so `monthDelta = Σincome − Σexpense` (adjustments included — they change real assets). This mirrors the account balance SQL summed over all accounts (`Σopening + Σincome − Σexpense`, transfers cancel).
- **Compact formatter** `money.dart`: add `String formatCompactRupiah(int)` — `12_000 → "12rb"`, `8_450_000 → "8,5jt"`, `2_500_000_000 → "2,5M"`, `<1000 → formatRupiah` (full). Indonesian units `rb/jt/M`; `// ponytail:` single ID format (app is ID-first), not localized.

## 6. Datasource / repository / usecase changes
- **`TransactionLocalDatasource`** (`transaction_local_datasource.dart` — currently no aggregates, `:34-71`) gains:
  - `monthlyNetDeltas(int startMillis, int endMillis) → List<MonthDelta>` — `SELECT strftime('%Y-%m', datetime(date/1000,'unixepoch','localtime')) AS m, SUM(CASE type WHEN 'income' THEN amount WHEN 'expense' THEN -amount ELSE 0 END) AS delta FROM transactions WHERE date >= ? AND date < ? GROUP BY m ORDER BY m`. Transfers ⇒ `ELSE 0` (net-zero at portfolio level); adjustments are income/expense ⇒ included. Same `strftime` bucket the budget spend SQL uses (`budget_local_datasource.dart:32`) — no new month-bucket definition.
  - `biggestExpense(int monthStart, int monthEnd) → TransactionModel?` — `WHERE type='expense' AND date ∈ [start,end) ORDER BY amount DESC LIMIT 1` (for the "biggest single expense" card).
- **Opening baseline:** `Σ opening_balance` over **non-archived** accounts — reuse `GetAccounts` and sum `openingBalance` in the cubit (matches Home's `totalBalance` account set, `home_cubit.dart:127-129`). `// ponytail:` accounts created/archived mid-window shift the baseline slightly; a true point-in-time account set is over-engineering for a trend — note it.
- **Usecases:** `GetAssetTrend(window)` (baseline + `monthlyNetDeltas` → `AssetTrendCalculator.cumulate`), `GetBiggestExpense(month)`. Reuse `GetTransactionsByMonth`, `GetCategories`, `GetAccounts`.
- **Repo:** extend `TransactionRepository` with the two aggregates (`Either<Failure,T>`), impl guarded like the rest.

## 7. Cubit / state changes
- **`MoneyStoryCubit`** + `@freezed MoneyStoryState` (sealed loading/loaded{story}/error), mirroring `InsightCubit` (`insight_cubit.dart`): a `_focusedMonth`, subscribes `TxChangeNotifier` (`:43`) → reload, `previousMonth`/`nextMonth`.
  - `load(month)`: awaits `GetTransactionsByMonth(current)` + `(prev)`, `GetCategories`, `GetBiggestExpense(month)`, `GetAssetTrend(12mo)`.
  - Assembles a `MoneyStory` VM: `income`/`expense`/`saved` (`TransactionAggregator.incomeExpense(current, excludeCategoryIds: systemIds)` — **M6 exclusion so adjustments don't inflate**), `savingsRate = saved/income`, `topCategory` (`expenseByCategory` max, excluding system), `biggestExpense`, `momIncome`/`momExpense` (current vs prev), `needVsWant` (reuse the Insight `_needVsWant` fold `:202-218`), `trend: List<TrendPoint>`.
- No changes to `HomeCubit`/`InsightCubit` beyond what M6 already added. `MoneyStory` reuses `insight_state.dart` view types (`SpendingSlice`, etc.) where they fit.

## 8. UI changes
- **`AssetTrendChart`** (`lib/features/insight/pages/widgets/asset_trend_chart.dart`) — a `fl_chart` `LineChart`: `LineChartBarData` over `TrendPoint`s (x = month index, y = net worth), smooth line + a subtle area fill (style-guide accent), y-axis labels via `formatCompactRupiah`, x-axis = short month labels (reuse `MonthSelector`'s `_idMonths`). Degrades to a single dot / flat line for ≤1 point. The first `LineChart` in the app — a reusable pattern for future trends.
- **Money Story screen** (`/money-story`, `lib/features/insight/pages/money_story_page.dart`): an `AppScaffold` + `ListView` (mirrors `insight_page.dart:52`):
  - `MonthSelector` (existing) at top.
  - A hero card: "Kamu hemat **Rp 1,2jt**" (or "Kamu defisit …" when `saved < 0`) + savings-rate.
  - Top-category card, biggest-expense card, income-vs-expense MoM card (up/down vs last month), need/want card.
  - `AssetTrendChart` (12-month, **not** month-scoped — a fixed trailing window) with a "Kekayaan bersih" header + current net worth.
  - Empty month ⇒ `EmptyStateView`.
- **Entry point:** a "Cerita Bulan Ini" / trailing action in the Insight page header (`insight_page.dart` — a `SectionHeader` action or app-bar icon) → `context.push('/money-story')`. (Optionally also a More-screen entry; one is enough.)

## 9. Routes / DI / l10n
- **Routes** (`app_router.dart`): `AppRoute.moneyStory = '/money-story'` (root-navigator, full-screen), `BlocProvider(create:)` pulling the usecases from `sl()`.
- **DI** (`dependencies_injection.dart`): register `GetAssetTrend` + `GetBiggestExpense` (in `_registerTransactions`); the money-story route's provider wires them + `GetTransactionsByMonth` + `GetCategories` + `GetAccounts` + `TxChangeNotifier`.
- **l10n:** `moneyStory`, `moneyStoryTitle`, `storySavedHero` (`Kamu hemat {amount}`), `storyDeficit`, `storySavingsRate` (`{pct}`), `storyTopCategory`, `storyBiggestExpense`, `storyVsLastMonth`, `storyNeedWant`, `netWorth`, `assetTrend12mo`. Compact units (`rb`/`jt`/`M`) are formatting, not keys. `gen-l10n` + parity.

## 10. Testing plan
- **`AssetTrendCalculator` (pure) — the guard:** `baseline=1_000_000`, deltas `[+500k, −200k, +100k]` ⇒ points `[1.5M, 1.3M, 1.4M]`; empty deltas ⇒ flat at baseline; a negative-net-worth month renders (no clamp); month ordering preserved.
- **`formatCompactRupiah`:** `999 → "Rp 999"`, `12_000 → "12rb"`, `1_500_000 → "1,5jt"`, `8_450_000 → "8,5jt"`, `2_500_000_000 → "2,5M"`, `0 → "0"`; rounding boundary (`1_950_000 → "2jt"` or `"1,9jt"` — pin the rule).
- **`monthlyNetDeltas` SQL** (sqflite_common_ffi): income adds, expense subtracts, **transfers net to zero** (a transfer pair contributes 0 to the portfolio delta), adjustments (reserved-category income/expense) **included**; correct month buckets across a year boundary.
- **Net-worth reconciliation:** the last `TrendPoint.netWorth` for the current month == `Σ non-archived account.balance` (the trend's endpoint matches Home's `totalBalance`) — the key correctness anchor.
- **`MoneyStoryCubit`:** assembles saved/top/biggest/MoM/need-want; **excludes system categories** from income/expense/top (an adjustment doesn't change the story cards) but the **trend includes it**; reacts to `TxChangeNotifier`.
- **Goldens:** `AssetTrendChart` (multi-point, single-point, negative), money-story screen (populated + empty).

## 11. Acceptance
- [ ] `AssetTrendCalculator` pure (rule 19), unit-tested; trend endpoint == `Σ non-archived account.balance` (matches Home)
- [ ] Net worth computed **on the fly** (SQL monthly deltas + Dart cumulate); **no snapshot table**; editing a past tx moves the trend immediately
- [ ] Transfers net-zero in the delta; adjustments move the **trend** but not the income/expense **cards** (M6 exclusion)
- [ ] `AssetTrendChart` (first `LineChart`) + `formatCompactRupiah` axis labels; `/money-story` screen with MonthSelector + narrative cards, reachable from Insight
- [ ] Share **not** built (offline); no `share_plus`/new dep
- [ ] `analyze` 0 · format · build_runner green · ARB parity · coverage ≥40% · existing tests + goldens green

## 12. Risks & edge cases
- **Trend endpoint drift** — if the delta SQL or baseline is wrong, the last point won't equal current net worth; the reconciliation test (§10) is the tripwire.
- **Accounts created/archived mid-window** — their `opening_balance` applies from t0 in the naive baseline, so months before an account existed can read slightly high; acceptable for a trend, `// ponytail:` note; precise per-creation baselines only if visibly misleading.
- **Two adjustment rules** — adjustments included in the trend, excluded from income/expense cards; a single test pins both directions.
- **Empty / single-month history** — chart must render a dot/flat line, not crash; hero card handles zero income (savings-rate guards divide-by-zero).
- **Deficit month** — `saved < 0` flips the hero copy ("defisit"); `MoneyText`/color reflect it.
- **Large numbers on axis** — `formatCompactRupiah` keeps labels short; without it, `Rp 8.450.000` overflows the axis gutter.
- **Timezone month bucketing** — the delta SQL uses the same `strftime('%Y-%m', … 'localtime')` as budgets (`budget_local_datasource.dart:32`); consistent bucketing, no new definition.
- **12-month window vs `MonthSelector`** — the trend is a fixed trailing 12 months, independent of the month picker (which scopes the narrative cards); don't let the selector resize the chart window.

## 13. Recommended implementation order
1. `formatCompactRupiah` + unit tests.
2. `AssetTrendCalculator` + `TrendPoint`/`MonthDelta` + pure tests (incl. the reconciliation identity).
3. `monthlyNetDeltas` + `biggestExpense` SQL + datasource/repo/usecase + SQL tests (transfers net-zero, adjustments included, endpoint == balance).
4. `AssetTrendChart` widget + goldens.
5. `MoneyStoryCubit` + `MoneyStory` VM (reuse aggregator/insight folds, M6 exclusion) + cubit tests.
6. Money Story screen + route + Insight entry point + goldens.
7. l10n + parity; coverage sweep.

---

### Reference-pattern note
`AssetTrendCalculator` is the eighth **pure calculation helper**; `AssetTrendChart` is the app's first `LineChart` and the reusable time-series pattern. The **net-worth identity** (`baseline + Σ(income−expense)`, transfers cancel, adjustments count) is the canonical way to reconstruct history without a snapshot table — record it so no future milestone adds one. This milestone closes V2: every feature (favorite, calculator, receipt, recurring, reconciliation, money story) sits on V2-M0's migration/parity discipline and the pure-helper family (`BudgetStatus`, `insight_rules`, `TransactionAggregator`, `BudgetCycle`, `templateToTransaction`, `CalcEngine`, `RecurrenceSchedule`, `AssetTrendCalculator`).
