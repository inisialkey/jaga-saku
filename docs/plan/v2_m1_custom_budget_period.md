# V2-M1 — Custom Budget Period (structural refactor + feature)

Second V2 milestone. Ships the audit's **P0 structural fix** — replace the calendar-month `'YYYY-MM'` budget period with an explicit `[periodStart, periodEnd)` range — **as** the user-facing custom-cycle feature (e.g. a payday budget running the 25th → 24th). This is the one V2 feature that is *not* additive: the calendar month is welded into schema, spend SQL, and the status clock, so it must be refactored, not extended. Doing it early (right after V2-M0) is far cheaper than after more budget code accretes.

**Build-order context:** MVP M0–M6 ✓ → V2-M0 Foundation Hardening ✓ (**prerequisite** — provides the safe migration path + schema-parity test) → **V2-M1 Custom Budget Period** → V2 features (quick-tx, receipt, recurring, reconciliation).

**Source of truth:** pre-V2 audit (budget area, 3/10 — weakest) + wireframe §3 (Budget) + style guide §13.

**Proposed scope (confirm at planner gate — matches the M1–M6 flow):**
- **Global cycle-start-day** setting (1 value, e.g. "budgets start on day 25"). Default **1** = today's calendar-month behavior exactly (zero behavior change for existing users). Covers the stated payday use case. **`// ponytail:`** one global setting, not per-budget arbitrary ranges — those are a later additive change *because* this milestone moves storage to a real `[start,end)` range.
- **Storage is per-budget `[periodStart, periodEnd)` millis regardless** — so per-budget custom ranges (V2.5) become additive, never another rewrite.

**Definition of done:** `analyze` 0, `format` clean, build_runner green, ARB parity, coverage ≥40%. With cycle-start-day = 1, every existing budget behaves **identically** (migration-verified). Setting it to N makes all budgets run day-N → day-(N-1) next cycle; spend, remaining, and safe-daily all compute off the real range; the budget list/form show the cycle date range.

---

## 1. Dependencies
**None new.** Requires V2-M0's migration path (chained `onCreate` + `schema_parity_test`) to be merged first — this milestone adds the next `_vN` and relies on fresh installs replaying it.

---

## 2. Data model — `budgets` gains an explicit range (the core fix)

- **Schema `_vN`** (next sequential version after V2-M0; call it `_v3` if V2-M0 shipped `_v2`): `ALTER TABLE budgets ADD COLUMN period_start INTEGER; ADD COLUMN period_end INTEGER;` (epoch millis, `[start, end)` half-open). Keep `period TEXT` as a **human display label** only (or drop it — decide in the plan; keeping it avoids a destructive migration).
  - **Backfill (data-preserving, mandatory):** in the same `_vN`, for every existing row compute `period_start`/`period_end` from the old `'YYYY-MM'` string (month bounds) so no user loses a budget. Add a migration test asserting a v(N-1)→vN upgrade backfills correctly.
  - **Uniqueness:** replace `UNIQUE(category_id, period)` (`migrations.dart:95`) with `UNIQUE(category_id, period_start)` — one budget per category per cycle.
  - Mirror the new columns into the fresh-install DDL (`_v1` or the latest-snapshot per V2-M0's chosen shape).
- **Entity/model:** `lib/features/budgets/domain/entities/budget.dart` + `data/models/budget_model.dart` — add `periodStart:int`, `periodEnd:int`; keep `period` as an optional display label. Rerun build_runner, commit generated. `spent` stays derived/non-persisted.

---

## 3. Cycle math — one pure helper, kills the calendar-month assumption

Add `lib/features/budgets/domain/entities/budget_cycle.dart` — **pure, flutter-free** (rule 19), unit-tested; mirrors the `BudgetStatus` precedent:
- `BudgetCycle.range({required int startDay, required DateTime reference}) → ({int start, int end})` — the `[start, end)` millis of the cycle containing `reference`, given the cycle start-day. `startDay == 1` ⇒ exact calendar month (proves backward-compat).
- `BudgetCycle.next(...)` / `.previous(...)` for the budget month-nav → cycle-nav.
- Clamp start-day to valid days per month (e.g. start-day 31 in February ⇒ last day) — the calibration knob the real calendar needs.

The global start-day lives in the **settings key-value store** (V2-M0/M6 pattern): key `budget_cycle_start_day`, default `1`. Read via `SettingsService`; expose through `AppSettingsCubit` (the app-global prefs owner) so budget screens react to a change without restart.

---

## 4. Rewrite the three calendar-month sites (audit blast radius)

1. **Spend SQL** — `lib/features/budgets/data/datasources/budget_local_datasource.dart:32`: replace `strftime('%Y-%m', datetime(t.date/1000,'unixepoch','localtime')) = b.period` with `t.date >= b.period_start AND t.date < b.period_end`. This also **removes the 3rd month-bucket definition** the audit flagged — spend now keys off the same `[start,end)` millis as everything else.
2. **Status clock** — `lib/features/budgets/domain/entities/budget_status.dart:96-109` (`_remainingDays`): compute from the stored `periodEnd` vs `now`, not `DateTime(year, month+1, 0)`. `safeDaily` (`:45-47`) unchanged once `remainingDays` is range-based.
3. **`periodKey` + callers** — `budget_status.dart:8-12` (`periodKey`) is replaced by `BudgetCycle.range`; update callers `home_cubit.dart:74`, `insight_cubit.dart:70,110,113`, `add_transaction_cubit.dart:217-236` (budget-warning lookup), `budget_form_cubit.dart:70-76,132-140` (month-nav → cycle-nav) to pass the cycle range / start-day.

---

## 5. UI

- **Setting:** a "Budget cycle start day" row in the Settings screen (reuse the M6 `SettingsPage` + `SettingsCard`/`MenuSection` pattern; a day-of-month picker 1–31). Persists via `AppSettingsCubit`. Default 1 → labelled "Kalender bulanan".
- **Budget list/form:** show the **cycle date range** ("25 Jul – 24 Agu") instead of the bare month. The M5-promoted `MonthSelector` (`lib/core/widgets/month_selector.dart`) steps calendar months — either generalize it to step **cycles** (preferred, shared by Budget) or wrap it. Note: Insight still uses `MonthSelector` for calendar months — don't break Insight; parameterize rather than repurpose in place.
- Empty/default states unchanged.

---

## 6. Routes / DI / l10n
- **Routes:** none new (setting lives in existing Settings screen).
- **DI:** `AppSettingsCubit` gains the `budget_cycle_start_day` pref (constructed with existing `SettingsService`). No new datasource/repo.
- **l10n** (id primary + en parity): add `budgetCycle`, `budgetCycleStartDay`, `budgetCycleMonthly` ("Kalender bulanan"), `budgetCycleRange` (`{start}`–`{end}` ICU). `gen-l10n` + `check_arb_parity.dart`.

---

## 7. Testing
- **`BudgetCycle` (pure):** start-day 1 ⇒ identical to calendar month for several months incl. Feb + year rollover; start-day 25 ⇒ 25th→24th spanning a month boundary; start-day 31 clamps in short months; `next`/`previous` symmetry. Deterministic in/out.
- **Migration:** open a DB at v(N-1) with a `'YYYY-MM'` budget row, upgrade to vN, assert `period_start`/`period_end` backfilled to that month's bounds and spend still matches. (Extends V2-M0's schema-parity test infra.)
- **`budget_local_datasource`:** spend sums only transactions inside `[start,end)` (a tx one ms before `start` and one at `end` are excluded).
- **`BudgetStatus`:** `_remainingDays` derived from stored `periodEnd` (past cycle ⇒ 0; current ⇒ days to end; future ⇒ full span).
- **`budget_list_cubit` / `budget_form_cubit`:** cycle-nav moves by cycle; changing the start-day setting reloads (via `AppSettingsCubit` + `TxChangeNotifier` if spend changes).
- Keep coverage ≥40%; existing budget tests updated (not deleted) to the range model.

---

## 8. Acceptance
- [ ] `budgets` has `period_start`/`period_end`; v(N-1)→vN migration backfills existing rows (test-verified, no data loss); `UNIQUE(category_id, period_start)`
- [ ] `BudgetCycle` pure (rule 19), unit-tested; start-day 1 ⇒ calendar-month-identical (backward-compat proven)
- [ ] Spend SQL uses `date >= start AND date < end`; the `strftime` month-bucket definition removed
- [ ] `BudgetStatus._remainingDays`/`safeDaily` compute off the stored range
- [ ] Setting the cycle start-day changes all budgets' windows live; list/form show the cycle range
- [ ] Insight's `MonthSelector` (calendar month) still works — not repurposed by the cycle change
- [ ] `analyze` 0 · `format` clean · build_runner green · ARB parity · coverage ≥40% · existing budget tests migrated & green

## 9. Not in V2-M1
- **Per-budget arbitrary ranges** (each budget its own dates) — additive later thanks to the `[start,end)` storage; not now.
- Weekly/quarterly/annual budget periods (V3).
- Recurring transactions, receipt, quick-tx, reconciliation (separate milestones).

---

### Reference-pattern note
`BudgetCycle` is the fourth **pure calculation helper** (after `BudgetStatus`, `insight_rules`, `TransactionAggregator`) and the canonical cycle math. After this ships, **no code should assume a budget = calendar month** — record that in memory, superseding the audit's "calendar-month baked in" finding.
