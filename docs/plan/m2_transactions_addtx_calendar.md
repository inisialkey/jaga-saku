# M2 — Transactions · Add Transaction · Calendar

Second domain milestone. Adds the ledger: the `transactions` table comes alive (CRUD), the **Add Transaction** screen (the `/add` route, currently a placeholder) becomes real, and the **Calendar** tab becomes a date-based ledger. Mirrors the **canonical pattern established in M1** (`lib/features/accounts/` — copy its layering exactly). Source of truth = `docs/plan/m2_transactions_addtx_calendar.md` + `docs/jaga_saku_low_fidelity_wireframe.md` §3 (Add) + §2 (Calendar) + `docs/jaga_saku_ui_style_guide.md` + `docs/Jaga Saku Mockup.png` (screens 2 & 3).

**Build-order context:** M0 ✓ → M1 Accounts+Categories ✓ → **M2 Transactions/AddTx/Calendar** → M3 Home → M4 Budget → M5 Insight → M6 More/Settings.

**User-approved scope decisions:** full tx CRUD (create/edit/delete) · include **transfer** (all 3 types) · Calendar via **`table_calendar`** dep · Budget-Guard warning **deferred to M4** (no budget data exists yet).

**Definition of done:** `flutter analyze` = 0, `dart format` clean, build_runner green, ARB id/en parity, coverage ≥40%. You can add an expense/income/transfer from the center **Add** FAB (`/add`), it persists and updates **live account balances** (M1's balance query already sums transactions). The **Calendar** tab shows a month grid with transaction dots, a selected-day summary (income/expense/balance) and that day's transaction list. Tapping a transaction opens it for **edit**; delete works via a confirm sheet. A shared `TransactionTile` (reused by Home M3 + Insight M5) renders category icon + detail + signed `MoneyText`.

---

## 1. Dependencies (pubspec.yaml)

**Add:** `table_calendar` (offline month-grid calendar — user-approved). No other runtime deps. `intl` (already present) formats dates. No new dev deps.

---

## 2. Transactions feature (`lib/features/transactions/`) — mirror `accounts/`

The canonical layering from M1 (see memory `jaga-saku-architecture` + `lib/features/accounts/`). Domain pure (rule 19), repo returns `Either<Failure,T>` and never throws, models hand-write `fromMap`/`toMap` (no json_serializable), cubits per-route.

```
lib/features/transactions/
├── domain/
│   ├── entities/transaction.dart        # @freezed Transaction + 3 enums
│   ├── repositories/transaction_repository.dart
│   └── usecases/
│       ├── get_transactions_by_month.dart   # UseCase<List<Transaction>, DateTime>  (month grid + dots)
│       ├── get_transactions_by_day.dart      # UseCase<List<Transaction>, DateTime>
│       ├── get_recent_transactions.dart      # UseCase<List<Transaction>, int limit>  (Home M3 reuses)
│       ├── save_transaction.dart             # UseCase<int, Transaction>  (id null => insert, else update)
│       └── delete_transaction.dart           # UseCase<Unit, int>
├── data/
│   ├── models/transaction_model.dart         # @freezed row model + fromMap/toMap/fromEntity/toEntity
│   ├── datasources/transaction_local_datasource.dart
│   └── repositories/transaction_repository_impl.dart   # _guard maps DatabaseException→CacheFailure
└── pages/
    └── form/  add_transaction_cubit.dart · add_transaction_state.dart · add_transaction_page.dart
```

### 2.1 `Transaction` entity (freezed, pure)
Fields (match the `transactions` table already in `lib/core/database/migrations.dart` — do NOT change schema): `int? id`, `TransactionType type`, `int amount` (rupiah > 0), `int accountId`, `int? toAccountId` (transfer only), `int? categoryId` (null for transfer), `PlannedStatus? plannedStatus` (expense only), `SpendingType? spendingType` (expense only), `int date` (epoch millis, keeps time-of-day), `String? note`, `int createdAt`.
Enums (pure Dart, `value`/`fromValue`): `TransactionType { expense, income, transfer }`, `PlannedStatus { planned, unplanned }`, `SpendingType { need, want, lifestyle, emergency }`.

### 2.2 `TransactionModel` + mapping
1:1 with the row. `fromMap` (string→enum, nullable enums from nullable TEXT), `toMap` (enum→string, omit `id` when null so AUTOINCREMENT fires), `fromEntity`/`toEntity`. Store `date` as-is (millis).

### 2.3 `TransactionLocalDatasource` (sqflite DAO)
Ctor takes `AppDatabase` (use `.db` per call, like `AccountLocalDatasource`). Methods:
- `insert(TransactionModel)` / `update(TransactionModel)` / `delete(int id)`.
- `getByMonth(DateTime month)` → `WHERE date >= ? AND date < ?` (month start inclusive → next-month start exclusive), `ORDER BY date DESC`.
- `getByDay(DateTime day)` → same with `[dayStart, dayStart+1day)`.
- `getRecent(int limit)` → `ORDER BY date DESC LIMIT ?`.
Compute the epoch-millis range bounds in Dart (`DateTime(y,m,1)` etc.). Use the `idx_tx_date` index (already created in M0).

### 2.4 Repository impl
Same `_guard` pattern as `AccountRepositoryImpl`: wrap every call, `DatabaseException`→`CacheFailure`, log via `log.e`, never throw. `delete` returns `Right(unit)`.

### 2.5 Balance goes live
No code change needed — M1's `AccountLocalDatasource.getAccounts` balance sub-query already sums `transactions` (income + transfer-in add, expense + transfer-out subtract). After a save/delete, the Accounts screen + any balance read reflects it. **Add a datasource test** proving a saved expense reduces the account balance and a transfer moves funds between two accounts.

---

## 3. Add Transaction page (`features/transactions/pages/form/`) — wireframe §3, style guide §13

Replaces the M0 placeholder. The `/add` route (root-nav full-screen, already in `app_router.dart`) points here; **edit reuses the same page** (pass a `Transaction` via `extra`). Delete the now-unused `lib/features/add_transaction/` placeholder folder and update the router import.

**Form (per transaction type — the segmented control drives which fields show):**
- `SegmentedControl` **Expense | Income | Transfer** (reuse M1 widget). Switching type resets type-specific fields (canonical: rebuild state, don't `copyWith` a field to null).
- `AmountInputField` (reuse) — large, `> 0` required.
- **Account** `SelectorField` → opens a new `AccountPickerSheet` (bottom sheet listing accounts from `GetAccounts`). For **transfer** this is "From Account".
- **To Account** `SelectorField` — **transfer only** — same picker, must differ from From.
- **Category** `SelectorField` → `CategoryPickerSheet` (from `GetCategories(type)` — expense→expense cats, income→income cats). **Hidden for transfer.**
- **Planned Status** — **expense only** — Planned/Unplanned via `ChoiceChipGroup` or two pills (reuse M1 `ChoiceChipGroup`).
- **Spending Type** — **expense only** — Need/Want/Lifestyle/Emergency via `ChoiceChipGroup`.
- **Date** `SelectorField` → `showDatePicker` (themed), default today; store selected day's millis (keep now's time-of-day, or midnight — pick midnight-local for determinism, note it).
- **Note** `TextField` (optional, `note`).
- Sticky bottom `PrimaryButton` **Save Transaction** / **Save Transfer**.

**Validation (in cubit, surface via localized message):** amount > 0; account required; category required for expense/income; toAccount required & ≠ account for transfer. Income/transfer omit planned+spending; transfer omits category.

**`AddTransactionCubit` / state (freezed):** holds the working transaction fields + `AddTxStatus { editing, saving, success, failure }`. Seed from the `extra` transaction for edit. `submit()` → `SaveTransaction` → success pops (`context.pop(true)`) so the origin (Calendar) reloads. Load accounts + categories on init (for the pickers) via `GetAccounts`/`GetCategories`.

> Budget-Guard warning (wireframe §3 "melewati batas aman") is **NOT in M2** — deferred to M4 when budgets exist.

---

## 4. Calendar page (`features/calendar/pages/`) — wireframe §2

Replaces the M0 placeholder (`features/calendar/calendar_page.dart`). Presentation over the transactions usecases; its cubit depends on `GetTransactionsByMonth` / `GetTransactionsByDay` (registered in DI, resolved from `sl`).

- **`table_calendar`** month grid, styled green: selected day = primary green circle (style guide §2 uses green highlight), today marker, **event dots** on days with transactions (feed from the month's transactions grouped by day). Month header with prev/next (table_calendar's `onPageChanged`).
- **Daily summary `AppCard`** below the grid: selected date, Income / Expense / Balance for that day (`MoneyText`, signed).
- **Daily transaction list**: `TransactionTile` per row (compact), with small Need/Want + Planned/Unplanned badges (wireframe §2). Empty day → `EmptyStateView` ("Belum ada transaksi").
- Tap a tile → push `/add` with the `Transaction` as `extra` (edit). Long-press / trailing → delete via `ConfirmSheet` (reuse M1) → `DeleteTransaction` → reload the day+month.
- **`CalendarCubit` / state (freezed):** `{ focusedMonth, selectedDay, monthTransactions, selectedDayTransactions, status }`. On month change → load month; on day select → filter/load day. Reload after returning from `/add`.

---

## 5. Shared widgets (`lib/core/widgets/`)

- **`TransactionTile`** (KEY — reused by Calendar now, Home M3, Insight M5): leading `CategoryIconAvatar` (category icon/color; for transfer use a transfer icon/`transfer` palette color), title (note or category name), subtitle (`category • account`, or day-view badges Need/Planned), trailing signed `MoneyText` (income=green `+`, expense=red `-`, transfer=blue/neutral). Reuse M1's `CategoryIconAvatar` + `MoneyText`.
- **`AccountPickerSheet`** — bottom sheet (reuse `AppBottomSheet` from M1) listing accounts (name + type + `CategoryIconAvatar`), returns the chosen `Account`. Takes an optional `excludeId` (for transfer To ≠ From).
- **`CategoryPickerSheet`** — bottom sheet listing categories of a given `CategoryType` (grouped parent/child like the M1 list), returns the chosen `Category`.

Pickers may live in `features/transactions/pages/widgets/` if you prefer feature-local, but Home/Insight reuse `TransactionTile` → keep at least `TransactionTile` in `core/widgets/` (export from `widgets.dart`). Badges = small pills via existing chip styling.

---

## 6. Routes / DI / l10n

- **Routes** (`app_router.dart`): `/add` already exists (root-nav full-screen) → real `AddTransactionPage`; edit = push `/add` with `extra: transaction`. Calendar is an existing shell branch. No new route constants needed (reuse `AppRoute.add`, `AppRoute.calendar`). Build cubits in the route's `BlocProvider(create:)` from `sl`.
- **DI** (`dependencies_injection.dart`): register `TransactionLocalDatasource` → `TransactionRepository` → the 5 usecases (datasource→repo→usecases order, `registerLazySingleton`). Cubits per-route (not singletons).
- **l10n** (both `intl_*.arb`, id primary, parity): add keys — `addTransaction, saveTransaction, saveTransfer, expense, income, transfer, amount, account, fromAccount, toAccount, category, plannedStatus, planned, unplanned, spendingType, need, want, lifestyle, emergency, date, today, note, noteHint, selectAccount, selectCategory, transferSameAccountError, amountRequiredError, accountRequiredError, categoryRequiredError, deleteTransaction, deleteTransactionConfirm, calendar, incomeLabel, expenseLabel, balanceLabel, emptyDayTitle, emptyDayMessage`. Reuse M1 keys where they exist (`account`, `category`, `delete`, `save`, `cancel`, `expense`/`income` may already exist from categories — check `intl_en.arb` and don't duplicate). Run `gen-l10n` + `check_arb_parity.dart`.

---

## 7. Testing (mirror M1's canonical triple + calendar)

`test/features/transactions/` and `test/features/calendar/`, sqflite-ffi + `bloc_test` + `mocktail` (extend `test/helpers/mocks.dart`; reuse `test/helpers/pump_app.dart` for any widget test):
- **Datasource (ffi):** insert expense/income/transfer; `getByMonth`/`getByDay` boundary correctness (last-ms-of-month, first-ms-of-next); `getRecent` order+limit; delete; **balance integration** — after insert, `AccountLocalDatasource.getAccounts` reflects the signed change; transfer moves between two accounts.
- **Repository:** success→Right; `DatabaseException`→`Left(CacheFailure)`.
- **AddTransactionCubit:** type switch clears category/planned/spending; validation Lefts (amount 0, missing account, transfer same account); save success emits success.
- **CalendarCubit:** load month → dots; select day → day list; delete reloads.

Optional (not required): a golden for `TransactionTile`. Keep coverage ≥40% (feature triple easily clears it).

---

## 8. Acceptance
- [ ] `flutter pub get` clean after adding `table_calendar`
- [ ] `build_runner` green (freezed Transaction/model/states), generated committed
- [ ] `gen-l10n` + `check_arb_parity.dart` pass
- [ ] `flutter analyze` = 0, `dart format` clean
- [ ] `flutter test` green incl. new datasource/repo/cubit tests; coverage ≥40%
- [ ] Add FAB → `/add`: create expense, income, and transfer; each persists
- [ ] Saving updates **live account balances** (Accounts screen reflects the signed sum; transfer moves funds)
- [ ] Calendar: month dots, day select → summary + list; tap tile → edit; delete via confirm sheet
- [ ] Type-specific fields show/hide correctly (transfer: from/to, no category; income: no planned/spending)
- [ ] Domain-purity test passes; repo returns `Either`, never throws

## 9. Not in M2
Budget-Guard safe-daily warning in Add (M4), Home cards / Recent-Transactions section (M3 — `GetRecentTransactions` is built now but wired to Home in M3), Insight charts (M5), recurring/CSV/backup (V2), transaction search/filter, multi-currency, split transactions, attachments.

---

### Reference-pattern note
`transactions/` copies `accounts/` (the canonical feature). Keep the layering identical so M3–M6 stay uniform. Update memory if any new cross-feature convention emerges (e.g. how a presentation feature — Calendar — depends on another feature's usecases through DI).
