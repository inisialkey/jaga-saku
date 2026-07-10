# M4 — Budget & Budget Guard

Fourth domain milestone. Activates the app's differentiating feature: per-category **monthly budgets** with a **safe-daily** guardrail. Adds the Budget screen (More→Budget, currently "Soon"), fills the Home **Budget Guard** card (M3 shipped its empty state, structured for this swap), and lands the **Add-transaction budget warning** deferred from M2. Mirrors the canonical pattern (`lib/features/accounts/`). Source of truth = `docs/jaga_saku_low_fidelity_wireframe.md` (Budget screen + §3 warning) + `docs/jaga_saku_ui_style_guide.md` §13.6 + `docs/jaga_saku_ui_design.md` + M0 plan §4 (derived formulas).

**Build-order context:** M0 ✓ → M1 ✓ → M2 ✓ → M3 ✓ → **M4 Budget** → M5 Insight → M6 More/Settings.

**User-approved scope:** Home Budget Guard shows the **most at-risk** budget · **include** the Add-tx safe-daily warning · **full** budget CRUD (create/edit/delete).

**Definition of done:** `flutter analyze` = 0, `dart format` clean, build_runner green, ARB id/en parity, coverage ≥40%. More→Budget opens a real screen: pick a month, see each category budget with spent/limit progress, %, safe-daily, and a safe/warning/critical status; create/edit/delete budgets. The Home Budget Guard card shows the most at-risk budget (or the empty state when none). Saving an expense that breaches the category's safe-daily prompts a warning sheet before it commits.

---

## 1. Dependencies
**None.** Reuses M1/M2/M3 (`GetCategories`, transactions datasource, `TxChangeNotifier`, `ProgressBarX`, `MoneyText`, `AppCard`, `SelectorField`, `AmountInputField`, `ConfirmSheet`, `AppBottomSheet`, `EmptyStateView`, `SectionHeader`).

---

## 2. Budget feature (`lib/features/budgets/`) — mirror `accounts/`

```
lib/features/budgets/
├── domain/
│   ├── entities/budget.dart            # @freezed Budget + non-persisted spent (view)
│   ├── entities/budget_status.dart     # PURE helper: safe-daily + status from (limit, spent, now)
│   ├── repositories/budget_repository.dart
│   └── usecases/
│       ├── get_budgets_for_period.dart # UseCase<List<Budget>, String period 'YYYY-MM'>  (with spent)
│       ├── save_budget.dart            # UseCase<int, Budget>  (id null => insert; UNIQUE(category,period) => update or ConflictFailure)
│       └── delete_budget.dart          # UseCase<Unit, int>
├── data/
│   ├── models/budget_model.dart        # fromMap/toMap (+ derived `spent` column) / toEntity
│   ├── datasources/budget_local_datasource.dart
│   └── repositories/budget_repository_impl.dart   # _guard → CacheFailure / ConflictFailure
└── pages/
    ├── list/ budget_list_cubit.dart · budget_list_state.dart · budget_list_page.dart
    └── form/ budget_form_cubit.dart · budget_form_state.dart · budget_form_page.dart
```

### 2.1 `Budget` entity (freezed, pure)
`int? id`, `int categoryId`, `String period` ('YYYY-MM'), `int limitAmount`, `int createdAt`, and non-persisted `int spent` (`@Default(0)`, filled by the join query). Domain stays pure (rule 19): no Flutter, ids/ints only.

### 2.2 `BudgetStatus` (pure domain helper — the money math)
A pure Dart value object computing, from `(int limitAmount, int spent, DateTime now, String period)`:
- `remaining = limitAmount - spent`
- `ratio = spent / limitAmount` (guard divide-by-zero)
- `remainingDays` = days left in the period's month **when `period` is the current month** (`daysInMonth - now.day + 1`); for a **past** period → 0 (safe-daily N/A), **future** → full month. Only the current month drives safe-daily/warnings.
- `safeDaily = remainingDays > 0 ? max(0, remaining) ~/ remainingDays : 0`
- `status`: `safe` (ratio < 0.8) · `warning` (0.8 ≤ ratio < 1.0) · `critical` (ratio ≥ 1.0) — thresholds from M0 §4. Enum `BudgetStatusLevel { safe, warning, critical }` (maps to palette success/warning/critical).
Pure + fully unit-tested (no flutter, no DB) — this is the correctness core; test boundaries (0%, 79/80/99/100/120%, last day of month, empty limit).

### 2.3 Datasource — spent via SQL join
`BudgetLocalDatasource(AppDatabase)`:
- `getBudgetsForPeriod(String period)` → budgets for the period **left-joined** to the expense sum:
  ```sql
  SELECT b.*,
    COALESCE((SELECT SUM(t.amount) FROM transactions t
              WHERE t.category_id = b.category_id
                AND t.type = 'expense'
                AND strftime('%Y-%m', datetime(t.date/1000,'unixepoch','localtime')) = b.period), 0) AS spent
  FROM budgets b WHERE b.period = ? ORDER BY b.created_at;
  ```
  (Period from a millis date = format via `strftime`/`datetime(...,'localtime')`. Verify the `localtime` conversion matches how Dart derives `period` for a tx date — **test a tx near month boundary** to confirm the SQL bucket == the Dart bucket. If sqlite tz handling is fussy, fall back to computing `spent` in Dart from `getByMonth` rows — acceptable, small volumes.)
- `getSpentForCategory(int categoryId, String period)` → single-category spent (for the Add-tx warning).
- `insert`/`update`/`delete`. `insert` on a duplicate `(category_id, period)` hits the UNIQUE constraint → repo maps to `ConflictFailure` (caller then updates, or the form pre-checks).

### 2.4 Repo impl — same `_guard` as `AccountRepositoryImpl`; `ConflictFailure` on UNIQUE, `CacheFailure` otherwise; never throws.

---

## 3. Budget screen (`features/budgets/pages/list|form`) — wireframe "Budget screen", style guide §13.6

- **`BudgetListPage`** — AppBar "Budget" + `+`; a **month selector** (`SelectorField`/header, default current month, prev/next); body `BlocBuilder`: loading→shimmer, error→`ErrorStateView`, empty→`EmptyStateView` ("Budget belum dibuat — atur budget agar Jaga Saku bisa bantu memantau pengeluaranmu" + CTA → form), loaded→list of **`BudgetItemCard`** (category icon+name, `Rp spent / Rp limit`, `ProgressBarX` colored by status, `%`, "Aman harian: Rp…/hari", status badge safe/warning/critical). Tap → edit; long-press/trailing → delete via `ConfirmSheet`.
- **`BudgetFormPage`** — category `SelectorField` → `CategoryPickerSheet` (expense categories; reuse M2), month (default the list's selected period), `AmountInputField` limit. On save, if a budget already exists for that category+period, edit it (pre-check via the loaded list or handle `ConflictFailure`). `BudgetFormCubit` validates limit > 0.
- **`BudgetListCubit`** subscribes to `TxChangeNotifier` (spent changes when transactions change) and reloads. On its own CRUD success it reloads + **pings** the notifier (so the Home guard recomputes — see §6).

---

## 4. Home Budget Guard card — fill the M3 empty state

`lib/features/home/pages/widgets/budget_guard_card.dart` currently renders the empty state and is explicitly structured for this swap. M4:
- `HomeCubit` gains `GetBudgetsForPeriod` (current month). Compute each budget's `BudgetStatus`; pick the **most at-risk** = max `ratio` (tie → higher `spent`). Add `BudgetGuardView? budgetGuard` to `HomeDashboard` (null when no budgets).
- `BudgetGuardCard` renders: null → the existing empty state, but the **CTA is now live** → `context.push(AppRoute.budget)` (drop the `ComingSoonBadge`, enable the button); non-null → live content: category name, "tersisa Rp{remaining}", "Aman harian: Rp{safeDaily}/hari", `ProgressBarX` (status color), status badge.
- Refreshes automatically: `HomeCubit` already subscribes to `TxChangeNotifier`; budget CRUD pings it (§6).

---

## 5. Add-transaction budget warning — retrofit (wireframe §3)

In `AddTransactionCubit.submit()` (currently: validate → `_saveTransaction` → `ping`): before committing an **expense**, check the category's budget for the tx period via `getSpentForCategory` + the budget's `BudgetStatus`. If this expense would push the category over its **safe-daily** (`thisAmount > safeDaily`, or `spent + thisAmount` crosses the safe-daily line — pick the wireframe's "Transaksi ini > Batas aman harian" reading), do NOT save yet — emit a `needsBudgetConfirm(safeDaily, amount)` state. The **page** shows a `BudgetWarningSheet` (bottom sheet: "Pengeluaran ini melewati batas aman harian kategori {cat}. Batas aman: Rp{safeDaily}/hari · Transaksi ini: Rp{amount}") with **[Tetap Simpan]** (→ `cubit.confirmSave()` commits + pings) / **[Ubah Nominal]** (dismiss, back to form). No budget for the category → save straight through (no warning). Keep the check in the cubit; the sheet is UI.

> ponytail: reuse the existing `submit` path — add a "confirm required" branch, don't duplicate the save. Only expenses with a current-month budget can trigger it.

---

## 6. Refresh semantics (reuse `TxChangeNotifier`)

Budget-derived views (Home guard, Budget list) must refresh when **either** transactions **or** budgets change. Reuse the existing `TxChangeNotifier` as the single "derived-money-views changed" bus: **budget save/delete also `ping()`s it** (broadened meaning — document in the notifier doc-comment). Home + Budget-list + Calendar already/also subscribe. No second notifier (ponytail: one bus; rename avoided to not churn merged M2/M3 code — just widen the doc-comment).

---

## 7. Routes / DI / l10n

- **Routes** (`app_router.dart`): `AppRoute.budget = '/budget'`, `AppRoute.budgetForm = '/budget/form'` (root-nav full-screen, like accounts/categories). Cubits per-route `BlocProvider` from `sl`.
- **More tile:** `more_page.dart` — Budget row: drop `ComingSoonBadge`, make it live → `context.push(AppRoute.budget)`.
- **DI:** register `BudgetLocalDatasource`→`BudgetRepository`→`GetBudgetsForPeriod`/`SaveBudget`/`DeleteBudget`; inject `GetBudgetsForPeriod` (+ a category-spent read) into `HomeCubit` and `AddTransactionCubit`; `BudgetListCubit`/`BudgetFormCubit` per-route. Budget CRUD pings `sl<TxChangeNotifier>()`.
- **l10n** (both arb, id primary, parity; reuse existing `budget`,`budgetGuard`,`createBudget`,`budgetEmptyTitle`,`budgetEmptyMessage`,`category`,`amount`,`delete`,`save`): add `budgetLimit`, `spentOfLimit` (`{spent}`/`{limit}` params), `safeDaily` (`{amount}`), `statusSafe`/`statusWarning`/`statusCritical`, `remainingBudget` (`{amount}`), `month`, `selectMonth`, `deleteBudgetConfirm`, `budgetWarningTitle`, `budgetWarningBody` (`{category}`/`{safe}`/`{amount}`), `keepSaving`, `editAmount`, `overBudget`. `gen-l10n` + `check_arb_parity.dart`.

---

## 8. Testing (canonical triple + the pure helper + retrofits)

`test/features/budgets/` + a `BudgetStatus` unit test + Home/Add-tx retrofit tests. ffi + `bloc_test` + `mocktail` (extend `mocks.dart`).
- **`BudgetStatus` (pure):** thresholds 0/79/80/99/100/120%, safe-daily on the last day of month, divide-by-zero limit, past/future period. This is the money core — cover it hard.
- **Datasource (ffi):** `getBudgetsForPeriod` returns spent = Σ expense for that category+period (insert txs across two months, assert only the period's expenses count; transfers/income excluded); UNIQUE(category,period) conflict; delete.
- **Repository:** success→Right; UNIQUE→`Left(ConflictFailure)`; other→`Left(CacheFailure)`.
- **BudgetListCubit / BudgetFormCubit:** load per period; save/delete; a `ping` reloads.
- **HomeCubit retrofit:** with budgets → `budgetGuard` = most at-risk (max ratio); none → null (empty state).
- **AddTransactionCubit retrofit:** expense over safe-daily → `needsBudgetConfirm` (no save yet); `confirmSave` commits + pings; expense with no budget → saves straight through; income/transfer never warn.
- Coverage ≥40% (the feature triple + pure helper clear it).

---

## 9. Acceptance
- [ ] `build_runner` green (freezed Budget/model/states), committed
- [ ] `gen-l10n` + `check_arb_parity.dart` pass · `flutter analyze` = 0 · `dart format` clean
- [ ] `flutter test` green incl. `BudgetStatus` + budget triple + Home/Add-tx retrofits; coverage ≥40%
- [ ] More→Budget opens the screen; month selector works; create/edit/delete a budget persists
- [ ] Each budget shows correct spent/limit/%/safe-daily/status; spent reacts live to adding an expense in that category (TxChangeNotifier)
- [ ] Home Budget Guard shows the most at-risk budget (live content), empty state + working CTA when none
- [ ] Saving an expense over the category's safe-daily shows the warning sheet; [Tetap Simpan] commits, [Ubah Nominal] returns to the form; no-budget category saves without a warning
- [ ] Domain-purity test passes; repo returns Either, never throws; `BudgetStatus` is pure

## 10. Not in M4
Insight charts / planned-vs-unplanned / need-vs-want (M5), settings/appearance (M6), budget copy-forward to next month + recurring budgets (V2), multi-category/global budgets, budget history trends, notifications on breach (V2).

---

### Reference-pattern note
`budgets/` mirrors `accounts/`; `BudgetStatus` sets the "pure domain calculation helper" precedent (M5 insight aggregations may want the same). The `TxChangeNotifier` is now the general "derived-money-views changed" bus (tx + budget writes) — record in memory.
