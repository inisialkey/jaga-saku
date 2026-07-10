# M6 — More / Settings (final milestone)

Last milestone. Completes the **More** tab's "App" section: makes the app's theme + language user-controllable and persisted, adds the greeting-name editing deferred from M3, and an About screen. Wires the remaining in-scope "Soon" tiles (Appearance, Settings, About) live; Security/Recurring/Export/Backup stay V2. Source of truth = `docs/jaga_saku_low_fidelity_wireframe.md` §5 + `docs/jaga_saku_ui_design.md` screen 5 + `docs/jaga_saku_ui_style_guide.md` §20/§21 (light/dark) + §13.

**Build-order context:** M0 ✓ → M1 ✓ → M2 ✓ → M3 ✓ → M4 ✓ → M5 ✓ → **M6 More/Settings** (done ⇒ MVP complete).

**User-approved scope:** theme **Light / Dark / System** · language **System / ID / EN** · **separate** Appearance (theme) + Settings (language + name) screens.

**Definition of done:** `flutter analyze` = 0, `dart format` clean, build_runner green, ARB id/en parity, coverage ≥40%. From More: **Appearance** switches theme (light/dark/system) app-wide and persists across restarts; **Settings** switches language (system/id/en, persisted) and edits the greeting name (reflected on Home); **About** shows app name/tagline/version. Security stays "Soon".

---

## 1. Dependencies (pubspec.yaml)
**Add:** `package_info_plus` (read app name/version for About at runtime — the correct offline way vs hardcoding). Nothing else.

---

## 2. Reactive app settings (the core wiring)

`app.dart` currently hardcodes `themeMode: ThemeMode.light` and no `locale`. M6 makes both reactive + persisted.

- **`AppSettingsCubit` / `AppSettingsState`** (`lib/features/settings/pages/app_settings_cubit.dart` + freezed state) — the single app-global preferences owner. State: `{ ThemeMode themeMode, Locale? locale, String? userName }` (`locale == null` ⇒ follow system). Backed by `SettingsService` keys `theme_mode` (`light|dark|system`), `locale` (`system|id|en`), `user_name`.
  - `load()` reads all three (defaults: system theme? → **light** per style guide §20 default, or system — use `ThemeMode.light` default to honor "light is default"; make `system` an explicit choice; locale default null=system; name null). `setThemeMode`, `setLocale`, `setUserName` each persist via `SettingsService` + emit.
  - **Registered as a DI singleton**; `main.dart` `await sl<AppSettingsCubit>().load()` **before `runApp`** so there's no theme/locale flash on launch.
- **`app.dart` retrofit** — wrap `MaterialApp.router` in `BlocProvider.value(value: sl<AppSettingsCubit>())` + `BlocBuilder<AppSettingsCubit, AppSettingsState>`; feed `themeMode: state.themeMode` and `locale: state.locale`. Keep `theme`/`darkTheme`/`supportedLocales` as-is (`AppTheme.light`/`.dark` already exist; `L10n.all`).

---

## 3. Settings feature (`lib/features/settings/pages/`)

```
lib/features/settings/pages/
├── app_settings_cubit.dart / app_settings_state.dart   # §2, app-global
├── appearance_page.dart      # theme mode selector
├── settings_page.dart        # language selector + name editor
└── about_page.dart           # name / tagline / version / licenses
```
(Presentation + a settings cubit; no domain/data layer — `SettingsService` is the existing store. This is fine: prefs have no failure surface worth `Either` (see `usecase.dart` doc — local prefs are plain).)

- **`AppearancePage`** (More→Appearance) — a list of 3 options (Light / Dark / System) as selectable rows (radio/checkmark), current one ticked; tap → `context.read<AppSettingsCubit>().setThemeMode(...)` (instant, persisted). Style per §13 (rows in an `AppCard`, `context.colors`).
- **`SettingsPage`** (More→Settings) — sections:
  - **Language:** 3 options (System / Indonesia / English) → `setLocale` (system ⇒ null). Instant + persisted.
  - **Name:** a `TextField`/`SelectorField`-style row → edits `user_name` (`setUserName`). Reflected on Home (see §5). Empty ⇒ the M3 guest greeting.
- **`AboutPage`** (More→About) — app icon/name (`Constants.get.appName`), tagline, **version** via `package_info_plus` (`PackageInfo.fromPlatform()` → `version+buildNumber`), and a "Lisensi" row → Flutter's built-in `showLicensePage` (free, no extra work). Keep it simple/read-only.

---

## 4. More tiles → live (`lib/features/more/more_page.dart`)

In the "App" `MenuSection`: drop the `ComingSoonBadge` and add `onTap` for **Appearance** (`→ /appearance`), **Settings** (`→ /settings`), **About** (`→ /about`). **Security** keeps its `ComingSoonBadge` (V2). Update the page's doc-comment (Accounts/Categories/Budget + Appearance/Settings/About live; Security/Recurring/Export/Backup Soon).

---

## 5. Home greeting name — make it reactive

M3's `HomeHeader` reads the name from `HomeDashboard.userName` (loaded once by `HomeCubit`). To reflect a name change from Settings without an app restart: **`HomeHeader` reads the name from `AppSettingsCubit`** (a small `BlocBuilder<AppSettingsCubit>` for just the greeting), and `HomeCubit` stops loading `user_name` (drop `userName` from `HomeDashboard`, or leave the field unused — prefer dropping it to keep one source of truth). `AppSettingsCubit` is app-global (provided at the root), so `HomeHeader` can read it. ponytail: single source of truth for the name = `AppSettingsCubit`.

---

## 6. Routes / DI / l10n

- **Routes** (`app_router.dart`): `AppRoute.appearance='/appearance'`, `AppRoute.settings='/settings'`, `AppRoute.about='/about'` (root-nav full-screen). These pages `context.read<AppSettingsCubit>()` from the root-provided instance (no per-route cubit — it's the app-global singleton).
- **DI** (`dependencies_injection.dart`): register `AppSettingsCubit` as a **singleton** (constructed with `SettingsService`). No datasource/repo. `main.dart`: after `serviceLocator()`, `await sl<AppSettingsCubit>().load()` before `runApp(App())`.
- **l10n** (both arb, id primary, parity; reuse `settings`,`appearance`,`about`,`security`,`themeLight`,`themeDark`,`themeSystem`,`chooseLanguage`,`name`,`app` where they exist — several theme/language keys were in the starter ARB): add `themeMode`, `language`, `languageSystem`, `languageIndonesian`, `languageEnglish`, `editName`, `nameHint`, `appVersion` (`{version}`), `licenses`, `aboutTagline` (or reuse `appTagline`). `gen-l10n` + `check_arb_parity.dart`.

---

## 7. Testing

`test/features/settings/` + the Home retrofit. `bloc_test` + `mocktail` (mock `SettingsService`; extend `mocks.dart`); `pump_app.dart` for a screen smoke test.
- **`AppSettingsCubit`:** `load()` reads persisted theme/locale/name (and defaults when unset); `setThemeMode`/`setLocale`/`setUserName` each emit the new state AND call `SettingsService.setString` with the right key/value (`verify`); `system` locale ⇒ `null`.
- **Screens (widget):** AppearancePage shows 3 options with the current ticked and calls `setThemeMode` on tap; SettingsPage language + name edit; AboutPage renders name/version (mock `package_info_plus` via its test channel or inject a version — or a light smoke test).
- **Home retrofit:** `HomeHeader` shows the name from `AppSettingsCubit` (changing it updates the greeting) — a focused widget test.
- Keep coverage ≥40%.

---

## 8. Acceptance
- [ ] `flutter pub get` clean after adding `package_info_plus`
- [ ] `build_runner` green (freezed AppSettingsState), committed · `gen-l10n` + parity · `analyze` 0 · `format` clean
- [ ] `flutter test` green incl. AppSettingsCubit + settings screens + Home retrofit; coverage ≥40%
- [ ] Appearance: Light/Dark/System switches the app theme immediately and **persists across a restart**
- [ ] Settings: language System/ID/EN switches app locale immediately + persists; editing the name updates the **Home greeting** live
- [ ] About shows app name, tagline, real version; licenses page opens
- [ ] More: Appearance/Settings/About are live; **Security** still shows "Soon"
- [ ] No theme/locale flash on cold start (settings loaded before runApp)
- [ ] Domain-purity test passes; no new lint/format issues; dark mode renders correctly across all screens (spot-check Home/Calendar/Add/Insight/Budget)

## 9. Not in M6 (V2)
Security (app-lock/biometric), Recurring transactions, Export CSV, Backup & Restore, cloud sync, notifications, currency selection, onboarding. These keep their "Soon" badges.

---

### MVP complete
With M6 merged, all 5 main screens + supporting screens from the spec are built on the M0 foundation: Accounts/Categories (M1), Transactions/Add/Calendar (M2), Home (M3), Budget/Guard (M4), Insight (M5), More/Settings (M6). Dark mode + i18n now user-controlled. Remaining items are the V2 backlog above.

### Reference-pattern note
`AppSettingsCubit` is the app-global reactive-prefs pattern (theme/locale/name over `SettingsService`, loaded pre-`runApp`, consumed by `app.dart` + `HomeHeader`). Record in memory as the settings/theming convention.
