# M0 — Foundation (Fondasi)

Spec-driven rebuild of the starter into Jaga Saku's base. No domain features yet — this is the skeleton every later milestone builds on. Source of truth = `docs/jaga_saku_*.md` + `Jaga Saku Mockup.png`.

**Definition of done:** app compiles, `flutter analyze` = 0, launches to a 5-tab shell (Home/Calendar/Add/Insight/More placeholders), green Plus-Jakarta-Sans theme (light+dark), sqflite DB opens + seeds defaults, no Firebase / no API / no auth anywhere.

---

## 1. Dependencies (pubspec.yaml)

**Remove:** `dio`, `hive_ce`, `hive_ce_flutter`, `flutter_secure_storage`, `permission_handler`, `firebase_core`, `firebase_analytics`, `firebase_crashlytics`, `firebase_messaging`, `flutter_local_notifications`, `connectivity_plus`, `image_picker`, `cached_network_image`, `crypto`, `json_annotation`, `json_serializable`(dev), `hive_ce_generator`(dev), `http_mock_adapter`(dev).

**Add:** `sqflite`, `path`, `fl_chart` · dev: `sqflite_common_ffi`.

**Keep:** `fpdart`, `equatable`, `get_it`, `flutter_bloc`, `oktoast`, `flutter_screenutil`, `logger`, `go_router`, `freezed`+`freezed_annotation`, `intl`, `url_launcher`, `flutter_native_splash`, `flutter_launcher_icons`, `alchemist`, `lint`, `bloc_test`, `mocktail`, `build_runner`.

Font: bundle **Plus Jakarta Sans** `.ttf` (offline — not `google_fonts`). Replace Inter entry with family `Plus Jakarta Sans` → `assets/fonts/PlusJakartaSans-Variable.ttf`. Remove `Inter-Variable.ttf`.

---

## 2. Delete (not in spec)

```
lib/features/auth/                      (login/register/privacy/terms)
lib/features/users/                     (API demo)
lib/features/home/                      (starter home — rebuilt in M3)
lib/features/onboarding/                (rebuild minimal later if needed)
lib/features/settings/                  (rebuilt in M6 against spec)
lib/features/splash/                    (keep a trivial splash only)
lib/features/app_status/                (force-update/maintenance = backend gate)
lib/core/api/                           (dio client/interceptor/list_api)
lib/core/network/                       (api_response, certificate_pinning)
lib/core/utils/services/firebase/
lib/core/utils/services/notification/
lib/core/utils/services/connectivity/
lib/core/utils/services/remote_config/
lib/core/utils/services/upload/
lib/core/utils/services/permission/
lib/core/utils/services/hive/
lib/core/utils/services/secure_storage/
lib/core/utils/services/cache/          (Hive TTL cache)
lib/core/models/pagination*             (API paging)
test/ mirrors of the above
```
Android: drop `com.google.gms.google-services` + `com.google.firebase.crashlytics` plugins + firebase deps in `android/app/build.gradle.kts`; delete placeholder `google-services.json`. iOS: remove Firebase/push entitlements later.

**Keep (survives):** `lib/core/theme/`, `lib/core/resources/`, `lib/core/error/`, `lib/core/usecase/`, `lib/core/utils/ext/`, `lib/core/utils/helper/` (prune Hive refs), `lib/core/widgets/` (button, text_f, shimmer, toast, empty, spacers, parent, loading), `lib/core/localization/`.

---

## 3. New structure

```
lib/
├── core/
│   ├── database/
│   │   ├── app_database.dart        # sqflite open + onCreate + onUpgrade + seed
│   │   ├── migrations.dart          # versioned DDL
│   │   └── seed.dart                # default accounts + categories
│   ├── theme/       app_colors, app_palette(ThemeExtension), app_theme(light+dark), text_theme
│   ├── resources/   dimens(AppSpacing/AppRadius/AppDurations), app_assets
│   ├── error/       failure, exceptions, error_codes
│   ├── usecase/     usecase base
│   ├── utils/       ext/, helper/ (money format, date), services/settings/ (sqflite KV)
│   ├── widgets/     shared components (see §6)
│   └── localization/ intl_id.arb, intl_en.arb
├── features/
│   ├── shell/       app_shell (StatefulShellRoute host + bottom nav + Add FAB)
│   ├── home/  calendar/  add_transaction/  insight/  more/   # placeholders in M0
│   └── ...          (filled M1–M6)
├── app.dart          MaterialApp.router + theme + l10n + screenutil
├── app_router.dart   go_router config (moved from core/app_route)
├── dependencies_injection.dart
└── main.dart         no Firebase — WidgetsFlutterBinding + DB init + DI + runApp
```

---

## 4. sqflite schema (v1 DDL)

Money = INTEGER rupiah (positive; sign implied by type). Dates = INTEGER epoch millis. Colors = INTEGER ARGB.

```sql
CREATE TABLE settings (
  key   TEXT PRIMARY KEY,
  value TEXT
);

CREATE TABLE accounts (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  name            TEXT    NOT NULL,
  type            TEXT    NOT NULL,          -- cash | bank | ewallet
  opening_balance INTEGER NOT NULL DEFAULT 0,
  icon            TEXT,
  color           INTEGER,
  sort_order      INTEGER NOT NULL DEFAULT 0,
  archived        INTEGER NOT NULL DEFAULT 0,
  created_at      INTEGER NOT NULL
);

CREATE TABLE categories (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  name       TEXT    NOT NULL,
  type       TEXT    NOT NULL,               -- expense | income
  parent_id  INTEGER REFERENCES categories(id) ON DELETE CASCADE,
  icon       TEXT,
  color      INTEGER,
  sort_order INTEGER NOT NULL DEFAULT 0,
  archived   INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL
);

CREATE TABLE transactions (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  type           TEXT    NOT NULL,           -- expense | income | transfer
  amount         INTEGER NOT NULL,           -- rupiah, > 0
  account_id     INTEGER NOT NULL REFERENCES accounts(id),
  to_account_id  INTEGER REFERENCES accounts(id),      -- transfer only
  category_id    INTEGER REFERENCES categories(id),    -- null for transfer
  planned_status TEXT,                        -- planned | unplanned (expense)
  spending_type  TEXT,                        -- need | want | lifestyle | emergency (expense)
  date           INTEGER NOT NULL,
  note           TEXT,
  created_at     INTEGER NOT NULL
);
CREATE INDEX idx_tx_date     ON transactions(date);
CREATE INDEX idx_tx_category ON transactions(category_id);
CREATE INDEX idx_tx_account  ON transactions(account_id);

CREATE TABLE budgets (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  category_id  INTEGER NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  period       TEXT    NOT NULL,             -- 'YYYY-MM'
  limit_amount INTEGER NOT NULL,
  created_at   INTEGER NOT NULL,
  UNIQUE(category_id, period)
);
```

**Derived (SQL, not stored):**
- account balance = `opening_balance + Σ(in) − Σ(out)` (income/transfer-in add; expense/transfer-out subtract)
- budget spent = `Σ amount WHERE category_id=? AND type='expense' AND period(date)=?`
- safe daily = `(limit − spent) / remaining_days_in_month`; status safe/warning(≥80%)/critical(≥100%)

Seed defaults: accounts `Cash`, `BCA`, `GoPay`; expense categories `Makan, Transport, Kopi, Belanja, Hiburan, Lainnya` (+ colors for donut), income `Gaji, Lainnya`.

> id = INTEGER autoincrement for MVP simplicity. Revisit UUID at Backup/Export (V2) for cross-device merge.

---

## 5. Theme tokens (style guide §4–11, 24)

- `AppColors` — primary `#16A34A`/`#15803D`/`#DCFCE7`; neutrals light+dark; semantic income/expense/transfer/warning/critical/info/success.
- `AppPalette extends ThemeExtension<AppPalette>` — income, expense, transfer, warning, critical, success, info, surfaceSoft, border, textSecondary, textTertiary (light + dark variants).
- `AppSpacing` xs4 sm8 md12 lg16 xl20 xxl24 xxxl32 · `AppRadius` sm8 md12 lg16 xl20 bottomSheet24 pill999 · `AppDurations` fast150 normal250 slow350.
- `textTheme` — Plus Jakarta Sans; Display32B/28B, H1 24B, H2 20SB, H3 18SB, Body 16/14R, Label 14SB/12M/11M.
- `AppTheme.light` / `.dark` wired into `MaterialApp.router`, default = light; dark per style guide §21 (surface not pure black).

---

## 6. Core widgets (MVP-priority, style guide §26)

Build/keep: `AppScaffold`, `AppCard`, `PrimaryButton`, `SecondaryButton`, `TextButtonX`, `AmountInputField`, `SelectorField`, `SegmentedControl`, `ChoiceChipGroup`, `MoneyText` (Rp formatter + sign color), `ProgressBarX`, `SectionHeader`, `EmptyStateView`, `ErrorStateView`, `AppBottomNav`, `AddButton`. (Cards/tiles specific to features come in their milestone.)

---

## 7. Navigation

`go_router` `StatefulShellRoute.indexedStack` with 4 branches (Home, Calendar, Insight, More). Center **Add** is not a tab — the FAB pushes `/add` (full-screen route) returning to the active tab on save. Bottom nav height 72, selected = primary green, unselected = textTertiary, Add = 56 circle green + white plus + medium shadow.

---

## 8. main.dart / DI

`main.dart`: `WidgetsFlutterBinding.ensureInitialized()` → `await AppDatabase.instance.open()` → `serviceLocator()` → `runApp(App())`. No Firebase, no runZonedGuarded/Crashlytics. `serviceLocator` registers `AppDatabase`, `SettingsService`(sqflite KV), then per-feature datasources/repos/usecases/cubits as milestones land.

---

## 9. Acceptance

- [ ] `flutter pub get` clean after dep swap
- [ ] `flutter analyze` = 0, `dart format` clean
- [ ] app launches → 5-tab shell, Add FAB opens placeholder `/add`
- [ ] light+dark green theme, Plus Jakarta Sans rendering
- [ ] DB file created, seed rows present (verify via a debug query/log)
- [ ] no `firebase`/`dio`/`hive` imports remain; Android builds without google-services.json
- [ ] id+en ARB parity (`scripts/check_arb_parity.dart`)

## Not in M0
Real screens/data (M1+), charts data, budget logic, insights, transaction CRUD, settings UI, branding assets (logo/splash/icon), tests beyond a DB smoke test.
```
