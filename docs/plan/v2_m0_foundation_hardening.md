# V2-M0 — Foundation Hardening (pre-feature refactors)

First V2 milestone. **No user-facing feature** — closes the structural debt the pre-V2 audit (2026-07-10) flagged as blocking or multiplying the V2 feature work. Mirrors the M0 "foundation" precedent: pure infra/quality, ships behind a green test suite with **zero behavior change**. Doing this first de-risks every V2 feature that follows (custom period, quick-tx, receipt, recurring, reconciliation).

**Build-order context:** MVP M0–M6 ✓ (all merged to `develop`) → **V2-M0 Foundation Hardening** → V2-M1 Custom Budget Period → V2 features (quick-tx, receipt, recurring, reconciliation).

**Source of truth:** the pre-V2 audit findings (this repo, docs/plan). Each work package below cites the exact files.

**Definition of done:** `flutter analyze` = 0, `dart format` clean, build_runner green, ARB parity, coverage ≥40%, **all existing tests + goldens still pass unchanged** (this is a refactor — behavior is identical). New: a schema-parity test + a `TransactionAggregator` unit test.

**Scope note:** internal only. No new routes, no new screens, no ARB user strings (except any error-message key in W5). Each W below is independently shippable as its own PR to `develop`; ship in order W1→W5 or cherry-pick.

---

## W1 — Migration path safety (P0, blocks every V2 table)

**Problem.** `onCreate` runs **only** `_v1` (`lib/core/database/migrations.dart:16`) and `migrate()` is empty (`:19-26`). When V2 adds a `_v2` with a new **table**, fresh installs never run `migrate()`, so the table is silently absent on clean installs. Nothing tests that the created schema equals the migrated schema.

**Fix.**
1. In `lib/core/database/migrations.dart`: make `onCreate` build the **latest** schema deterministically. Two acceptable shapes (pick one, `// ponytail:` the choice):
   - **A (replay):** `onCreate` runs `_v1` then every `_vN` in order (each `_vN` is written to be append-only + idempotent-safe on a just-created DB). Simplest to reason about: one source of DDL, fresh = migrate-from-zero.
   - **B (latest-snapshot):** `_v1` always holds the *current* full schema; each `_vN` (n≥2) is the delta for existing installs only. `onCreate => _createLatest(db)`.
   - Recommend **A** — one DDL path, no dual-write, kills the footgun by construction.
2. Add `test/core/database/schema_parity_test.dart`: open an in-memory DB via `onCreate`, open a second via `_v1`→`migrate(…,1,latestVersion)`, dump `sqlite_master` (tables + indexes + columns via `PRAGMA table_info`) from both, assert **identical**. Fails CI if a future `_vN` diverges. (sqflite_common_ffi for the in-memory DB in tests — check if already a dev_dep; add if not.)

**Files:** `lib/core/database/migrations.dart`, `lib/core/database/app_database.dart` (only if `onConfigure`/`onCreate` wiring changes), new `test/core/database/schema_parity_test.dart`.

**Also here (cheap, same layer):** add the missing indexes the audit flagged — `idx_budget_period` on `budgets(period)`, `idx_cat_type` on `categories(type)` — as a `_v2` step (proves the migration path end-to-end with a real, harmless change).

---

## W2 — `TransactionAggregator` pure helper (P1, dedupes derivation)

**Problem.** The same aggregates are hand-rolled in parallel:
- income/expense fold — `home_cubit.dart:132-141` ≈ `insight_cubit.dart:133-142` (identical `switch`, transfer skipped).
- expense-by-category map — `home_cubit.dart:146-164` ≈ `insight_cubit.dart:188-197`.

Every new derived view (recurring summaries, richer reports) forks this a third time.

**Fix.** Extract a **pure, flutter-free** helper — mirror the `BudgetStatus` / `insight_rules` precedent (unit-tested, no DB/widgets):
- Location: `lib/features/transactions/domain/` (it's domain logic over `Transaction` entities — keeps rule 19; it imports only `domain/entities`). Name `TransactionAggregator` (static methods) or free functions in `transaction_aggregator.dart`.
- Methods: `incomeExpense(List<Transaction>) → ({int income, int expense})` (transfers excluded); `expenseByCategory(List<Transaction>) → Map<int,int>` (skip non-expense, skip null category). Match the exact current semantics so behavior is identical.
- Refactor `home_cubit` + `insight_cubit` to call it; delete the inline copies.

**Files:** new `lib/features/transactions/domain/transaction_aggregator.dart`, `lib/features/home/pages/home_cubit.dart`, `lib/features/insight/pages/insight_cubit.dart`, new `test/features/transactions/domain/transaction_aggregator_test.dart`.

**Guard:** the pure helper needs one unit test asserting the fold numerically (income/expense/skip-transfer, per-category sum, null-category skip). Existing home/insight cubit tests must stay green unchanged.

---

## W3 — SQL aggregation for reports (P1, worst-scaling path)

**Problem.** Insight aggregates **100% in Dart** over two full month-scans (`insight_cubit.dart:66-67`, folds `:188-238`) — the lone table-scan-and-sum path, while budgets/accounts already use SQL `SUM`. Home/Calendar/Insight each re-issue the identical `getTransactionsByMonth(current)` with **no shared cache**; every `TxChangeNotifier` ping re-runs all three.

**Fix (ponytail: SQL where it already pays, cache only if it doesn't).**
1. Add SQL aggregate methods to `lib/features/transactions/data/datasources/transaction_local_datasource.dart` mirroring the budget/account `SUM` pattern: `sumByCategory(rangeStart, rangeEnd) → Map<int,int>`, `incomeExpenseTotals(start,end)`, and (for insight) `sumByPlannedStatus` / `sumBySpendingType`. Push the group-by into SQLite.
2. Expose via the transactions repo + a usecase (`GetMonthlyAggregates` or similar); consume from `insight_cubit` (and `home_cubit` where it currently folds). W2's pure helper stays as the fallback/for already-loaded lists — don't delete it; SQL is for the big month-window reads.
3. **Optional (measure first):** a short-lived month-query cache in `transaction_repository_impl.dart` keyed by month, invalidated on `TxChangeNotifier.ping()`, so Home+Calendar+Insight share one fetch per change. `// ponytail:` only add if profiling shows the triple-fetch matters — monthly windows are small, so this may be YAGNI. Note the decision in the walkthrough.

**Files:** `transaction_local_datasource.dart`, `transactions/domain/repositories` + `data/repositories/transaction_repository_impl.dart`, new usecase under `transactions/domain/usecases/`, `insight_cubit.dart`, `home_cubit.dart`, DI `dependencies_injection.dart`, tests.

**Note:** keep the four "which-month-is-this-tx" implementations in agreement — the SQL side already uses `strftime`; the new methods should take explicit `[start,end)` millis (same as `_range`) to avoid adding a 5th month-bucket definition.

---

## W4 — Promote app-global out of features (P1, fixes pages→pages coupling)

**Problem.** 4 `pages→pages` cross-feature imports break feature independence:
- `home/pages/home_page.dart:11` → `settings/pages/app_settings_cubit.dart` (app-global state trapped in `settings` — worst)
- `budgets/pages/form/budget_form_page.dart:7` → `transactions/…/category_picker_sheet.dart`
- `home/pages/widgets/budget_guard_card.dart:5` → `budgets/…/budget_status_badge.dart`
- `transactions/pages/form/add_transaction_page.dart:6` → `budgets/…/budget_warning_sheet.dart`

**Fix.**
- Move `app_settings_cubit.dart` + `app_settings_state.dart` to an app-global home — `lib/core/` (e.g. `lib/core/app_settings/`) or a dedicated top-level, since it owns theme/locale/name for the whole app, not a settings-screen concern. Update DI + `app.dart` + `main.dart` + `home_page.dart` + the settings screens' imports.
- Lift the 3 shared UI pieces into `lib/core/widgets/` (they're already generic): `category_picker_sheet`, `budget_status_badge`, `budget_warning_sheet`. Update the `widgets.dart` barrel + importers.

**Files:** `app_settings_cubit.dart`/`_state.dart` (move), `lib/dependencies_injection.dart`, `lib/app.dart`, `lib/main.dart`, the 4 importing files above, `lib/core/widgets/widgets.dart` barrel. Update `test/architecture/domain_layer_test.dart` only if it also asserts a no-`pages→pages` rule (consider **adding** that assertion here — cheap guard against regression).

---

## W5 — P2 cleanups (low-risk, do if time allows)

- **`CategoryIconAvatar.glyph()` factory** — the soft-tint icon square is copy-pasted 5× because the current API only takes a catalog key. Add `CategoryIconAvatar.glyph({required IconData icon, required Color color, double size})` and swap: `menu_tile.dart:35-44`, `budget_guard_card.dart:127-140`, `daily_review_card.dart:80-89`, `insight_card.dart:22-31`, `more_page.dart:121-129`. File: `lib/core/widgets/category_icon_avatar.dart` + 5 call sites.
- **Merge `SettingsCard` → `MenuSection`** — same hairline-divided AppCard group (`setting_option_tile.dart:52-68` ≈ `menu_tile.dart:72-96`; the dupe's own doc admits it). Keep the more-general `List<Widget>` container in `core/widgets`, delete the copy.
- **Shared `nextSortOrder` + `reorder`** — duplicated across `account_local_datasource.dart:36-40,74-84` ≈ `category_local_datasource.dart:32-38,71-81`. Extract a small mixin/helper (`SortableDao`) or a shared function taking the table name.
- **Map the FK-RESTRICT delete to a specific `Failure`** — deleting an account/category still referenced by transactions throws into a generic `CacheFailure` (`transaction_repository_impl.dart:71-74`). Detect the SQLite constraint error and return a localized "in use, can't delete" `Failure` (add ARB key id+en).

---

## Acceptance
- [ ] W1: `onCreate` builds latest deterministically; `schema_parity_test` passes; `budgets(period)` + `categories(type)` indexes added via `_v2`; `latestVersion` bumped to 2
- [ ] W2: `TransactionAggregator` pure (rule 19 clean), unit-tested; `home_cubit`/`insight_cubit` call it, inline copies deleted; behavior identical (existing cubit tests green)
- [ ] W3: SQL aggregate methods in the tx datasource + usecase; Insight consumes SQL sums; four month-bucket definitions not increased to five; cache decision noted
- [ ] W4: `app_settings_cubit` app-global; 3 shared widgets in `core/widgets`; **zero `pages→pages` imports remain** (grep clean); optional architecture-test rule added
- [ ] W5: icon-square −5 dupes; `SettingsCard` gone; sort/reorder shared; FK-in-use → localized `Failure`
- [ ] `analyze` 0 · `format` clean · build_runner green · ARB parity · **all prior tests + goldens unchanged & green** · coverage ≥40%
- [ ] No new route, no user-visible behavior change (except the friendlier delete-in-use message from W5)

## Not in V2-M0
The V2 features themselves (custom budget period = V2-M1; quick-tx, receipt, recurring, reconciliation = later). Dark-mode semantic-hue split (`AppPalette.light`==`.dark` for semantic tokens — audit caveat) — defer to a UI pass unless bundled with a feature.

---

### Reference-pattern note
`TransactionAggregator` becomes the third **pure calculation helper** (after `BudgetStatus`, `insight_rules`) and the canonical home for money-fold logic. The migration-parity test becomes the guard for all future `_vN`. Record both in memory as conventions once shipped.
