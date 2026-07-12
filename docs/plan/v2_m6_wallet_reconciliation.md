# V2-M6 — Wallet Reconciliation

Seventh V2 milestone. Lets a user reconcile an account: "I counted Rp 450.000 cash but the app says 480.000" → the app writes the **Rp 30.000 correction** so the derived balance matches reality. Because balance is *always* computed on read (`account_local_datasource.dart:19-30`, `opening + Σsigned tx` via 4 subqueries) there is **no stored balance to overwrite** — the correction must be a real ledger row.

**Build-order context:** V2-M0 ✓ → V2-M1 ✓ → V2-M2 ✓ → V2-M3 ✓ (**reused**: the reconcile "counted balance" input is the M3 calculator field) → V2-M4 ✓ → V2-M5 ✓ → **V2-M6 Reconciliation** → V2-M7 Money Story (**depends on** M6's system-category exclusion). Independent of the template spine (M2/M5).

**Source of truth:** the grill (2026-07-12). Representation = a **reserved "Penyesuaian" category pair** (income + expense) marked by a new `categories.system_key`; the adjustment is a normal income/expense row tagged that category — so it moves the balance for free (income/expense already sum into the balance SQL) but is **excluded from income/expense reports** the way transfers already are.

**Definition of done:** `analyze` 0, format, build_runner green, ARB parity, coverage ≥40%, schema-parity + migration tests green, existing V1/M1 tests + goldens green. Reconciling an account creates one correction transaction that fixes the balance; that correction never distorts Insight/Home income & expense totals; the reserved categories never appear in the normal category picker or list.

---

## 1. Dependencies
- **V2-M3** — the reconcile sheet's "counted balance" input is the shared `AmountInputField` calculator keypad (count cash with `+`).
- V2-M0 migration path for the `_vN`. **No new packages.**

## 2. Scope
- `categories.system_key` (nullable) + a seeded reserved pair (`adjustment_in` income, `adjustment_out` expense).
- A **reconcile sheet** launched from the account edit form: current balance → counted balance → live delta → confirm.
- Delta → one income/expense correction tagged the matching reserved category.
- **Exclude reserved categories** from income/expense aggregation (the one `TransactionAggregator` funnel) and **hide** them from the category picker + list.

## 3. Not in scope
- A distinct `TransactionType.adjustment` (the rejected option A — reserved-category reuse keeps the tx pipeline untouched).
- A separate `reconciliations` table / reconcile history view (the correction transactions in the ledger *are* the history).
- A per-account "balance detail" screen (none exists today; tapping an account opens the edit form — reconcile lives there).
- Reconciling multiple accounts in one flow.

---

## 4. Data model — `categories.system_key` + reserved pair
- `categories.system_key TEXT` (nullable). `NULL` = a normal user category. Reserved rows:
  - `{ name: 'Penyesuaian', type: income,  system_key: 'adjustment_in'  }`
  - `{ name: 'Penyesuaian', type: expense, system_key: 'adjustment_out' }`
- Categories are **typed** (`categories.type`, `migrations.dart:68-80`) and the picker filters by type — hence the **pair** (an income row for `+delta`, an expense row for `−delta`). Matched at runtime by `system_key`, so a rename/locale change can't break exclusion. `system_key` becomes a reusable "system category" marker for any future built-in category.

## 5. Database migration changes
- **`_v6`** (next sequential after M5's `_v5`; renumber per build order):
  1. `ALTER TABLE categories ADD COLUMN system_key TEXT;`
  2. Seed the reserved pair **idempotently** — `INSERT INTO categories (…) SELECT … WHERE NOT EXISTS (SELECT 1 FROM categories WHERE system_key = 'adjustment_in')` (and `_out`).
  - **Put the reserved-seed in `_v6`, not `Seed.run`** — `Seed.run` only runs on `onCreate`, but `_v6` runs under **both** `onCreate` (replay) *and* `migrate` (upgrade), so existing installs get the pair too. The `WHERE NOT EXISTS` keeps replay safe.
- Bump `latestVersion` → `6`; wire `_v6` into `onCreate` (`:24-27`) + `migrate` (`:31-37`).
- Extend `schema_parity_test`: `system_key` column present in both paths, `latestVersion == 6` (`:59-61`). (Parity is schema-only — `sqlite_master` + `PRAGMA table_info` — so seeded rows don't affect it, but both paths run `_v6` so both get the pair.)
- **Migration test:** v5→v6 adds `system_key`; the reserved pair exists exactly once (idempotent across replay); existing categories get `NULL`.

## 6. Domain / model changes
- **Entity** `category.dart`: add `String? systemKey`. `bool get isSystem => systemKey != null`.
- **Model** `category_model.dart`: add `systemKey` to the maps. Rerun build_runner.
- **`TransactionAggregator`** (`transaction_aggregator.dart`) — the one place income/expense funnels (V2-M0 W2): both `incomeExpense` (`:17-31`) and `expenseByCategory` (`:36-45`) gain an optional `Set<int> excludeCategoryIds = const {}`; skip a tx whose `categoryId` is in it. Adjustments (reserved-category income/expense) are thus removed from every report that uses the aggregator, exactly as transfers already are. **Pure, still flutter-free** (rule 19); the exclusion set is passed in, not resolved inside.
- **No pure calc helper** — the delta is `counted − current`, a one-liner; the *representation* is the design, not the math.

## 7. Datasource / repository / usecase changes
- **`CategoryLocalDatasource`**: `getCategories` returns `system_key`; add `getBySystemKey(String) → CategoryModel?` (resolve the reserved ids for the reconcile write). The normal category-list/picker path filters `system_key IS NULL` (see §9).
- **Balance SQL — UNCHANGED.** `account_local_datasource.dart:19-30` already sums income/expense into balance; the reserved-category adjustment is income/expense type, so it moves the balance with **no query change**. (This is the whole point of the reserved-category model.)
- **Usecases:** `GetSystemCategory(systemKey)` (resolve `adjustment_in`/`_out` ids); reuse the existing `SaveTransaction` for the correction row. No new save path.
- **`GetCategories`** callers that feed pickers/lists filter out `isSystem`; callers that feed **aggregation** (Home/Insight) collect `isSystem` ids into the aggregator's `excludeCategoryIds`.

## 8. Cubit / state changes
- **`ReconcileCubit`** (small, sheet-scoped) — deps: `GetSystemCategory` (resolve reserved ids once), `SaveTransaction`, `TxChangeNotifier`. State: `{ int currentBalance, int? counted, int get delta => (counted ?? current) − current }`. `countedChanged(int)` recomputes; `confirm()`: `delta == 0` ⇒ no-op + "sudah sesuai" toast; `delta > 0` ⇒ build an **income** tx (`amount: delta`, `categoryId: adjustment_in`, `accountId`, `date: today`, note "Penyesuaian saldo"); `delta < 0` ⇒ **expense** tx (`amount: −delta`, `categoryId: adjustment_out`); `SaveTransaction` + `ping()`.
- **`HomeCubit`** (`home_cubit.dart`) + **`InsightCubit`** (`insight_cubit.dart`): they already load categories to build `categoriesById` (`:126-129`); compute `excludeCategoryIds = categories.where(isSystem).ids` and pass it into every `TransactionAggregator.incomeExpense`/`expenseByCategory` call (`home_cubit.dart:131-132`, `insight_cubit.dart:132,135-137`). Their `_plannedSplit`/`_needVsWant` are already expense-only + null-guarded and adjustments carry no `plannedStatus`/`spendingType`, so those need no change — but the reserved expense would otherwise appear as a category slice, so the `expenseByCategory` exclusion is required.
- **`AddTransactionCubit.load`** (`:70-82`) + `AddTransactionState.categoriesForType` (`add_transaction_state.dart`): filter `!isSystem` so the reserved pair never shows in the normal tx category picker.

## 9. UI changes
- **Account edit form** (`account_form_page.dart`): a "Sesuaikan saldo" button/row, shown **only when editing** an existing account (a new account has no history to reconcile). Tap → the reconcile sheet.
- **Reconcile sheet** (`lib/features/accounts/pages/widgets/reconcile_sheet.dart`, uses `bottom_sheet.dart`): shows current balance (`MoneyText`), a counted-balance `AmountInputField` (M3 keypad), a live delta preview ("Akan menambah Rp 30.000" / "Akan mengurangi …" / "Saldo sudah sesuai"), and a confirm `PrimaryButton`.
- **Category picker** (`transactions/pages/widgets/category_picker_sheet.dart`) + **category list** (manage categories): filter `!isSystem` so reserved cats are neither pickable nor editable/deletable. Budget-form category picker likewise (can't budget "Penyesuaian").
- **Tx tile / detail**: an adjustment shows as a normal income/expense row labelled "Penyesuaian" — acceptable and honest (it *is* in the ledger); `MoneyText` renders its sign.

## 10. Routes / DI / l10n
- **Routes:** none (reconcile is a sheet).
- **DI** (`dependencies_injection.dart`): add `GetSystemCategory` to `_registerCategories`; `ReconcileCubit`'s `BlocProvider` (or a `create:` at the sheet) pulls `GetSystemCategory` + `SaveTransaction` + `TxChangeNotifier`. Home/Insight providers unchanged (they already have `GetCategories`).
- **l10n:** `reconcile` ("Sesuaikan saldo"), `reconcileCurrent`, `reconcileCounted`, `reconcileWillAdd` (`{amount}`), `reconcileWillSubtract`, `reconcileNoChange`, `reconcileNote` ("Penyesuaian saldo"), `categoryAdjustment` ("Penyesuaian"). `gen-l10n` + parity.

## 11. Testing plan
- **Migration:** v5→v6 adds `system_key`; reserved pair present exactly once (idempotent under replay); existing rows NULL; parity fresh==migrated; `latestVersion==6`.
- **`TransactionAggregator`:** `incomeExpense` with `excludeCategoryIds` drops adjustment rows from income & expense; `expenseByCategory` omits the reserved slice; empty exclude set = current behaviour (regression guard on existing tests).
- **`ReconcileCubit`:** `delta>0` ⇒ income tx with `adjustment_in` id + ping; `delta<0` ⇒ expense with `adjustment_out`; `delta==0` ⇒ no tx; correct amount sign/magnitude.
- **Balance integration** (sqflite_common_ffi): seed an account + tx, reconcile to a counted value, assert `getAccounts` balance now equals the counted value.
- **Report isolation:** an account with an adjustment ⇒ Home/Insight income & expense totals **unchanged** vs no-adjustment (the correction is invisible to reports but visible to balance).
- **Picker/list hiding:** `getCategories` for a picker excludes `isSystem`; category-list excludes them.
- **Goldens:** reconcile sheet (add / subtract / no-change states).

## 12. Acceptance
- [ ] `categories.system_key` via `_v6` in both paths; reserved pair seeded idempotently in `_v6` (not `Seed.run`); `latestVersion=6`; migration + parity tests green
- [ ] Reconcile sheet from account edit form; counted input uses the M3 keypad; delta preview correct for +, −, 0
- [ ] Confirm writes one income/expense correction tagged the reserved category; balance matches the counted value after
- [ ] Adjustments excluded from income/expense **reports** (aggregator `excludeCategoryIds`) but included in **balance** (unchanged SQL)
- [ ] Reserved categories hidden from tx picker, category list, and budget category picker; not editable/deletable
- [ ] `analyze` 0 · format · build_runner green · ARB parity · coverage ≥40% · existing V1/M1 tests + goldens green

## 13. Risks & edge cases
- **Reserved pair missing** (a botched migration) ⇒ `GetSystemCategory` returns null ⇒ reconcile must fail gracefully (guard + `logger`, disable confirm). The migration test is the guard against this shipping.
- **Two exclusion rules to keep in sync** — *reports* exclude system cats, *balance* includes them. A single integration test asserting "balance moves, totals don't" pins both.
- **Pre-existing user category named "Penyesuaian"** — no clash; matching is by `system_key`, not name.
- **Archiving/deleting a system category** — must be blocked in the category list (they're app-owned). Guard in the list cubit.
- **Adjustment on an archived account** — allowed (archived accounts still compute a balance); reconcile reachable if the archived account's edit form is.
- **Repeated reconciles** — each writes another correction row; the ledger accumulates an honest audit trail; balance always tracks the latest counted value.
- **Aggregator signature change** blast radius — every `incomeExpense`/`expenseByCategory` call site (Home `:131-132`, Insight `:132,135-137`) must pass the exclude set; a defaulted empty param keeps other/legacy callers compiling and behaviour-identical.

## 14. Recommended implementation order
1. Schema `_v6` (ALTER + idempotent reserved seed) + `latestVersion` + both paths; migration + parity tests (assert the pair) red→green.
2. `Category.systemKey` entity/model + build_runner; `getBySystemKey` + `GetSystemCategory`.
3. `TransactionAggregator` `excludeCategoryIds` param + unit tests (default = regression-safe).
4. Wire Home/Insight to pass the exclude set; filter pickers/list to `!isSystem`.
5. `ReconcileCubit` + reconcile sheet + account-form entry + goldens.
6. Balance + report-isolation integration tests.
7. l10n + parity; coverage sweep.

---

### Reference-pattern note
`categories.system_key` is the canonical **built-in-category** marker; the reconcile model proves the rule "corrections are ledger rows, excluded from reports like transfers, included in balance." Record that `TransactionAggregator` now takes an `excludeCategoryIds` set — M7's money-story cards depend on it. No code may assume "every income/expense tx is real income/spending."
