# flutter_clean_starter 🧱

A production-oriented **Flutter Clean Architecture boilerplate**: feature-first structure, Cubit state management, `Either<Failure, T>` error handling, dependency injection, go_router, multi-flavor (dev/stg/prd), localization, codegen, and Firebase — wired and tested.

> Derived from a real production app, stripped to a reusable starter. Use `lib/features/users/` as the reference feature when adding your own.

📖 **Full developer guide:** [`docs/GUIDE.md`](docs/GUIDE.md) — architecture, setup, flavors, adding a feature, networking, testing, CI, release, and a white-label checklist.

## Stack

| Concern | Choice |
|---|---|
| State management | `flutter_bloc` (Cubit) |
| DI | `get_it` |
| Network | `dio` + `fpdart` `Either<Failure, T>` |
| Local storage | Hive CE + `flutter_secure_storage` |
| Routing | `go_router` |
| Codegen | `freezed` + `json_serializable` + `hive_ce_generator` |
| L10n | `intl` / ARB (en + id) |
| Lint | `package:lint/strict.yaml` |
| Firebase | Analytics + Crashlytics + Messaging (FCM push) |
| Flutter version | pinned via **FVM** (`.fvmrc`) |

## Architecture

```
lib/
├── core/        # api, error, theme, resources, localization, utils/services, widgets
└── features/<feature>/
    ├── data/     # datasources, models, repository impl
    ├── domain/   # entities, repository (abstract), usecases
    └── pages/    # pages, widgets, cubit + state
```

Flow: **UI (Cubit) → UseCase → Repository → DataSource**, with `Either<Failure, T>` crossing the data→domain boundary.

## Add a feature

Follow the **`users`** reference feature (`lib/features/users/`) — the canonical Clean-Architecture pattern (paginated list + detail/edit, `ApiResponse<T>` / `Page<T>`, `Either<Failure, T>`, Cubit + freezed). Mirror its layer layout for a new feature, then wire it up:

1. Register datasource / repository / usecases / cubits in `lib/dependencies_injection.dart` (+ the feature barrel import).
2. Add the `Routes` enum entries and `GoRoute`s in `lib/core/app_route.dart`.
3. Add the endpoint constants in `lib/core/api/list_api.dart`.
4. Add user-facing strings to both `intl_en.arb` + `intl_id.arb` (kept in parity).
5. Run `fvm dart run build_runner build --delete-conflicting-outputs` (freezed / json / hive).

## Getting started

```bash
fvm install
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter gen-l10n
fvm flutter run --flavor dev
```

### Configure a new project
1. Rename / white-label the app with `tool/rename_app.dart` (see below), choosing a reverse-domain bundle id (no underscores).
2. Fill `.env.dev.json` (placeholders committed); create `.env.stg.json` / `.env.prd.json` (git-ignored).
3. `flutterfire configure` to generate `google-services.json` / `GoogleService-Info.plist` (git-ignored — never commit real configs).

## Rename / white-label

The starter ships with neutral defaults — Dart package `flutter_clean_starter`, bundle id `com.example.cleanstarter` (`.dev` / `.stg` flavor suffixes), display name `Clean Starter`. Use the bundled tool to rebrand everything in one pass:

```bash
fvm dart run tool/rename_app.dart \
    --package my_new_app \
    --bundle  com.acme.myapp \
    --name    "My App"
```

What it changes:
- **Dart package** — `pubspec.yaml` `name:` plus every `package:<old>/` import across `lib/` and `test/`.
- **Bundle id / applicationId** — Android `build.gradle.kts` (`applicationId` + `namespace`), iOS `project.pbxproj`, xcschemes, `fastlane/Fastfile`, `fastlane/Matchfile`, and `ExportOptions-*.plist`. The `.dev` / `.stg` flavor suffixes are preserved.
- **Display name** — gradle `resValue` (`app_name` for dev/stg/prd), iOS `APP_DISPLAY_NAME` / `PRODUCT_NAME` / `*.app`, `Info.plist` `CFBundleName`, and the Dart `Constants.appName`.
- **Android MainActivity** — moves `MainActivity.kt` into the Kotlin package directory matching the new bundle id and rewrites its `package` declaration.

Flags:
- `--old-package` / `--old-bundle` — override the auto-detected current values (rarely needed).
- `--dry-run` — print every file that would change without writing.

Validation: `--package` must be `lower_snake_case`; `--bundle` must be valid reverse-domain (letters/digits only, no underscores, ≥ 2 segments).

The script is build tooling (it prints progress to stdout) and is idempotent-ish — re-running with the same values is a no-op.

> ⚠️ The script does **not** touch binary assets or Firebase configs. After renaming you must still:
> 1. Replace the branding PNG/JPEG assets in `assets/images/` (`ic_launcher*`, `ic_logo*`, `ic_logo_splash`, `background*`, `banner1`) — they still carry the original logo — then regenerate launcher icons / native splash from the `flutter_launcher_icons-*.yaml` / `flutter_native_splash-*.yaml` configs.
> 2. Run `flutterfire configure` to regenerate `google-services.json` / `GoogleService-Info.plist` for the new bundle id.
> 3. Set your own iOS signing `teamID` + provisioning profiles in `ios/fastlane/ExportOptions-*.plist`.

## Push notifications (FCM)

Firebase Cloud Messaging is wired end-to-end via `NotificationService`
(`lib/core/utils/services/notification/`). It requests notification permission,
fetches the FCM token, persists it to Hive under `MainBoxKeys.fcm`, re-persists
on token refresh, registers a background handler, and surfaces foreground / tap
streams for routing. Foreground messages are displayed as a heads-up
notification via `flutter_local_notifications`.

**Startup:** `NotificationService` is registered in
`lib/dependencies_injection.dart` (real app only — not in unit tests) and
`init()` is called from `lib/main.dart` AFTER `FirebaseServices.init()`, guarded
by try/catch so a missing Firebase config never blocks launch.

**Routing on tap:** subscribe from the app/router layer:

```dart
final notifications = sl<NotificationService>();

// Cold start (app launched from a terminated-state tap)
final initial = await notifications.getInitialMessage();
if (initial != null) { /* route using initial.data */ }

// Warm start (tapped while backgrounded)
notifications.onMessageOpenedApp.listen((m) { /* route using m.data */ });

// Foreground receipt (already shown via local notification)
notifications.onForegroundMessage.listen((m) { /* optional in-app UI */ });
```

**Topics:** `notifications.subscribeToTopic('news')` /
`unsubscribeFromTopic('news')`.

**Native setup (verify on a Mac + a configured Firebase project):**

- **iOS** — `ios/Runner/Runner.entitlements` declares `aps-environment`
  (`development`; switch to `production` for App Store / TestFlight). It is
  referenced via `CODE_SIGN_ENTITLEMENTS` in all 9 Runner build configs in
  `project.pbxproj`. `Info.plist` adds the `remote-notification` background
  mode. You still must: create an APNs Auth Key (or cert) in the Apple Developer
  portal, upload it to Firebase → Cloud Messaging, enable the **Push
  Notifications** capability in Xcode, and run `flutterfire configure` to drop
  the real `GoogleService-Info.plist`.
- **Android** — `POST_NOTIFICATIONS` permission (Android 13+) and a default FCM
  notification channel meta-data (`high_importance_channel`, matching
  `LocalNotificationHelper`) are in `AndroidManifest.xml`. Provide a real
  `google-services.json` via `flutterfire configure`. Swap the placeholder
  status-bar icon (`@mipmap/ic_launcher`) for a monochrome
  `@drawable/ic_notification` when available.

**Testing:** the FirebaseMessaging IO is integration-only. Unit tests cover only
the Firebase-free logic — token persistence into Hive and the topic
pass-throughs (`test/core/utils/services/notification/`).

## Certificate pinning

A TLS certificate-pinning hook ships **OFF by default** in
`lib/core/network/certificate_pinning.dart`. When disabled (or with an empty pin
list) it is a strict no-op — Dio keeps its default adapter and full platform TLS
trust; security is never weakened by its presence. When enabled it installs an
`IOHttpClientAdapter` whose `validateCertificate` only **accepts** a connection
if the leaf certificate's hash is in the allowlist (it can reject, never relax,
the normal chain validation).

**Hash used:** SHA-256 of the **full DER-encoded leaf certificate**, base64,
`sha256/`-prefixed. (Dart's `X509Certificate` exposes only the whole DER, not
the SPKI — so a full-cert pin is used; it rotates whenever the cert is
reissued.)

**Enable it:**

1. Compute the pin from your production host:

   ```sh
   openssl s_client -connect HOST:443 -servername HOST < /dev/null 2>/dev/null \
     | openssl x509 -outform der \
     | openssl dgst -sha256 -binary \
     | openssl enc -base64
   ```

   Prefix the output with `sha256/`.

2. In `lib/core/network/certificate_pinning.dart`, add the pin(s) to
   `kCertificatePins` and **always include a backup certificate's pin** so a key
   rotation doesn't brick installed apps. Set `kEnableCertificatePinning = true`.

`DioClient` calls `CertificatePinning.applyIfEnabled(_dio)` automatically (real
app only, never in unit tests). Pinning only matters for release builds against
real, controlled hosts.

## Continuous Integration

GitHub Actions (`.github/workflows/ci.yml`) runs on push to `main`/`develop` and on PRs:
Flutter (version read from `.fvmrc`) → `pub get` → `build_runner` → `gen-l10n` → **ARB parity** → **format check** (`lib test tool`) → **analyze** → **test + coverage** (incl. goldens) → **coverage gate** (VeryGoodOpenSource/very_good_coverage, generated/mocks excluded) → **build dev APK + iOS**.

- Needs **no secrets** — unit/widget tests mock their dependencies and don't init Firebase; real `google-services.json` / `GoogleService-Info.plist` are git-ignored and not required for `analyze`/`test`.
- The coverage floor is intentionally modest (`min_coverage: 40`) because UI/widget tests are sparse in the starter; **raise it** as you add widget/integration tests.
- Native release builds (apk/aab/ipa) are **not** in CI — they require Firebase config + signing secrets. Add a separate, secret-gated job per project.

## Conventions

See [CLAUDE.md](CLAUDE.md) for the full rule set, branching (GitFlow), flavors, and the reusable Claude Code agents/skills shipped under `.claude/`.

## Status

Boilerplate-in-progress. Roadmap: strip residual app-specific code → standardize patterns → complete `users` CRUD reference + 100% tests → white-label tooling → ✅ FCM + cert-pinning hook → ✅ GitHub Actions CI (Android + iOS) + coverage gate.

## License

TBD.
