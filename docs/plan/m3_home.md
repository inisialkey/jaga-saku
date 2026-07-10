# M3 — Home Dashboard

Third domain milestone. Turns the Home tab (currently a placeholder) into the app's landing dashboard — "apakah kondisi uang saya masih aman?" at a glance. Pure **presentation over existing data** (accounts + transactions from M1/M2); Home adds no new table or datasource. Also pays down the **W2 debt from M2**: a shared "transactions changed" signal so Home *and* Calendar refresh live after any add/edit/delete. Source of truth = `docs/jaga_saku_low_fidelity_wireframe.md` §1 + `docs/jaga_saku_ui_design.md` screen 1 + `docs/jaga_saku_ui_style_guide.md` (§13.5–13.8) + `docs/Jaga Saku Mockup.png` screen 1.

**Build-order context:** M0 ✓ → M1 ✓ → M2 ✓ → **M3 Home** → M4 Budget → M5 Insight → M6 More/Settings.

**User-approved scope:** Budget Guard = **empty-state card now, real data in M4** · include the **cross-feature refresh signal** (fixes W2).

**Definition of done:** `flutter analyze` = 0, `dart format` clean, build_runner green, ARB id/en parity, coverage ≥40%. Home shows: header greeting, **Total Balance** hero (Σ account balances) + this-month income/expense, a **Budget Guard** card (friendly empty state until M4), a **Daily Review** card (today's spend / top category / unplanned), and **Recent Transactions** (3–5 tiles, "See All" → Calendar). Adding/editing/deleting a transaction anywhere (incl. the center FAB) refreshes Home and Calendar automatically.

---

## 1. Dependencies
**None.** Everything reuses M1/M2 (`GetAccounts`, `GetTransactionsByMonth`, `GetRecentTransactions`, `GetCategories`, `TransactionTile`, `MoneyText`, `AppCard`, `SectionHeader`, `EmptyStateView`).

---

## 2. Cross-feature refresh signal (W2 fix — build this first)

A lightweight broadcast that decouples "a transaction changed" from whoever must re-read. Fixes the M2 gap where the shell FAB's `/add` couldn't reach `CalendarCubit`.

- **`lib/core/utils/services/tx_change_notifier.dart`** — `TxChangeNotifier`: wraps a `StreamController<void>.broadcast()` (dart:async only — NO `flutter/foundation` `ChangeNotifier`, keeps it dependency-light + trivially testable). API: `Stream<void> get changes`, `void ping()`, `void dispose()`. Register as a **singleton** in `dependencies_injection.dart`.
- **Producers ping after a successful write:** `AddTransactionCubit.submit()` (after `SaveTransaction` succeeds) and every transaction delete path (`CalendarCubit.delete`) call `sl<TxChangeNotifier>().ping()`. (Inject the notifier into those cubits.)
- **Consumers subscribe:** `HomeCubit` and `CalendarCubit` subscribe to `changes` in their constructor and call their own `load()`/`refresh()` on each event; **cancel the subscription in `close()`** (rule 7). Guard with `isClosed`.
- **Retrofit note:** this touches M2 files (`add_transaction_cubit.dart`, `calendar_cubit.dart` + their DI/tests). Keep the change minimal — inject the notifier, ping on write, subscribe in calendar. The shell FAB (`app_shell.dart`) stays fire-and-forget `context.push('/add')` — the notifier makes awaiting unnecessary.

---

## 3. Home feature (`lib/features/home/pages/`) — presentation only

Home is an orchestration layer over existing usecases (like `calendar/`); it introduces **no** domain/data layer. Replace the M0 `PlaceholderView` in `home_page.dart`.

```
lib/features/home/pages/
├── home_cubit.dart        # orchestrates GetAccounts + GetTransactionsByMonth + GetRecentTransactions + GetCategories
├── home_state.dart        # @freezed: initial | loading | loaded(HomeDashboard) | error(Failure)
└── home_page.dart
```

- **`HomeCubit(this._getAccounts, this._getTransactionsByMonth, this._getRecentTransactions, this._getCategories, this._txChanges)`** — `load()`:
  1. `GetAccounts` → `totalBalance = Σ (non-archived) account.balance` (balances are already tx-derived from M1/M2).
  2. `GetTransactionsByMonth(now)` → fold into `monthIncome` / `monthExpense`; filter to **today** for the daily review: `todaySpent = Σ expense`, `topCategory` (max expense by category — resolve name via the categories map), `todayUnplanned = Σ expense WHERE plannedStatus == unplanned`.
  3. `GetRecentTransactions(5)` → `recent`.
  4. `GetCategories(expense)`+`(income)` (or a combined load) → id→Category map for name/icon resolution in the review + tiles.
  Compute a `HomeDashboard` view-model (freezed, in `home_state.dart`): `{ int totalBalance, int monthIncome, int monthExpense, int todaySpent, String? topCategoryName, int todayUnplanned, List<Transaction> recent, Map<int,Category> categoriesById, Map<int,Account> accountsById }`. Subscribe to `_txChanges.changes` → `load()`.
- **Empty/first-run:** no accounts/tx yet → total balance 0, daily review zeros, recent empty (`EmptyStateView` "Belum ada transaksi" + CTA → `/add`). Don't error on empty.

> Aggregation is done in Dart from the month's rows (personal-finance volumes are small) rather than new SQL — reuses M2 datasource as-is (ponytail). If profiling ever shows it matters, add SQL `SUM`s later.

---

## 4. Home widgets (`lib/features/home/pages/widgets/` unless reused elsewhere)

Follow style guide §13.5–13.8. Reuse `AppCard`, `MoneyText`, `TransactionTile`, `SectionHeader`, `CategoryIconAvatar`, `ProgressBarX`, `context.colors`.
- **`HomeHeader`** — greeting "Hi, {name}" (H1) + tagline (body, textSecondary) + a **notification bell icon** on the right that is **inert/decorative** in M3 (no notification system — stripped in M0; not in scope). ponytail-comment it.
- **`TotalBalanceCard`** (hero, style guide §13.5) — label "Total Saldo", big `MoneyText` (Display size, primary green card or surface per mockup), then this-month **Income** (green) + **Expense** (red) rows. Strongest visual on the screen.
- **`BudgetGuardCard`** (style guide §13.6) — **M3 = empty state**: title "Budget Guard", friendly copy "Belum ada budget — atur budget agar Jaga Saku bisa bantu pantau pengeluaranmu.", a CTA button styled per spec that is **inert / "Segera"** in M3 (budget CRUD is M4; do NOT route to a non-existent screen). Structure it so M4 can swap in the real remaining/safe-daily/progress/status content. ponytail-comment the deferral.
- **`DailyReviewCard`** (style guide §13.7, non-judgmental tone) — "Review Hari Ini", "Kamu sudah keluar {todaySpent}", "Kategori terbesar: {topCategory}", "Unplanned: {todayUnplanned}". Zero-state copy when nothing spent today ("Belum ada pengeluaran hari ini").
- **Recent Transactions** — `SectionHeader('Recent Transactions', actionLabel: 'See All', onAction: → Calendar)` + up to 5 `TransactionTile` (reuse M2; resolve names from the maps). "See All" does `context.go(AppRoute.calendar)` (branch switch within the shell). Empty → `EmptyStateView` + "Tambah Transaksi" CTA → `context.push('/add')`.

---

## 5. Greeting name

Read from `SettingsService.getString('user_name')` with a graceful fallback when unset (e.g. greeting without a name, or "Hi 👋"). Name **editing** lands in M6 (Settings). Do not build a name-input screen now. ponytail: one `getString` + fallback.

---

## 6. Routes / DI / l10n

- **Route:** Home is the existing first shell branch (`AppRoute.home` → `HomePage`). Provide `HomeCubit` via `BlocProvider(create:)` at that branch's route builder, pulling usecases + `TxChangeNotifier` from `sl`. "See All" uses `context.go(AppRoute.calendar)`.
- **DI** (`dependencies_injection.dart`): register `TxChangeNotifier` singleton; inject it into `AddTransactionCubit` + `CalendarCubit` (update their route `BlocProvider`s) and `HomeCubit`. No new datasource/repo (Home reuses M1/M2 usecases).
- **l10n** (both arb, id primary, parity; REUSE existing keys — `income`/`expense`/`account`/`category` already exist): add `greeting` (with `{name}` placeholder — use an ICU param), `tagline`, `totalBalance` ("Total Saldo"), `thisMonth`, `budgetGuard`, `budgetEmptyTitle`, `budgetEmptyMessage`, `createBudget`, `dailyReview`, `todaySpent` (`{amount}` param), `topCategory` (`{name}` param), `unplanned`, `noSpendingToday`, `recentTransactions`, `seeAll`, `emptyTransactionsTitle`, `emptyTransactionsMessage`, `addTransaction` (may exist from M2). Run `gen-l10n` + `check_arb_parity.dart`. Use `intl` plural/param syntax for the `{name}`/`{amount}` interpolations.

---

## 7. Testing

`test/features/home/` + a notifier test + a calendar retrofit test. `bloc_test` + `mocktail` (extend `test/helpers/mocks.dart` with the new usecase/notifier mocks) + `pump_app.dart` for any widget test.
- **`TxChangeNotifier` test:** `ping()` emits on `changes`; multiple listeners each receive; `dispose()` closes.
- **`HomeCubit` test:** given mocked usecases returning accounts + a month of transactions → `loaded` with correct `totalBalance`, `monthIncome`/`monthExpense`, `todaySpent`, `topCategoryName`, `todayUnplanned`, `recent`; a `Left` from any usecase → `error`; a `ping()` on the notifier triggers a reload (verify `load` re-runs).
- **`CalendarCubit` retrofit test:** a `ping()` triggers a refresh (subscription wired).
- Keep coverage ≥40% (Home cubit logic + notifier cover well). A `TotalBalanceCard`/`DailyReviewCard` golden is optional.

---

## 8. Acceptance
- [ ] `build_runner` green (freezed HomeState/HomeDashboard), generated committed
- [ ] `gen-l10n` + `check_arb_parity.dart` pass
- [ ] `flutter analyze` = 0, `dart format` clean
- [ ] `flutter test` green incl. Home cubit + notifier + calendar-retrofit tests; coverage ≥40%
- [ ] Home renders all sections; Total Balance = Σ account balances; month income/expense correct; daily review reflects today; recent = latest 5
- [ ] Budget Guard shows the empty state (no crash, CTA inert)
- [ ] Adding a tx via the center FAB updates Home's totals + recent AND the Calendar day list **without manual refresh** (W2 closed); editing/deleting likewise
- [ ] "See All" switches to the Calendar tab; empty states have working CTAs
- [ ] Domain-purity test passes; no new rule violations

## 9. Not in M3
Real Budget Guard data + safe-daily calc (M4), budget CRUD (M4), Insight charts (M5), settings/appearance/name-editing (M6), notifications (V2 — bell is inert), account-detail drilldown, per-category Home filters, pull-to-refresh animation polish.

---

### Reference-pattern note
Home + the `TxChangeNotifier` set two precedents: (a) a **presentation-only feature** that orchestrates other features' usecases through DI (no own domain/data) — M5 Insight will do the same; (b) a **cross-feature event signal** in `core` that any cubit can ping/subscribe. Record both in memory if they generalize further.
