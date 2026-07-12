# V2-M2 — Quick Transaction / Favorite

Third V2 milestone, first V2 **user-facing feature**. Lets a user save a transaction *shape* (a "favorite") and apply it in one tap. Introduces the **shared `tx_templates` table + `templateToTransaction()` pure helper** that V2-M5 (Recurring) builds directly on — a favorite is a shape you tap, a recurring is the same shape fired on a schedule.

**Build-order context:** MVP M0–M6 ✓ → V2-M0 Foundation Hardening ✓ → V2-M1 Custom Budget Period ✓ → **V2-M2 Quick Transaction / Favorite** → V2-M3 Calculator → V2-M4 Receipt → V2-M5 Recurring (**consumes M2's `tx_templates` + `templateToTransaction()`**) → V2-M6 Reconciliation → V2-M7 Money Story. **M2 is a prerequisite for M5.**

**Source of truth:** the pre-V2 audit + this milestone's grill (2026-07-12). A favorite = "a `Transaction` shape without a date."

**Definition of done:** `analyze` 0, `format` clean, build_runner green, ARB parity, coverage ≥40%, schema-parity + migration tests green, **all existing V1/M1 tests + goldens still pass**. New: tapping a fixed-amount favorite commits a transaction (with undo); tapping an amount-less favorite opens the add-form prefilled; favorites are managed under More and can be created from the add/edit form.

---

## 1. Dependencies
**None new.** Requires V2-M0's chained-`onCreate` migration path + `schema_parity_test` (adds the next `_vN`, relies on fresh installs replaying it). Reuses `SortOrderDao` (V2-M0 W5) for favorite ordering and the `TxChangeNotifier` (`tx_change_notifier.dart:18`) refresh bus.

## 2. Scope
- A `tx_templates` table storing the full tx shape (nullable amount) + a display `label` + `sort_order`.
- **Home favorites strip** — horizontal tappable chips; tap = **hybrid**: fixed-amount → instant commit (today, undo toast); amount-less → open add-form prefilled.
- **Favorites manage screen** under More (list + add/edit/delete/reorder), mirroring the Accounts list/form pattern (`account_list_page.dart`, `account_form_page.dart`).
- **"Save as favorite"** action in the add/edit transaction form that captures the current shape.

## 3. Not in scope
- Per-rule scheduling (that is V2-M5, which adds a `recurring` side-table on top of `tx_templates`).
- Folders/tags/search for favorites. Icons/colors *per favorite* (reuse the referenced category's icon/color for the chip).
- Transfer favorites are supported but not special-cased in UI beyond the existing transfer selectors.

---

## 4. Data model — new `tx_templates` table
A template is the add-tx shape (`transaction.dart:81` fields) minus `date`, plus `label` + `sort_order`. Same conventions as the ledger (`migrations.dart:11`: money INTEGER, no bool columns, enums as TEXT `.value`).

```sql
CREATE TABLE tx_templates (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  label          TEXT    NOT NULL,
  type           TEXT    NOT NULL,              -- expense/income/transfer
  amount         INTEGER,                       -- NULL = ask at use (prefill path)
  account_id     INTEGER NOT NULL REFERENCES accounts(id),
  to_account_id  INTEGER REFERENCES accounts(id),   -- transfer dest only
  category_id    INTEGER REFERENCES categories(id), -- expense/income only
  planned_status TEXT,                          -- expense only (parity w/ tx)
  spending_type  TEXT,                          -- expense only
  note           TEXT,
  is_favorite    INTEGER NOT NULL DEFAULT 1,    -- 1 = user favorite (Home strip); 0 = schedule-only shape (V2-M5)
  sort_order     INTEGER NOT NULL DEFAULT 0,
  created_at     INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_tpl_sort ON tx_templates(sort_order);
```
`planned_status`/`spending_type` are carried so an applied expense favorite reproduces the full shape — else every favorite-committed expense would drop out of Insight's planned/need-want folds. FK RESTRICT on `account_id` matches the ledger; deleting a referenced account already routes to archive (`account_list_cubit.dart:78-91`).

**`is_favorite` forward-compat (for V2-M5).** A recurring rule (M5) reuses this same table for its shape but must **not** clutter the Home favorites strip. `is_favorite` (int 1/0 — no bool columns, `migrations.dart:11`) defaults `1` for favorites created in M2; M5 inserts its schedule-only templates with `0`. The M2 Home-strip + Favorites-manage queries filter `is_favorite = 1`. Defining the column now (not retrofitting it in M5) is the M1 "store the flexible thing to avoid a rewrite" lesson.

## 5. Database migration changes
- **`_v3`** (next sequential; renumber if build order shifts — the M1 convention): the `CREATE TABLE tx_templates` + `idx_tpl_sort` above, wrapped so it is safe under **both** paths — `onCreate` replays `_v1`→`_v2`→`_v3` (fresh install), `migrate` runs `_v3` for `oldVersion < 3` (upgrade). `CREATE TABLE`/`CREATE INDEX` use `IF NOT EXISTS` (append-only, replay-safe, per V2-M0 W1).
- Bump `latestVersion` `migrations.dart:18` → `3`; wire `_v3` into `onCreate` (`:24-27`) **and** `migrate` (`:31-37`).
- **`schema_parity_test`** (`test/core/database/schema_parity_test.dart`) auto-covers the fresh-vs-migrated identity once `_v3` is in both paths; extend its explicit-index assertion (`:48-57`) to include `idx_tpl_sort` and bump the `latestVersion == 3` check (`:59-61`).
- New **migration test**: open a DB at v2, upgrade to v3, assert `tx_templates` exists with the exact columns (`PRAGMA table_info`).

## 6. Domain / model changes
- **Entity** `lib/features/templates/domain/entities/tx_template.dart` — `@freezed TxTemplate`: `int? id, String label, TransactionType type, int? amount, int accountId, int? toAccountId, int? categoryId, PlannedStatus? plannedStatus, SpendingType? spendingType, String? note, @Default(true) bool isFavorite, @Default(0) int sortOrder, @Default(0) int createdAt`. Reuses the existing `TransactionType`/`PlannedStatus`/`SpendingType` enums (`transaction.dart:8-68`); `is_favorite` maps int↔bool like `account_model` `archived` (`:37`).
- **Model** `data/models/tx_template_model.dart` — `@freezed`, hand-written `fromMap`/`toMap`/`fromEntity`/`toEntity` mirroring `transaction_model.dart:28-88` (omit `id` when null so AUTOINCREMENT fires; enums ↔ `.value`; nullable enums write `null`).
- **Pure helper** `lib/features/templates/domain/template_to_transaction.dart` — the canonical "shape → `Transaction`" builder, **flutter-free** (rule 19), unit-tested; mirrors `BudgetCycle`/`TransactionAggregator` precedent:
  - `Transaction templateToTransaction(TxTemplate t, {required int date, int? amount})` — resolves `amount ?? t.amount` (assert non-null), applies the same type-specific shaping as `add_transaction_cubit._commit` (`:169-206`): transfer ⇒ keep `toAccountId`, force `categoryId`/`plannedStatus`/`spendingType` null; expense/income ⇒ drop `toAccountId`.
  - Rerun build_runner, commit generated `.freezed.dart`.

## 7. Datasource / repository / usecase changes
- **`TxTemplateLocalDatasource`** (`data/datasources/`) mirroring `account_local_datasource.dart`: `getFavorites()` (`WHERE is_favorite = 1 ORDER BY sort_order, id` — the Home strip + Favorites manage screen; M5 reads schedule-only rows separately), `insert(model)→int` (append via `nextSortOrder`), `update(model)`, `delete(id)→int`, `reorder(orderedIds)` — the last two delegate `SortOrderDao`.
- **Repo** `TxTemplateRepository` + impl — `Either<Failure,T>`, `_guard` mapping like `account_repository_impl.dart:61-75`.
- **Usecases** (`domain/usecases/`): `GetFavorites` (favorites-only, `is_favorite=1`), `SaveTxTemplate` (insert when `id==null` else update), `DeleteTxTemplate`, `ReorderTemplates`.
- **Apply path** reuses the existing `SaveTransaction` usecase — no new "apply" usecase; the cubit calls `templateToTransaction()` then `SaveTransaction` then `TxChangeNotifier.ping()` (exactly the `_commit` tail, `:204`).

## 8. Cubit / state changes
- **`FavoritesListCubit`** + sealed state (initial/loading/loaded{items}/error) — mirrors `account_list_cubit.dart` incl. optimistic reorder + delete-via-`confirm_sheet`.
- **`FavoriteFormCubit`** + `@freezed FavoriteFormState` — mirrors `account_form_cubit.dart`: fields `label, type, amount(int?), accountId, toAccountId?, categoryId?, plannedStatus?, spendingType?, note`; getters `isTransfer`, `isExpense`, `selectableAccounts`, `categoriesForType`, `isValid` (`label` non-empty; account set; transfer ⇒ toAccount set & ≠ account; expense/income ⇒ category set; **amount optional**). Accepts an optional prefill (for "save as favorite").
- **`HomeCubit`** (`home_cubit.dart`) gains `GetFavorites` (load the strip into `HomeState.favorites`) + `SaveTransaction` (instant-commit) + `DeleteTransaction` (undo). New method `applyFavorite(TxTemplate)`: if `amount != null` → build+save+ping, emit an `undoableCommit(txId)` signal for the toast; else emit a `navigateToPrefill(template)` signal. Home already subscribes to `TxChangeNotifier` (`:37/53`) so the strip and cards refresh on commit.
- **`AddTransactionCubit`** (`add_transaction_cubit.dart`): accept a new `AddTransactionArgs { Transaction? edit; TxTemplate? prefill }` (replacing the bare `extra as Transaction?`). `_seed` (`:46-65`) branches: `edit` ⇒ current editing behavior (`isEditing:true`); `prefill` ⇒ populate fields from the template with `isEditing:false, id:null, amount = t.amount ?? 0, date = today`. Add a `saveAsFavorite()` signal that hands the current shape to `/favorites/form`.

## 9. UI changes
- **Home** (`home_page.dart`): a `SectionHeader('Favorit')` + horizontal `ListView` of favorite chips (each = `CategoryIconAvatar.glyph(...)` from the referenced category + `label` + optional `formatRupiah(amount)`), between the balance/guard cards and the recent list. Empty ⇒ hide the section (no clutter). Tap → `HomeCubit.applyFavorite`; the `undoableCommit` signal shows a `Toast` with an **Undo** action → `DeleteTransaction(txId)` + ping.
- **Favorites screen** (`/favorites`): `AppScaffold` + reorderable list of favorite tiles (icon + label + amount/"—") + `AddButton`; tap → edit; swipe/long-press → delete via `confirm_sheet`. A near-clone of `account_list_page.dart`.
- **Favorite form** (`/favorites/form`): `SegmentedControl<TransactionType>` + `label` field + `AmountInputField` (with a "biarkan kosong = isi tiap pakai" hint for the optional amount) + `SelectorField`s (account, to-account if transfer, category if expense/income) + expense chips (`ChoiceChipGroup`) + note — the add-tx form minus date, plus label.
- **Add/edit tx** (`add_transaction_page.dart`): a star/bookmark action in the app bar → `saveAsFavorite()`.

## 10. Routes / DI / l10n
- **Routes** (`app_router.dart`): add `AppRoute.favorites = '/favorites'`, `AppRoute.favoriteForm = '/favorites/form'` (root-navigator, full-screen, like `/accounts`/`/accounts/form` `:150-164`), each wrapped in a `BlocProvider(create:)` pulling `sl()`. Update the `/add` route (`:134`) to read `state.extra as AddTransactionArgs?`; update the FAB (`app_shell.dart:32`) to pass `AddTransactionArgs(edit: …)`.
- **DI** (`dependencies_injection.dart`): new `_registerTemplates` (datasource → repo`<TxTemplateRepository>` → 4 usecases, all `registerLazySingleton`, per the `_registerBudgets` template `:90-97`). `HomeCubit`'s `BlocProvider` gains `GetFavorites`+`SaveTransaction`+`DeleteTransaction`.
- **l10n** (id primary/EN template `intl_en.arb`): `favorites`, `favoriteAdd`, `favoriteEdit`, `favoriteEmpty`, `favoriteLabel`, `favoriteAmountOptional`, `favoriteSaveAs`, `favoriteApplied`, `favoriteUndo`, `favoriteDeleteConfirm`. `gen-l10n` + `check_arb_parity.dart`.

## 11. Testing plan
- **`templateToTransaction` (pure):** amount override wins over `t.amount`; missing both ⇒ assert; transfer drops category/planned/spending & keeps `toAccountId`; expense keeps planned/spending & drops `toAccountId`; date passed through.
- **Migration:** v2→v3 creates `tx_templates` with exact columns; `schema_parity_test` fresh-vs-migrated identical incl. `idx_tpl_sort`; `latestVersion == 3`.
- **Datasource:** CRUD + `nextSortOrder` append + `reorder` (via `SortOrderDao`, already tested in isolation).
- **`FavoritesListCubit` / `FavoriteFormCubit`:** `bloc_test` — load, save (insert vs update), delete, reorder, validation (amount optional, transfer distinctness).
- **`HomeCubit.applyFavorite`:** fixed-amount ⇒ `SaveTransaction` called + ping + undoable signal; amount-less ⇒ prefill signal, **no** save. Undo ⇒ `DeleteTransaction` + ping.
- **Goldens** (`alchemist`, CI variant): favorites strip (populated + empty-hidden), favorites list, favorite form.
- Existing add-tx tests updated for the `AddTransactionArgs` param (edit path unchanged).

## 12. Acceptance
- [ ] `tx_templates` table via `_v3` wired into `onCreate` + `migrate`; `latestVersion=3`; migration + parity tests green
- [ ] `tx_templates.is_favorite` present (default 1); Home strip + Favorites screen filter `is_favorite=1` (forward-compat for M5 schedule-only shapes)
- [ ] `templateToTransaction()` pure (rule 19), unit-tested; shared by favorites (M2) and ready for recurring (M5)
- [ ] Home strip: fixed-amount favorite one-tap commits with working Undo; amount-less favorite prefills add-form as a **new** (not editing) tx
- [ ] Favorites manage screen: add/edit/delete/reorder, mirrors Accounts; "Save as favorite" works from add/edit tx
- [ ] `analyze` 0 · format · build_runner green · ARB parity · coverage ≥40% · existing V1/M1 tests + goldens unchanged & green

## 13. Risks & edge cases
- **Editing vs prefill collision** — passing a template as a `Transaction` would trip `_seed`'s `isEditing:true` (`:46-65`); the `AddTransactionArgs` union avoids it. Test both branches.
- **Undo race** — user taps another favorite before undo expires; each commit carries its own `txId`, undo targets that id only.
- **Archived/edited references** — a favorite pointing at an archived account still applies (archived accounts are valid tx targets); a favorite whose category was deleted ⇒ FK RESTRICT blocks the delete (archive fallback) so the reference stays valid. Deleting an account/category *only* referenced by a favorite still archives rather than hard-deletes — acceptable, note in UI copy.
- **Transfer favorite** — must validate `toAccountId != accountId` in the form (reuse `transferSameAccount` rule, `add_transaction_cubit.dart:245-249`).
- **Amount-less transfer/income favorite** — allowed; always takes the prefill path.

## 14. Recommended implementation order
1. Schema `_v3` + `latestVersion` + wire both paths; entity + model + build_runner; migration + parity tests (red→green first).
2. `templateToTransaction()` helper + unit test.
3. Datasource + repo + usecases + `_registerTemplates` DI.
4. Favorites list + form cubits/pages + routes; goldens.
5. `AddTransactionArgs` refactor (edit path parity) + "Save as favorite".
6. Home strip + `applyFavorite` (instant-commit + undo) + prefill navigation.
7. l10n keys + parity; final `analyze`/`format`/coverage sweep.

---

### Reference-pattern note
`templateToTransaction()` is the fifth **pure calculation helper** (after `BudgetStatus`, `insight_rules`, `TransactionAggregator`, `BudgetCycle`) and the canonical "shape → `Transaction`" builder. `tx_templates` is the shared spine V2-M5 extends with a `recurring` side-table. Record both as conventions once shipped.
