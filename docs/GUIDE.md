# flutter_clean_starter — Developer Guide

A batteries-included **Flutter Clean-Architecture starter**: feature-first layering, BLoC/Cubit state, `get_it` DI, `dio` networking with `fpdart` `Either<Failure, T>`, Hive + secure storage, `go_router`, Firebase (Crashlytics / FCM / Analytics), full localization, and a GitHub Actions CI that builds **both Android and iOS**.

This guide is the full reference. For the quick pitch see [`../README.md`](../README.md); for the day-to-day rulebook see [`../CLAUDE.md`](../CLAUDE.md).

---

## Table of contents

1. [Tech stack](#1-tech-stack)
2. [Architecture](#2-architecture)
3. [Project structure](#3-project-structure)
4. [Prerequisites](#4-prerequisites)
5. [Getting started](#5-getting-started)
6. [Environments & flavors](#6-environments--flavors)
7. [App bootstrap](#7-app-bootstrap)
8. [Core services](#8-core-services)
9. [Adding a feature](#9-adding-a-feature)
10. [State management (Cubit)](#10-state-management-cubit)
11. [Networking & error handling](#11-networking--error-handling)
12. [Local storage](#12-local-storage)
13. [Routing](#13-routing)
14. [Localization](#14-localization)
15. [Code generation](#15-code-generation)
16. [Testing](#16-testing)
17. [CI/CD](#17-cicd)
18. [Build & release](#18-build--release)
19. [Backend contract](#19-backend-contract)
20. [Conventions (the rulebook)](#20-conventions-the-rulebook)
21. [White-label / fork checklist](#21-white-label--fork-checklist)
22. [Troubleshooting](#22-troubleshooting)

---

## 1. Tech stack

| Concern | Choice |
|---|---|
| Language / SDK | Dart `^3.10.0`, Flutter pinned via **FVM** (`.fvmrc`) |
| State management | `flutter_bloc` (Cubit) |
| Dependency injection | `get_it` (manual registration) |
| Networking | `dio` + `fpdart` `Either<Failure, T>` |
| Functional types | `fpdart` (`Either`, `Left`, `Right`, `Unit`) |
| Local storage | `hive_ce` (+ `hive_ce_flutter`), `flutter_secure_storage` |
| Routing | `go_router` (enum-named routes + redirect guards) |
| Codegen | `freezed`, `json_serializable`, `hive_ce_generator` via `build_runner` |
| Localization | `intl` + ARB (`en`, `id`) |
| Firebase | `firebase_core`, `firebase_crashlytics`, `firebase_messaging`, `firebase_analytics` |
| Lint | `package:lint/strict.yaml` + repo rules in `analysis_options.yaml` |
| Testing | `flutter_test`, `bloc_test`, `mocktail`, `alchemist` (goldens), `http_mock_adapter` |
| CI | GitHub Actions (Android + iOS builds, coverage gate) |

> **Mocking:** the repo uses **`mocktail` only** (no codegen mocks). **Functional errors** use **`fpdart`** (not the unmaintained `dartz`).

---

## 2. Architecture

**Clean Architecture, feature-first.** Each feature is a self-contained slice with three layers:

```
presentation (pages + Cubit)  →  domain (usecase / repo abstract / entity)  →  data (repo impl / datasource / model)
```

Data flow for a request:

```
Page → Cubit → UseCase → Repository(abstract) → RepositoryImpl → DataSource → DioClient → API
                                   ↑ returns Either<Failure, T> ↑
```

Rules of the layers:

- **`domain/`** is pure Dart — no Flutter, no `data/`, no feature barrels. It may import only the narrow `core` barrels (`core/error`, `core/usecase`, `core/models`) + `freezed_annotation` / `json_annotation`. Enforced by `test/architecture/domain_layer_test.dart` (fails CI).
- **`data/`** implements the domain repository, talks to `DioClient` / Hive, maps wire models → entities.
- **`pages/`** hold Cubits + widgets; never call `dio` / `Hive` / `getIt` directly from a widget — go through a Cubit/UseCase.
- The **`Either<Failure, T>`** boundary is crossed at the data→domain seam; failures never `throw` past the repository.

The reference feature is **`lib/features/users/`** — copy it when building a new feature.

---

## 3. Project structure

```
lib/
├── main.dart                     # entry: zone guard → Firebase → DI → runApp → FCM/remote-config
├── app.dart                      # root widget (MaterialApp.router, theme, l10n, providers)
├── dependencies_injection.dart   # get_it registrations (serviceLocator())
├── core/
│   ├── api/                      # DioClient, DioInterceptor, ListAPI (endpoints), ApiResponse
│   ├── network/                  # response envelopes, certificate pinning
│   ├── error/                    # Failure (sealed), ApiErrorCode, exceptions
│   ├── usecase/                  # UseCase<Type, Params> base, NoParams
│   ├── models/                   # Page<T>, PaginationMeta (generic API models)
│   ├── resources/                # asset paths, dimens, palette
│   ├── theme/                    # themeLight/themeDark, AppColors extension
│   ├── localization/             # ARB (intl_en/intl_id) + generated Strings
│   ├── constants/                # app config, feature-flag keys
│   ├── widgets/                  # shared widgets (Button, TextF, Parent, Empty, …)
│   ├── utils/
│   │   ├── services/             # CacheStore, RemoteConfig, Upload, Notification, Analytics,
│   │   │                         #   Connectivity, SecureStorage(AuthTokenService), Permission, Hive
│   │   ├── converters/           # BoolFromIntConverter, …
│   │   ├── ext/                  # context / string / failure extensions
│   │   └── helper/               # debouncer, etc.
│   ├── app_route.dart            # GoRouter config + Routes enum
│   └── core.dart                 # umbrella barrel
└── features/
    ├── users/                    # ⭐ reference CRUD feature (data/domain/pages)
    ├── auth/                     # login / register / session (full layers)
    ├── home/                     # tab shell + current user
    ├── settings/                 # settings + profile edit fields + account
    ├── onboarding/ · splash/     # entry flow
    └── app_status/               # force-update / maintenance gate pages
```

Tests mirror `lib/` under `test/` (+ hermetic widget-level flows can live in `test/e2e/`).

---

## 4. Prerequisites

- **FVM** (Flutter Version Management) — the Flutter version is pinned in `.fvmrc`.
- Xcode (for iOS) / Android SDK (for Android).
- A Firebase project (for Crashlytics / FCM / Analytics) — config files are git-ignored.

```bash
dart pub global activate fvm   # if not installed
fvm install                    # installs the Flutter version from .fvmrc
```

All commands below use the `fvm` prefix so they run on the pinned SDK.

---

## 5. Getting started

```bash
fvm install                                                   # Flutter from .fvmrc
fvm flutter pub get                                           # dependencies
fvm dart run build_runner build --delete-conflicting-outputs # freezed / json / hive
fvm flutter gen-l10n                                          # localized Strings
```

First-time per project:

1. **Env file** — `.env.dev.json` ships with placeholders; fill in real values (`BASE_URL`, `API_KEY`). Create `.env.stg.json` / `.env.prd.json` for the other flavors (git-ignored).
2. **Firebase** — run `flutterfire configure` to generate `google-services.json` (Android) and `GoogleService-Info.plist` (iOS). Both are git-ignored — never commit them. (iOS expects the plist under `ios/config/<flavor>/`.)

Run:

```bash
fvm flutter run --flavor dev --dart-define-from-file=.env.dev.json
```

---

## 6. Environments & flavors

Three flavors, each with its own env file (loaded via `--dart-define-from-file`):

| Flavor | Env file | Android bundle id | App name | Source branch |
|---|---|---|---|---|
| `dev` | `.env.dev.json` | `com.example.cleanstarter.dev` | Clean Starter DEV | `develop`, `feature/*` |
| `stg` | `.env.stg.json` | `com.example.cleanstarter.stg` | Clean Starter STG | `release/*` |
| `prd` | `.env.prd.json` | `com.example.cleanstarter` | Clean Starter | `main` |

Env keys (read via `String.fromEnvironment`):

```json
{ "ENV": "development", "BASE_URL": "http://10.0.2.2:3000/api", "API_KEY": "..." }
```

> `.env.dev.json` is committed with **placeholder** values; `.env.stg.json` / `.env.prd.json` are git-ignored. Set your own reverse-domain bundle id (no underscores) when white-labeling.

---

## 7. App bootstrap

`lib/main.dart` boots inside a `runZonedGuarded` (so uncaught errors reach Crashlytics):

1. `WidgetsFlutterBinding.ensureInitialized()`
2. `FirebaseServices.init()` — **must run before DI** (services touch Firebase in their constructors).
3. `serviceLocator()` — registers everything in `get_it`.
4. Lock orientation → `runApp(const App())`.
5. **After** `runApp` (so the OS permission prompt never blocks the first frame): FCM init (fire-and-forget) + remote-config fetch (offline-safe).

`lib/app.dart` is the root `MaterialApp.router` (theme, localization, top-level `BlocProvider`s, the `GoRouter`).

---

## 8. Core services

Singletons under `lib/core/utils/services/`, registered in `dependencies_injection.dart`, reached via Cubit/UseCase (never widgets):

| Service | Purpose |
|---|---|
| `CacheStore` | TTL'd JSON cache (Hive box); datasources go network-first → fall back to cache |
| `RemoteConfigService` | `GET /config` → feature flags (`isEnabled`); offline-safe defaults |
| `UploadService` | `image_picker` + multipart `POST /upload` |
| `NotificationService` | FCM + local notifications; tap → `onNotificationTap(route)` → `go_router` |
| `AnalyticsService` | wraps FirebaseAnalytics + a `go_router` observer (auto screen-view) |
| `AuthTokenService` | access/refresh tokens in `flutter_secure_storage` (hardened platform options) |
| `ConnectivityService` | online/offline state; interceptor rejects requests when offline |
| `PermissionService` | runtime permissions (camera/location/notification/…) |

In **unit-test mode** (`serviceLocator(isUnitTest: true)`) the Firebase-backed services + connectivity are skipped.

---

## 9. Adding a feature

Mirror the **`users`** reference (`lib/features/users/`). For a feature `product`:

```
lib/features/product/
├── product.dart                       # barrel (export data/domain/pages)
├── data/
│   ├── datasources/product_remote_datasources.dart   # DioClient calls, returns Either
│   ├── models/product_model.dart                      # @freezed + @JsonSerializable, .toEntity()
│   └── repositories/product_repository_impl.dart
├── domain/
│   ├── entities/product.dart                          # @freezed entity
│   ├── repositories/product_repository.dart           # abstract
│   └── usecases/get_products.dart, get_product.dart, …
└── pages/
    └── list/ , detail/ , edit/                         # page + cubit/ + freezed state
```

Then **wire it up** (the brick that used to do this was removed — do it by hand, it's ~5 spots):

1. **DI** — register datasource / repository / usecases / cubits in `lib/dependencies_injection.dart` (+ import the feature barrel).
2. **Routes** — add `Routes` enum entries + `GoRoute`s in `lib/core/app_route.dart`.
3. **Endpoints** — add path constants in `lib/core/api/list_api.dart`.
4. **Localization** — add user-facing strings to **both** `intl_en.arb` and `intl_id.arb` (kept in parity — CI enforces it).
5. **Codegen** — `fvm dart run build_runner build --delete-conflicting-outputs`.

Write tests alongside (usecase + cubit at minimum); see [Testing](#16-testing).

---

## 10. State management (Cubit)

Each screen has a `Cubit` + a **freezed sealed state**:

```dart
@freezed
sealed class UsersState with _$UsersState {
  const factory UsersState.initial() = UsersStateInitial;
  const factory UsersState.loading() = UsersStateLoading;
  const factory UsersState.loaded({required Page<User> page, required List<User> items}) = UsersStateLoaded;
  const factory UsersState.empty() = UsersStateEmpty;
  const factory UsersState.failure(Failure failure) = UsersStateFailure;
}
```

The Cubit calls a UseCase and folds the `Either` into a state:

```dart
final result = await _getUsers.call(GetUsersParams(page: _page, search: _search));
result.fold(
  (failure) => emit(UsersState.failure(failure)),
  (page) => emit(UsersState.loaded(page: page, items: page.items)),
);
```

The UI switches exhaustively over the sealed state. Always `close()` Cubits; sealed states give compile-time exhaustiveness.

---

## 11. Networking & error handling

**`DioClient`** (`lib/core/api/dio_client.dart`) wraps every request, returning `Either<Failure, T>` with a per-call `converter` that decodes the response body into `T`.

**`DioInterceptor`** (`lib/core/api/dio_interceptor.dart`) handles cross-cutting concerns:

- Rejects requests when offline (`ConnectivityService`).
- Injects the access token from `AuthTokenService`.
- **401 → single-flight token refresh** (Completer-locked; concurrent 401s await one refresh) → retries the original request; logs out on failure.
- **App-status gate** — backend `error_code` `FORCE_UPDATE_REQUIRED` / `MAINTENANCE_MODE` routes to a full-screen page (`lib/features/app_status/`) app-wide.
- Debug logs are **redacted**: sensitive headers (`authorization`, `x-api-key`, `cookie`, …) and `/auth/*` request/response bodies are masked; all logging is `kDebugMode`-gated.

**Failures** (`lib/core/error/failure.dart`) are a **sealed** hierarchy (`ServerFailure`, `ConnectionFailure`, `TimeoutFailure`, `UnauthorizedFailure`, `ValidationFailure`, `MaintenanceFailure`, `CacheFailure`, …). The interceptor maps `dio` errors + backend `error_code`s (`lib/core/error/error_codes.dart`) into the right `Failure`. UI never shows raw backend strings — map with `failure.localize(context)` (`Failure` → ARB string).

```dart
Future<Either<Failure, Page<User>>> getUsers(...) async {
  final result = await _client.getRequest<Page<User>>(
    ListAPI.users,
    queryParameters: {'page': page, 'limit': limit},
    converter: (res) => Page<User>.fromEnvelope(res!, (j) => UserModel.fromJson(j).toEntity()),
  );
  return result; // Left(Failure) on error, Right(page) on success
}
```

---

## 12. Local storage

- **`CacheStore`** — TTL'd JSON cache in a Hive box. Datasources are **network-first**: try the network, fall back to the cached payload on failure (cache writes are fire-and-forget so they never block the response).
- **`AuthTokenService`** — access/refresh tokens in `flutter_secure_storage`. Android uses the v10 default strong ciphers (RSA-OAEP + AES-GCM, auto-migrates legacy data); iOS keychain `first_unlock_this_device` (no iCloud/backup sync).
- Boxes are initialized in `serviceLocator()` before anything reads them.

---

## 13. Routing

`go_router` configured in `lib/core/app_route.dart`. Routes are an **enum** (`Routes`) so names/paths are type-safe:

```dart
context.pushNamed(Routes.userDetail.name, pathParameters: UserRouteArgs(id: id).toPathParameters());
```

- **Redirect guards** gate auth (logged-out → login; logged-in → away from auth pages) and the app-status pages.
- **Typed args** — the only path-param routes (`/users/:id` detail/edit) use `UserRouteArgs` (`fromState` in the builder, `toPathParameters` at call sites) instead of raw `state.pathParameters` / `state.extra` casts.
- A global `AppRoute.navigatorKey` lets non-UI code (interceptor, notifications) navigate.
- Never use ad-hoc `Navigator.push(MaterialPageRoute(...))` — register the route.

---

## 14. Localization

- ARB files: `lib/core/localization/intl_en.arb`, `intl_id.arb`. Generated `Strings` via `fvm flutter gen-l10n`.
- Read in widgets with `Strings.of(context)!.someKey`.
- **Both ARBs must stay in key parity** — enforced by `scripts/check_arb_parity.dart` (CI gate). Add a key to one → add it to the other.

---

## 15. Code generation

`build_runner` drives `freezed` (sealed states/entities), `json_serializable` (models), and `hive_ce_generator`:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

Generated files (`*.freezed.dart`, `*.g.dart`) **are committed**. Any change to a `@freezed` / `@JsonSerializable` / `@HiveType` type must rerun build_runner and commit the regenerated output **in the same PR**.

---

## 16. Testing

```bash
fvm flutter test                                    # unit + widget + golden
fvm flutter test test/e2e                           # hermetic full-flow tests (headless), if present
fvm flutter test --coverage                         # lcov → coverage/ (CI gate: min 40%)
fvm flutter analyze                                  # static analysis (CI gate: zero issues)
fvm dart format --set-exit-if-changed lib test tool  # format gate
fvm dart run scripts/check_arb_parity.dart           # ARB parity gate
```

- **Mocking: `mocktail` only.** Shared mocks + `registerFallbackValues()` live in `test/helpers/mocks.dart`. Idiom: `when(() => mock.m(any())).thenAnswer(...)`, `verify(() => mock.m(...))`.
- **Cubit tests** use `bloc_test`.
- **Golden tests** use `alchemist` — CI-deterministic goldens (no platform-specific rendering) under `**/goldens/ci/`. Regenerate with `fvm flutter test --update-goldens`. Configured in `test/flutter_test_config.dart` (which also registers mocktail fallbacks + a tolerant golden comparator for cross-platform AA noise).
- **Architecture test** (`test/architecture/domain_layer_test.dart`) enforces the domain-layer import firewall.
- Tag flaky tests `broken` (CI runs `--exclude-tags broken`).

---

## 17. CI/CD

GitHub Actions (`.github/workflows/ci.yml`), triggered on push to `main`/`develop` and PRs.

**Job `analyze-test`** (ubuntu): `build_runner` → ARB parity → `gen-l10n` → format check → `analyze` → test + coverage → coverage gate (40%, generated/mocks excluded).

**Job `build-dev`** (ubuntu): builds the dev APK (writes a placeholder `google-services.json`) — catches Gradle/manifest/plugin breakage.

**Job `build-ios`** (macOS): `flutter build ios --flavor dev --no-codesign` (writes a placeholder `GoogleService-Info.plist`) — catches CocoaPods/Swift/Xcode breakage.

Pipeline: `build_runner → ARB-parity → gen-l10n → format → analyze → test+coverage → coverage-gate(40%) → build-dev(apk) + build-ios(macOS)`.

---

## 18. Build & release

| Flavor | Command |
|---|---|
| dev | `fvm flutter build apk --flavor dev --release --dart-define-from-file=.env.dev.json` |
| stg | `fvm flutter build apk --flavor stg --release --dart-define-from-file=.env.stg.json` |
| prd | `fvm flutter build appbundle --flavor prd --release --dart-define-from-file=.env.prd.json` |
| iOS | `fvm flutter build ipa --flavor prd --release --dart-define-from-file=.env.prd.json` |

Branching follows **GitFlow**: `feature/*` → `develop` → `release/*` → `main` (+ `hotfix/*`). `main`/`develop`/`release/*` are protected — open PRs, never push directly.

---

## 19. Backend contract

The client assumes a consistent envelope:

- **Success:** `{ success, message, data, meta }` — list endpoints put pagination in `meta` (`Page<T>` / `PaginationMeta`).
- **Error:** `{ error_code, errors, request_id }` — `error_code` drives the `Failure` mapping + the app-status gate.
- **Quirk:** booleans like `is_active` arrive as int `1`/`0` → map with `@BoolFromIntConverter()` (`lib/core/utils/converters/`), never a raw `bool`.

Local dev points at `http://10.0.2.2:3000/api` (Android emulator → host machine) by default.

---

## 20. Conventions (the rulebook)

The full list is in [`../CLAUDE.md`](../CLAUDE.md). Highlights:

- No `dynamic` (except generated files). No `print()` → use `logger`; report production errors to Crashlytics.
- Repositories return `Left(Failure)` — never `throw` to the caller.
- No `dio` / `Hive` / `FirebaseAnalytics` / `getIt` calls from widgets — delegate to Cubit/UseCase.
- `dispose()` controllers / `close()` Cubits. Guard `context` after `await` with `if (!mounted) return;`.
- Register every `getIt` dependency in `dependencies_injection.dart`; register routes in `app_route.dart`.
- Keep `intl_en.arb` / `intl_id.arb` in parity. Map `Failure` → localized text; never surface raw backend strings.
- `domain/` may not import Flutter / `core/core.dart` / `data/` / feature barrels (firewall test enforces it).
- Run `fvm dart format lib test tool` before committing.

---

## 21. White-label / fork checklist

This starter is intentionally **batteries-included** — when forking for a real app, **delete what you don't use** rather than carry it:

1. **Rename** — set your own reverse-domain bundle id (`com.example.cleanstarter` → yours, no underscores), app name, and `name:` in `pubspec.yaml`.
2. **Firebase** — run `flutterfire configure` for your project; replace the git-ignored config files.
3. **Env** — fill `.env.dev.json`; create `.env.stg.json` / `.env.prd.json`.
4. **Trim services** — remove any of `RemoteConfigService` / `UploadService` / `NotificationService` / certificate pinning / deeplink you don't need (each is modular; drop its registration in `dependencies_injection.dart` + its dir).
5. **Replace the `users` feature** with your real first feature (keep it as a pattern reference until then).
6. **Raise the coverage gate** in CI as you add tests.

---

## 22. Troubleshooting

| Symptom | Fix |
|---|---|
| `[core/no-app]` on startup | `FirebaseServices.init()` must run before `serviceLocator()` / any Firebase use. |
| Build fails: missing `google-services.json` / `GoogleService-Info.plist` | Run `flutterfire configure` (files are git-ignored). iOS expects the plist under `ios/config/<flavor>/`. |
| `build_runner` conflicts | `fvm dart run build_runner build --delete-conflicting-outputs`. |
| CI format gate fails | `fvm dart format lib test tool` and commit. |
| CI ARB-parity fails | A key exists in one ARB but not the other — add it to both. |
| Golden test fails only in CI | Goldens must be the alchemist **CI** variant; regenerate with `fvm flutter test --update-goldens` (platform goldens are disabled, so dev-OS-generated goldens match Linux CI). |
| `mocktail` "type X is not registered as a fallback" | Add `registerFallbackValue(...)` for that type in `test/helpers/mocks.dart` → `registerFallbackValues()`. |
| Wrong base URL on Android emulator | Use `10.0.2.2` (not `localhost`) to reach the host machine. |
| iOS build fails: `Pods/FirebaseCrashlytics/run: No such file` | Flutter 3.44+ enables Swift Package Manager by default, but this project is on CocoaPods (Firebase's Xcode run-script uses the Pods path). Run `flutter config --no-enable-swift-package-manager`. CI does this in the `build-ios` job. |

---

*Generated for `flutter_clean_starter` v1.0.0+1. Keep this guide in sync with `CLAUDE.md` and `README.md` when patterns change.*
