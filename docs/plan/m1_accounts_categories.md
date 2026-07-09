# M1 — Accounts & Categories (Master Data)

First real domain milestone. Builds the two master-data features every later screen depends on, and — because it is the first — **establishes jaga-saku's canonical Clean-Architecture pattern**. `lib/features/accounts/` becomes the reference feature that M2–M6 copy (the starter's `users/` is gone; do NOT resurrect it). Source of truth = `docs/jaga_saku_*.md` + `docs/Jaga Saku Mockup.png` + the M0 skeleton already on disk.

**Build order context:** M0 foundation ✓ → **M1 Accounts+Categories** → M2 Transactions/AddTx/Calendar → M3 Home → M4 Budget → M5 Insight → M6 More/Settings.

**Definition of done:** `flutter analyze` = 0, `dart format` clean, build_runner green, ARB id/en parity. From the More tab you can open **Accounts** and **Categories**, each with a working list + full CRUD (create / edit / delete / archive / drag-reorder). Accounts show a live SQL-derived balance (= opening balance in M1, since no transactions exist yet). Categories are expense/income tabbed with parent→child hierarchy. Icons come from `iconsax` via a shared catalog; category/account colors from a shared swatch set. A canonical test triple (datasource + repository + cubit) covers Accounts and Categories.

---

## 1. Dependencies (pubspec.yaml)

**Add:** `iconsax` (rounded, offline icon font — style guide §12). Nothing else; sqflite/freezed/fpdart/get_it/flutter_bloc already present from M0.

No dev deps to add — `sqflite_common_ffi`, `bloc_test`, `mocktail`, `alchemist`, `build_runner` are already there.

---

## 2. Shared icon & color system (`lib/core/resources/`)

Icons are stored in the DB as a **string key** (`icon TEXT`), colors as **ARGB int** (`color INTEGER`). Both features + all later screens resolve through one shared catalog — never map ad-hoc in widgets.

- **`app_icons.dart`** — `AppIcons`:
  - `static const Map<String, IconData> catalog` — curated `iconsax` set keyed by stable strings, grouped for the picker: money/accounts (`wallet`, `bank`, `ewallet`, `card`, `cash`, `savings`), food (`restaurant`, `coffee`, `groceries`), transport (`transport`, `car`, `fuel`), lifestyle (`shopping`, `entertainment`, `health`, `gift`, `home`, `bills`, `education`, `travel`), income (`salary`, `bonus`, `investment`), misc (`category`).
  - `static IconData resolve(String? key)` → `catalog[key] ?? Iconsax.category` (never throws on unknown/legacy key).
  - `static List<String> get pickerKeys` → catalog keys for the icon picker.
- **`category_colors.dart`** — `CategoryColors.swatches` = `List<int>` of ARGB values (the semantic + chart hues already used by the M0 seed: `0xFF16A34A, 0xFF3B82F6, 0xFFF59E0B, 0xFFEF4444, 0xFF8B5CF6, 0xFF64748B, 0xFF22C55E, 0xFF0EA5E9, 0xFFEC4899, 0xFF14B8A6, …`). Used by the color-picker swatch grid.

**Seed alignment (one-time):** M0's `seed.dart` uses Material-style icon keys (`directions_bus`, `local_cafe`, `account_balance`, …). Rename them to the `AppIcons` catalog keys (`transport`, `coffee`, `bank`, `ewallet`, `wallet`, `restaurant`, `shopping`, `entertainment`, `category`, `salary`). This only affects a fresh `onCreate` (seed never re-runs), so **delete the dev DB / reinstall** to reseed — note this in the walkthrough. No schema/migration change (data-only).

---

## 3. Canonical feature pattern (build Accounts first, mirror for Categories)

Both features use the exact same layering. This is THE reference — get it clean.

```
lib/features/accounts/
├── domain/                       # pure Dart. NO flutter, NO data/, NO core.dart (rule 19)
│   ├── entities/account.dart              # @freezed Account + enum AccountType
│   ├── repositories/account_repository.dart   # abstract; returns Either<Failure, T>
│   └── usecases/
│       ├── get_accounts.dart               # UseCase<List<Account>, NoParams>  (with balance)
│       ├── save_account.dart               # create+update (id null => insert)
│       ├── delete_account.dart             # hard delete, else archive on FK
│       ├── archive_account.dart            # set archived 0/1
│       └── reorder_accounts.dart           # persist new sort_order
├── data/
│   ├── models/account_model.dart           # @freezed row model + fromMap/toMap + toEntity()
│   ├── datasources/account_local_datasource.dart   # sqflite DAO over AppDatabase.db
│   └── repositories/account_repository_impl.dart    # try/catch Db → Right/Left(Failure)
└── pages/
    ├── list/  account_list_cubit.dart · account_list_state.dart · account_list_page.dart
    └── form/  account_form_cubit.dart · account_form_state.dart · account_form_page.dart
```

**Rules baked into the pattern (enforce, they set precedent):**
- Domain entities/usecases/repo-interfaces import only the **narrow barrels** (`core/error`, `core/usecase`) — never `core/core.dart`, never `package:flutter/*`, never `data/`. (`test/architecture/domain_layer_test.dart` fails CI otherwise.) → colors live as `int`, not `Color`; types as domain `enum`, not strings, inside the entity.
- Repository impl NEVER throws — wrap every datasource call in `try/catch` and return `Left(Failure)`. Map `DatabaseException` (sqflite) → `CacheFailure` (local-storage failure); unique-constraint violation → `ConflictFailure`; empty read where one is required → `NoDataFailure`. (Reuse the existing `Failure` subtypes in `core/error/failure.dart` — do NOT add new ones unless a case truly has none.)
- Local usecases still return `Future<Either<Failure,T>>` here (unlike settings prefs) because DB writes have a real failure surface — extend `UseCase<T, Params>`.
- Cubit folds `Either` → freezed state; `close()` any controllers; widgets use `if (!mounted)` after awaits; never call sl()/db from widgets.

### 3.1 `Account` entity (freezed, pure Dart)
Fields: `int? id`, `String name`, `AccountType type` (`cash|bank|ewallet`), `int openingBalance`, `String? icon`, `int? color`, `int sortOrder`, `bool archived`, `int createdAt`, and a **non-persisted** `int balance` (derived; defaults to `openingBalance`). `enum AccountType { cash, bank, ewallet }` with `value`/`fromValue`. Keep `balance` on the entity (populated by the balance query) — it is read-only view data, not a column.

### 3.2 `AccountModel` (data, freezed) + mapping
1:1 with the `accounts` row + the derived `balance` column. `factory AccountModel.fromMap(Map<String,Object?>)` (read `archived`/int→bool, `type` string→enum, coalesce `balance`), `Map<String,Object?> toMap()` (enum→string, bool→1/0, **omit `id` when null** so AUTOINCREMENT fires, omit derived `balance`), `Account toEntity()`. No `json_serializable` (removed in M0) — hand-write the maps.

### 3.3 `AccountLocalDatasource` (sqflite DAO)
Constructor takes `AppDatabase` (resolve `.db` per call). Methods:
- `Future<List<AccountModel>> getAccounts({bool includeArchived = false})` — the **balance query**:
  ```sql
  SELECT a.*,
    a.opening_balance
    + COALESCE((SELECT SUM(amount) FROM transactions WHERE type='income'   AND account_id   = a.id),0)
    + COALESCE((SELECT SUM(amount) FROM transactions WHERE type='transfer' AND to_account_id = a.id),0)
    - COALESCE((SELECT SUM(amount) FROM transactions WHERE type='expense'  AND account_id   = a.id),0)
    - COALESCE((SELECT SUM(amount) FROM transactions WHERE type='transfer' AND account_id   = a.id),0)
      AS balance
  FROM accounts a
  WHERE (:includeArchived OR a.archived = 0)
  ORDER BY a.sort_order, a.id;
  ```
  Correct once transactions land in M2; returns `opening_balance` today (empty `transactions`). Build the `WHERE` in Dart (`rawQuery`).
- `Future<int> insert(AccountModel)` / `Future<void> update(AccountModel)` / `Future<int> delete(int id)` (returns rows deleted) / `Future<void> setArchived(int id, bool)` / `Future<void> reorder(List<int> orderedIds)` (single `db.transaction` writing `sort_order = index`).

### 3.4 Cubits & states (freezed unions)
- `AccountListState` = `initial | loading | loaded(List<Account> items, bool showArchived) | error(Failure failure)`. `AccountListCubit`: `load()`, `toggleArchived()`, `archive(id)`, `delete(id)` (on `Left`/FK → fall back to archive + emit a soft message via return value/toast), `reorder(oldIndex,newIndex)` (optimistic list reorder → persist). Localize failures with `Failure.localize(context)` at the widget, not in the cubit.
- `AccountFormState` = `{ AccountType type, String name, int openingBalance, String? icon, int? color, bool saving, Failure? error, bool? saved }` (single freezed state class with `copyWith`, or an `initial/editing/saving/success/failure` union — pick the class form for a form). `AccountFormCubit(this._saveAccount, {Account? initial})`: seed fields from `initial` for edit; `submit()` validates (name non-empty, openingBalance ≥ 0) → `SaveAccount` → emit saved/failure.

### 3.5 Pages
- **`AccountListPage`** — `AppScaffold` + AppBar "Accounts" with a `+` action (→ form) and an archived-toggle action; body `BlocBuilder`: loading→shimmer list, error→`ErrorStateView` (retry=`load`), empty→`EmptyStateView` ("Belum ada akun" + CTA "Tambah Akun"), loaded→**Total Asset** header (Σ balances via `MoneyText`) then a `ReorderableListView` of `AccountTile`. Tile tap → edit form; long-press or trailing menu → archive/delete (via a confirm bottom sheet). Reorder → `cubit.reorder`.
- **`AccountFormPage`** — create/edit. `SegmentedControl` for `AccountType`, `TextFormField` name, `AmountInputField` opening balance, `SelectorField` "Icon" (→ `IconPickerSheet`), `SelectorField` "Color" (→ `ColorPickerSheet`), sticky `PrimaryButton` Save. Pop with a result on success so the list refreshes (or `context.pop(true)` → list re-`load()`s).

---

## 4. Categories feature (`lib/features/categories/`)

Same layering + rules as §3. Differences:

- **`Category` entity:** `int? id`, `String name`, `CategoryType type` (`expense|income`), `int? parentId`, `String? icon`, `int? color`, `int sortOrder`, `bool archived`, `int createdAt`. `enum CategoryType { expense, income }`.
- **Datasource:** `getCategories({required CategoryType type, bool includeArchived=false})` ordered by `sort_order, id`; the cubit groups into parents (`parentId == null`) each with their children (`parentId == parent.id`) for the indented tree in the wireframe. Insert/update/delete/setArchived/reorder as with accounts. **Delete cascade:** the self-ref FK is `ON DELETE CASCADE` — deleting a parent removes its children; surface this in the confirm sheet copy ("Menghapus kategori induk juga menghapus sub-kategorinya"). Budgets FK is also `ON DELETE CASCADE` (no budgets until M4, moot now).
- **Pages:** `CategoryListPage` uses a `SegmentedControl`/tab for Expense|Income at the top (style guide §13.9), then the grouped `ReorderableListView` (reorder within a type/sibling group). `+` opens `CategoryFormPage` (name, type, optional **parent** `SelectorField` filtered to same-type top-level categories, icon, color). Add-child entry: a `+` on a parent row pre-fills parent+type.
- **Reference-feature note:** Accounts is the primary template; Categories proves the pattern generalizes (hierarchy + typed tabs). Keep them structurally identical so M2 can copy either.

---

## 5. More screen wiring (`lib/features/more/`)

Replace the M0 `PlaceholderView` with the real grouped menu (mockup screen 5), but only the **Finance → Accounts / Categories** tiles are live in M1; everything else renders with a **"Soon"** badge and is inert (M4/M6). This builds most of the M6 More UI now; M6 only adds Settings/Appearance/About behavior.

- **`MorePage`** — scrollable `AppScaffold`:
  - App-info header card (icon placeholder + "Jaga Saku" + tagline).
  - **Finance:** Accounts (live → `/accounts`), Categories (live → `/categories`), Budget (Soon), Recurring (Soon).
  - **Data:** Export CSV (Soon), Backup & Restore (Soon).
  - **App:** Appearance (Soon), Security (Soon), Settings (Soon), About (Soon).
- Live tiles push their route; "Soon" tiles are visually muted + non-tappable (or a gentle toast "Segera hadir"). Group headers use `SectionHeader`.

---

## 6. New shared widgets (`lib/core/widgets/`)

Add only what's reused; keep them dumb (data in, callbacks out). Follow existing widget conventions (`context.colors`, `AppSpacing`, `AppRadius`).
- **`MenuTile`** — icon (40 rounded soft-bg container) + title + optional trailing badge + chevron; `onTap` nullable (null ⇒ muted/disabled). (style guide §13, More mockup)
- **`MenuSection`** — `SectionHeader` + an `AppCard` wrapping a divided `MenuTile` column.
- **`ComingSoonBadge`** — small pill ("Soon"), `surfaceSoft` bg + `textTertiary`.
- **`CategoryIconAvatar`** — 40×40, radius 12, soft category-color bg + `AppIcons.resolve(icon)` in the category color (style guide §12 "Category Icon Container"). Reused by every transaction tile M2+.
- **`AccountTile`** — leading `CategoryIconAvatar`(account icon/color) + name + type label, trailing balance `MoneyText`. Reorderable (needs a `key`).
- **`CategoryRow`** — parent/child row (indent for children) + icon avatar + name, trailing edit/reorder affordance.
- **`IconPickerSheet`** — bottom sheet (radius 24, handle) grid of `AppIcons.pickerKeys`; returns the selected key.
- **`ColorPickerSheet`** — bottom sheet swatch grid over `CategoryColors.swatches`; returns ARGB int.
- **`ConfirmSheet`** — reusable confirm bottom sheet (title, message, destructive-styled confirm + cancel) for delete/archive.

`AccountTile`/`CategoryRow` may instead live under their feature `pages/widgets/` if not reused — but the avatar, pickers, menu widgets, and confirm sheet are cross-feature → `core/widgets/`. Export new core widgets from `widgets.dart`.

---

## 7. Navigation (`lib/app_router.dart`)

Add full-screen routes on the root navigator (pushed from More, over the shell — same pattern as `/add`):
- `AppRoute.accounts = '/accounts'`, `AppRoute.accountForm = '/accounts/form'`
- `AppRoute.categories = '/categories'`, `AppRoute.categoryForm = '/categories/form'`

Form routes receive the entity to edit via `extra` (or push a fresh form for create). Provide each page's Cubit with a `BlocProvider` at the route builder (resolve usecases from `sl`). Keep list pages inside the More branch's navigation context so the shell bottom-nav persists? **No** — Accounts/Categories are detail screens: push on the root navigator (full-screen, own back), consistent with `/add`.

---

## 8. DI (`lib/dependencies_injection.dart`)

Register the two feature stacks after the M0 singletons (follow this order — datasource → repository → usecases; cubits are created per-route via `BlocProvider`, not registered as singletons, to avoid stale state):
```dart
// Accounts
sl.registerLazySingleton(() => AccountLocalDatasource(sl<AppDatabase>()));
sl.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl(sl()));
sl.registerLazySingleton(() => GetAccounts(sl()));
sl.registerLazySingleton(() => SaveAccount(sl()));
sl.registerLazySingleton(() => DeleteAccount(sl()));
sl.registerLazySingleton(() => ArchiveAccount(sl()));
sl.registerLazySingleton(() => ReorderAccounts(sl()));
// Categories — same shape
```
(Cubits `registerFactory` OR construct inline in the route's `BlocProvider(create:)` pulling usecases from `sl` — prefer inline factory in the route to keep DI lean.)

---

## 9. Localization (`lib/core/localization/intl_*.arb`)

Add keys to **both** `intl_en.arb` and `intl_id.arb` (parity gate). id is primary/user-facing. Needed set (≈): `accounts, categories, account, category, totalAsset, addAccount, editAccount, addCategory, editCategory, accountName, categoryName, accountType, openingBalance, icon, color, parentCategory, none, cash, bank, ewallet, expense, income, archive, unarchive, archived, showArchived, delete, deleteAccountConfirm, deleteCategoryConfirm, reorder, save, emptyAccountsTitle, emptyAccountsMessage, emptyCategoriesTitle, emptyCategoriesMessage, comingSoon, finance, data, app, budget, recurring, exportCsv, backupRestore, appearance, security, about`. Reuse existing keys (`save`, `settings`, `about`, `cancel`, `yes`) — don't duplicate. Run `flutter gen-l10n`; verify `dart run scripts/check_arb_parity.dart`.

---

## 10. Testing (canonical triple — sets the M2–M6 test template)

Mirror under `test/features/accounts/` and `test/features/categories/`. Use `sqflite_common_ffi` in-memory (already the M0 smoke-test approach) + `bloc_test` + `mocktail`; shared mocks + `registerFallbackValues` in `test/helpers/mocks.dart`.
- **Datasource test** (ffi, real in-memory DB seeded via `Migrations.onCreate`): insert→getAccounts returns it with `balance == openingBalance`; update; delete; reorder persists `sort_order`; category cascade delete removes children.
- **Repository test** (mock datasource): success → `Right`; thrown `DatabaseException` → `Left(CacheFailure)`; unique violation → `Left(ConflictFailure)`.
- **Cubit test** (`bloc_test`, mock usecases): `load` emits `[loading, loaded]`; usecase `Left` emits `[loading, error]`; form submit success emits saved.

Optional (not required for M1 DoD): an `alchemist` golden for `AccountTile`/`MenuTile`. Skip broader golden coverage.

---

## 11. Acceptance

- [ ] `flutter pub get` clean after adding `iconsax`
- [ ] `dart run build_runner build --delete-conflicting-outputs` green (freezed entities/models/states), generated files committed
- [ ] `flutter gen-l10n` + `check_arb_parity.dart` pass (id/en parity)
- [ ] `flutter analyze` = 0, `dart format` clean
- [ ] `flutter test` passes incl. the new datasource/repository/cubit tests
- [ ] More tab shows grouped menu; Accounts + Categories tiles open their screens; other tiles show "Soon"
- [ ] Accounts: list with Total Asset + per-account balance (= opening balance), create/edit/delete/archive/reorder all work and persist across app restart
- [ ] Categories: expense/income tabs, parent→child hierarchy, full CRUD + reorder; deleting a parent cascades children (confirmed in copy)
- [ ] Icons render from `iconsax` via `AppIcons`; colors from swatches; seed rows resolve to real icons
- [ ] Domain purity test still passes (no flutter/data/core.dart import from `domain/`)
- [ ] Nothing committed until user approves (CLAUDE.md)

## 12. Not in M1
Transactions / AddTransaction wiring (M2 — the `transactions` table stays empty; balance query already handles it), Calendar, Home cards, Budget + BudgetGuard (M4), Insight charts (M5), full More/Settings behavior + Appearance theme-switch + About + Security (M6), CSV export / backup (V2), recurring (V2), account-detail transaction history, category merge, multi-currency.

---

### Reference-pattern reminder
After M1 lands, **`lib/features/accounts/` is the canonical feature**. M2+ copy its layering (domain purity, `Either<Failure,T>` repo, sqflite DAO datasource, freezed cubit states, per-route BlocProvider). Update the memory/GUIDE to point new features at `accounts/` instead of the deleted `users/`.
