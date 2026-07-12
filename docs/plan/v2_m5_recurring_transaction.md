# V2-M5 — Recurring Transaction

Sixth V2 milestone, the largest. A **recurring rule = a `tx_templates` shape (from M2) + a schedule**. Offline means there is **no server cron** — the only trigger is app launch, where a **catch-up** pass computes due occurrences and surfaces them for the user to **confirm** (never silently posted — the "No Money Manager clone" line). Confirming reuses M2's `templateToTransaction()` pure helper.

**Build-order context:** V2-M0 ✓ → V2-M1 ✓ → V2-M2 ✓ (**prereq**: `tx_templates` + `templateToTransaction()`) → V2-M3 ✓ → V2-M4 ✓ → **V2-M5 Recurring** → V2-M6 Reconciliation → V2-M7 Money Story.

**Source of truth:** the grill (2026-07-12). Posting = generate-pending + confirm. Catch-up = backfill **all** overdue at **true due dates**, idempotent via a `next_due` cursor. Schedule = daily/weekly/monthly/yearly + interval N.

**Definition of done:** `analyze` 0, format, build_runner green, ARB parity, coverage ≥40%, schema-parity + migration tests green, existing V1/M1/M2 tests + goldens green. A rule generates pending occurrences at each launch; the user confirms (writing real transactions at their due dates) or skips (advancing the cursor without writing); re-opening never double-posts.

---

## 1. Dependencies
- **V2-M2** — the `tx_templates` table + `templateToTransaction()` helper (a recurring rule references a template; confirming builds the tx via the helper). **Hard prerequisite.**
- **V2-M1** — reuse `BudgetCycle`'s month-end day clamp (day 31 → last day of a short month). If M1 didn't extract it generically, pull out a shared `clampDayToMonth(year, month, day)` (`lib/core/utils/helper/date_math.dart`) that both `BudgetCycle` and `RecurrenceSchedule` use.
- V2-M0 migration path for the `_vN`. **No new packages.**

## 2. Scope
- `recurring` side-table (`template_id` → `tx_templates`, schedule, `next_due` cursor).
- `RecurrenceSchedule` pure helper (`nextOccurrence`, `dueOccurrences`).
- App-open **catch-up** → a pending count (Home badge) + a **review screen** (confirm per-item / confirm-all / skip).
- **Recurring manage** screen (list rules) + **recurring form** (shape + schedule).

## 3. Not in scope
- **Silent auto-post** and a per-rule "auto-post" toggle (additive V2.5 — the confirm path is the MVP; the toggle later just branches the catch-up).
- Back-link column on transactions (`recurring_id`) — provenance ("from Rent") is deferred; the `next_due` cursor alone gives idempotency, so a confirmed occurrence is just a normal, editable tx.
- Sub-monthly complex rules (nth-weekday, "1st & 15th") — that was the rejected RRULE-lite option.
- Notifications/reminders when the app is closed (no background scheduler offline; the review surfaces on next open).

---

## 4. Data model — new `recurring` table + one flag on `tx_templates`
```sql
CREATE TABLE recurring (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  template_id INTEGER NOT NULL REFERENCES tx_templates(id) ON DELETE CASCADE,
  freq        TEXT    NOT NULL,             -- daily/weekly/monthly/yearly
  interval    INTEGER NOT NULL DEFAULT 1,   -- every N units
  start_date  INTEGER NOT NULL,             -- first occurrence (midnight-local millis)
  end_date    INTEGER,                      -- optional inclusive last bound
  next_due    INTEGER NOT NULL,             -- cursor: earliest UNRESOLVED occurrence
  created_at  INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_recurring_due ON recurring(next_due);
```
- **`ON DELETE CASCADE`** — a recurring rule *owns* its template (created together); deleting the rule deletes its shape. (Contrast M2 favorites, which are user-owned templates.)
- **`tx_templates.is_favorite`** (added in M2, see the M2 patch): recurring-created templates set `is_favorite = 0` so they **do not** appear in the Home favorites strip (only drive the schedule). The M2 Home strip query filters `is_favorite = 1`. Amount is **required** for a recurring template (auto-generation needs it) — enforced in the form, not the schema.

## 5. Database migration changes
- **`_v5`** (next sequential after M4's `_v4`; renumber per build order): the `CREATE TABLE recurring` + `idx_recurring_due` above (`IF NOT EXISTS`, append-only, replay-safe).
- Bump `latestVersion` → `5`; wire `_v5` into `onCreate` (`:24-27`) + `migrate` (`:31-37`).
- Extend `schema_parity_test` index assertions (`idx_recurring_due`) + `latestVersion == 5` (`:59-61`).
- **Migration test:** v4→v5 creates `recurring` with exact columns + the FK to `tx_templates(id)`; assert `ON DELETE CASCADE` behaviour (delete a template row ⇒ its recurring row gone) and fresh==migrated parity.

## 6. Domain / model changes
- **Entity** `lib/features/recurring/domain/entities/recurring_rule.dart` — `@freezed RecurringRule`: `int? id, int templateId, RecurrenceFreq freq, @Default(1) int interval, int startDate, int? endDate, int nextDue, @Default(0) int createdAt`. `enum RecurrenceFreq { daily, weekly, monthly, yearly }` with `.value`/`fromValue` (mirrors `TransactionType` `transaction.dart:8-25`).
- **A view type** `PendingOccurrence` (`@freezed`): `{ int ruleId, TxTemplate template, int dueDate }` — a projected, not-yet-written occurrence for the review UI.
- **Model** `recurring_model.dart` — hand-written maps mirroring `transaction_model.dart:28-88`.
- **Pure helper** `lib/features/recurring/domain/recurrence_schedule.dart` — **flutter-free** (rule 19), unit-tested; the seventh pure calculation helper:
  - `int nextOccurrence(int fromMillis, RecurrenceFreq freq, int interval)` — daily `+interval*1d`, weekly `+interval*7d`, monthly `+interval months` (clamp day via M1's `clampDayToMonth`), yearly `+interval years` (clamp Feb 29 → Feb 28). Anchored to `start_date`'s day-of-month/weekday.
  - `List<int> dueOccurrences({required int cursor, required int until, int? endDate, ...})` — every occurrence date in `[cursor, until]` (inclusive of `until` = today's end-of-day), stopping at `endDate`. Drives catch-up.
  - Pure, deterministic, no clock inside (caller passes `until = todayMillis`).

## 7. Datasource / repository / usecase changes
- **`RecurringLocalDatasource`**: `getRules()` (join `tx_templates` for label/amount/shape), `insertRuleWithTemplate(TxTemplate, schedule)` — a **single `db.transaction`**: insert the template (`is_favorite=0`) → insert `recurring(template_id, …, next_due = start_date)`; `updateRule`, `deleteRule(id)` (CASCADE drops the template), `advanceCursor(ruleId, nextDue)`.
- **Repo** `RecurringRepository` + impl — `Either<Failure,T>`, `_guard`.
- **Usecases** (`domain/usecases/`):
  - `GetRecurringRules` — list for the manage screen.
  - `SaveRecurringRule` — insert (two-table txn) / update.
  - `DeleteRecurringRule`.
  - `GetDueOccurrences` — pure projection: read all rules, run `dueOccurrences(cursor: rule.nextDue, until: today)` per rule, flatten to `List<PendingOccurrence>` sorted by `dueDate`. **Writes nothing.**
  - `ConfirmOccurrence` — `templateToTransaction(template, date: dueDate)` → `SaveTransaction` → `advanceCursor(ruleId, nextOccurrence(dueDate,…))` → `TxChangeNotifier.ping()`. Idempotent: the cursor only moves forward.
  - `SkipOccurrence` — `advanceCursor(ruleId, nextOccurrence(dueDate,…))` only (no tx written).

## 8. Cubit / state changes
- **`HomeCubit`** (`home_cubit.dart`): add `GetDueOccurrences`; `load()` (`:64-114`) computes the pending count into `HomeState.pendingRecurring`. Home already listens to `TxChangeNotifier` (`:37/53`) so confirming refreshes it.
- **`RecurringReviewCubit`** + sealed state (loading/loaded{pending: List<PendingOccurrence>}/empty/error): loads via `GetDueOccurrences`; `confirm(occurrence)` → `ConfirmOccurrence` then drop it from the list; `confirmAll()` → loop; `skip(occurrence)` → `SkipOccurrence` then drop. Each action re-projects that rule (a rule with 3 overdue leaves 2 pending after one confirm).
- **`RecurringListCubit`** + sealed state (mirrors `account_list_cubit.dart`): list rules with a schedule summary; delete via `confirm_sheet`.
- **`RecurringFormCubit`** + `@freezed RecurringFormState`: the tx-shape fields (reuse M2's favorite-form shape — type/amount/account/category/planned/spending/note) **with amount required**, PLUS schedule fields (`freq`, `interval`, `startDate`, `endDate?`). `isValid` = shape valid **and** amount set **and** `startDate` set **and** (`endDate` null or `≥ startDate`). Save → `SaveRecurringRule` (two-table). On **schedule edit**, recompute `next_due` = the first occurrence `≥ max(startDate, today)` so a changed cadence doesn't backfill the whole past.

## 9. UI changes
- **Home**: a "Transaksi berulang (N)" badge/banner (only when `pendingRecurring > 0`) → tap → `/recurring/review`.
- **Review screen** (`/recurring/review`): a list grouped by rule — each pending item shows the template's `CategoryIconAvatar` + label + `formatRupiah(amount)` + due date; per-item **Konfirmasi**/**Lewati**, a header **Konfirmasi semua**. Empty ⇒ `EmptyStateView` "Tidak ada yang perlu dikonfirmasi".
- **Recurring manage** (`/recurring`): reorderless list (order by `next_due`) of rules — label + amount + schedule summary ("Tiap bulan, mulai 25 Jul") + next-due date; `AddButton` → form; tap → edit; delete via `confirm_sheet`.
- **Recurring form** (`/recurring/form`): the favorite-form body (`SegmentedControl` type, `AmountInputField` **required**, account/category `SelectorField`s, expense chips, note) + a **schedule** section: `ChoiceChipGroup<RecurrenceFreq>` (Harian/Mingguan/Bulanan/Tahunan), an interval stepper ("setiap [N]"), a start-date `SelectorField` (`showDatePicker`), an optional end-date row.

## 10. Routes / DI / l10n
- **Routes** (`app_router.dart`): `AppRoute.recurring = '/recurring'`, `recurringForm = '/recurring/form'`, `recurringReview = '/recurring/review'` (root-navigator, full-screen), each `BlocProvider(create:)` from `sl()`. Form takes `state.extra as RecurringRule?`.
- **DI** (`dependencies_injection.dart`): `_registerRecurring` (datasource → repo → 6 usecases). `HomeCubit`'s provider gains `GetDueOccurrences`. `ConfirmOccurrence` needs `SaveTransaction` + `TxChangeNotifier` + the recurring datasource + `templateToTransaction`.
- **l10n:** `recurring`, `recurringAdd`, `recurringEdit`, `recurringEmpty`, `recurringEvery` (`Setiap {n} {unit}`), `freqDaily/Weekly/Monthly/Yearly`, `recurringStartDate`, `recurringEndDate`, `recurringNextDue`, `recurringReviewTitle`, `recurringConfirm`, `recurringConfirmAll`, `recurringSkip`, `recurringPendingBadge` (`{count}`), `recurringDeleteConfirm`. `gen-l10n` + parity.

## 11. Testing plan
- **`RecurrenceSchedule` (pure) — the guard:** daily/weekly/monthly/yearly `nextOccurrence` for interval 1 and N; monthly Jan-31 → Feb-28/29 clamp then back to 31 in Mar (anchor preserved); yearly Feb-29 → Feb-28; `dueOccurrences` over a 3-month gap yields 3 monthly dates; respects `endDate` (excludes past it); none returned when `cursor > until`; deterministic (clock passed in).
- **Migration:** v4→v5 creates `recurring`; FK CASCADE (delete template ⇒ rule gone); parity fresh==migrated; `latestVersion==5`.
- **Datasource:** `insertRuleWithTemplate` atomic (both rows or neither); cascade delete; `advanceCursor` persists.
- **`GetDueOccurrences`:** projects correct pending across multiple rules, sorted; writes nothing.
- **`ConfirmOccurrence` / `SkipOccurrence`:** confirm writes a tx at `dueDate` (verify via a fake `SaveTransaction`) + advances cursor + pings; skip advances only; **idempotency** — running catch-up twice without confirming re-surfaces the same set; after confirming, the next projection excludes it.
- **`RecurringReviewCubit`:** confirm-one leaves the rest; confirm-all clears; skip drops without a tx.
- **`RecurringFormCubit`:** amount required; end ≥ start; schedule-edit resets `next_due` to `≥ today`.
- **Goldens:** review list (populated + empty), manage list, form schedule section.

## 12. Acceptance
- [ ] `recurring` via `_v5` in both paths; FK CASCADE; `latestVersion=5`; migration + parity tests green
- [ ] `RecurrenceSchedule` pure (rule 19), unit-tested incl. month/year clamps + gap backfill + `endDate` bound
- [ ] Catch-up surfaces **all** overdue occurrences at **true due dates**; confirm writes real tx (via `templateToTransaction`), skip advances only; **re-open never double-posts** (cursor idempotency test)
- [ ] Recurring templates hidden from the Home favorites strip (`is_favorite=0`)
- [ ] Manage + form + review screens wired; Home badge shows pending count
- [ ] `analyze` 0 · format · build_runner green · ARB parity · coverage ≥40% · existing V1/M1/M2 tests + goldens green

## 13. Risks & edge cases
- **Unbounded backfill** — a rule started years ago with a daily freq projects thousands of pending on first open. `// ponytail:` cap `dueOccurrences` at a sane bound (e.g. 60 items) and note the overflow in the review header; add real paging only if it bites.
- **Timezone / DST / midnight** — occurrences are midnight-local millis (like tx dates, `add_transaction_cubit.dart:123`); computing off local-midnight avoids DST hour drift. Store/compare consistently.
- **Editing a rule mid-stream** — changing freq/start recomputes `next_due` to `≥ today`; changing the amount/shape edits the template (affects *future* confirmations only — already-posted tx are untouched).
- **Deleting a rule with pending** — the pending vanish (rule + template CASCADE gone); acceptable.
- **Confirmed occurrence is a plain tx** — no back-link; editing/deleting it does **not** touch the rule (by design; provenance deferred).
- **Clock moved backward** (user changes device date) — `next_due` never rewinds (cursor only advances on confirm/skip); a backward clock simply produces no new pending until it catches up. No corruption.
- **App-open cost** — `GetDueOccurrences` reads all rules + projects each; cheap for realistic rule counts; it runs in `HomeCubit.load`, not blocking startup.
- **Amount-required invariant** — the form blocks saving a recurring rule without an amount even though the shared `tx_templates.amount` is nullable (favorites allow null).

## 14. Recommended implementation order
1. (If needed) extract `clampDayToMonth` from M1's `BudgetCycle`.
2. Schema `_v5` + `latestVersion` + both paths; entity/model + build_runner; migration + parity + CASCADE tests.
3. `RecurrenceSchedule` (`nextOccurrence` + `dueOccurrences`) + full pure suite (red→green).
4. Datasource (two-table insert, cursor advance) + repo + the 6 usecases + `_registerRecurring` DI.
5. `RecurringReviewCubit` + review screen + Home badge (`GetDueOccurrences` in `HomeCubit`).
6. `RecurringListCubit`/`RecurringFormCubit` + manage/form screens + routes.
7. l10n + parity; coverage + goldens sweep.

---

### Reference-pattern note
`RecurrenceSchedule` is the seventh **pure calculation helper**; the `next_due` **cursor** is the canonical idempotency mechanism for any "generate-on-open" work (no server cron offline). Recurring rules extend M2's `tx_templates` spine; record that a template's `is_favorite` flag separates user favorites (Home strip) from schedule-only shapes.
