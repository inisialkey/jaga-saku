# CLAUDE.md

**CRITICAL:** Never auto-commit. Always ask the user "Work complete. Commit and create pull request? (yes/no)" before any `git commit` / `git push` / `gh pr create`.

---

## Project Stack

Flutter app (`flutter_clean_starter`). **Clean Architecture per feature** (`data/` → `domain/` → `pages/`). State via flutter_bloc (Cubit), DI via get_it, network via dio + fpdart `Either<Failure, T>`, local storage Hive CE + flutter_secure_storage, routing go_router, codegen freezed + json_serializable + hive_ce_generator (build_runner), localization intl/ARB, lint `package:lint/strict.yaml`, Firebase (Crashlytics + Messaging/FCM + Analytics all wired; Analytics via `AnalyticsService` + a go_router `FirebaseAnalyticsObserver`). CI via GitHub Actions. Flutter version managed via FVM (see `.fvmrc`).

**Full developer guide:** `docs/GUIDE.md` (architecture, setup, adding a feature, testing, CI, release, white-label).

---

## Quick Start

```bash
fvm install                                                  # Flutter version from .fvmrc
fvm flutter pub get                                          # dependencies
fvm dart run build_runner build --delete-conflicting-outputs # .g.dart / .freezed.dart / hive
fvm flutter gen-l10n                                         # localization (Strings)
fvm flutter run --flavor dev                                 # run dev flavor
```

First-time per project: copy `.env.dev.json` and fill values; run `flutterfire configure` to generate `google-services.json` / `GoogleService-Info.plist` (these are git-ignored, never committed).

**Add a new feature** by following the `users` reference feature (`lib/features/users/`) — the canonical Clean-Architecture pattern (`ApiResponse<T>`/`Page<T>`, `Either<Failure,T>`, Cubit+freezed). After adding the layers, register the datasource/repo/usecase/cubit in `lib/dependencies_injection.dart`, add routes in `lib/core/app_route.dart`, add endpoints in `lib/core/api/list_api.dart`, then run `build_runner`.

---

## Environment

Flavor-specific env files (loaded via `--dart-define-from-file`):

| File | Flavor | Purpose |
|------|--------|---------|
| `.env.dev.json` | `dev` | Development / internal testing (placeholder values committed) |
| `.env.stg.json` | `stg` | Staging / QA (git-ignored) |
| `.env.prd.json` | `prd` | Production (git-ignored) |

---

## Build Flavors

| Flavor | Source branch | Build command |
|---|---|---|
| `dev` | `develop`, `feature/*` | `flutter build apk --flavor dev --release` |
| `stg` | `release/*` | `flutter build apk --flavor stg --release` |
| `prd` | `main` | `flutter build appbundle --flavor prd --release` (+ `ipa`) |

Bundle ids use a reverse-domain with a per-flavor suffix (`.dev` / `.stg` / none for prd). Set your own reverse-domain (no underscores) when white-labeling.

---

## Core Services

Singletons under `lib/core/utils/services/` (registered in `dependencies_injection.dart`; reached via Cubit/UseCase, never widgets):

| Service | Purpose |
|---|---|
| `CacheStore` | TTL'd JSON cache (Hive box); datasources go network-first → fall back to cache |
| `RemoteConfigService` | `GET /config` → feature flags (`isEnabled`); offline-safe defaults |
| `UploadService` | `image_picker` + multipart `POST /upload` |
| `NotificationService` | FCM + local; tap → `onNotificationTap(route)` → `go_router` |
| `AnalyticsService` | wraps FirebaseAnalytics + a go_router observer |
| `ConnectivityService` / `AuthTokenService` (secure-storage tokens) / `PermissionService` | as named |

**Backend quirks:** envelope `{success,message,data,meta}`, errors `{error_code,errors,request_id}`. `is_active` arrives as int `1/0` → map with `@BoolFromIntConverter()` (`lib/core/utils/converters/`), never a raw `bool`.

**App-status gate:** the dio error interceptor maps `forceUpdateRequired` / `maintenanceMode` codes to full-screen routes (`lib/features/app_status/`) via `blockingRouteForCode` — a backend status can hijack navigation app-wide.

---

## Testing

```bash
fvm flutter test                                      # all tests
fvm flutter test --coverage                           # lcov (CI gate: min 40%)
fvm flutter analyze                                   # static analysis (CI gate: zero issues)
fvm dart format --set-exit-if-changed lib test tool   # CI format gate (mirror locally)
fvm dart run scripts/check_arb_parity.dart            # intl_en/intl_id key parity (CI gate)
```

`bloc_test` + `mocktail` only — shared mocks + `registerFallbackValues()` in `test/helpers/mocks.dart` (no mock codegen). **Golden tests** via `alchemist` (e.g. `test/core/widgets/button_golden_test.dart`); CI-deterministic goldens live in `**/goldens/ci/`, regenerate with `fvm flutter test --update-goldens`. Alchemist is configured in `test/flutter_test_config.dart` (platform goldens off, so committed goldens match the Linux CI runner from any dev OS). `test/architecture/domain_layer_test.dart` enforces the Clean-Architecture import rule (see Rule 19). Tag flaky tests `broken` (CI runs `--exclude-tags broken`). CI pipeline: build_runner → ARB-parity → gen-l10n → format → analyze → test+coverage → coverage-gate(40%) → build-dev(apk) + build-ios(dev, no-codesign, macOS runner).

---

## Branching (GitFlow)

| Branch | Purpose | Base | PR Target |
|---|---|---|---|
| `main` | Production | — | `release/*` or `hotfix/*` |
| `develop` | Integration | `main` | `feature/*` |
| `feature/<slug>` | One feature/task | `develop` | `develop` |
| `release/<version>` | Pre-release | `develop` | `main` (back-merge to `develop`) |
| `hotfix/<slug>` | Prod fix | `main` | `main` (back-merge to `develop`) |

**Protected** (never push directly): `main`, `develop`, `release/*`. PRs via `gh pr create`.

---

## Rules

1. Never copy nearby features blindly — follow the architecture + the reference feature.
2. Never use `dynamic` (except generated `*.g.dart`/`*.freezed.dart`).
3. Never use `print()` — use `logger`; production errors → `FirebaseCrashlytics.recordError()`.
4. Never `throw` raw `Exception` from the repository layer — return `Left(Failure)` via fpdart's `Either`.
5. Never call `dio`/`Hive`/`FirebaseAnalytics`/`getIt<…>()` directly from widgets — delegate to Cubit/UseCase.
6. Never inline magic strings for asset paths or API endpoints — use `lib/core/resources/` or `lib/core/api/`.
7. Never forget to `dispose()` controllers / `close()` Cubit/Bloc.
8. Never access `context` after `await` without `if (!mounted) return;`.
9. Never use ad-hoc `Navigator.push(MaterialPageRoute(...))` — register routes in `lib/core/app_route.dart` (go_router).
10. Never add a `getIt` dependency without registering it in `lib/dependencies_injection.dart`.
11. Never add an l10n key to one ARB without the other — `intl_en.arb` and `intl_id.arb` stay in parity.
12. Never change `@freezed`/`@JsonSerializable`/`@HiveType` without rerunning `build_runner` and committing the generated output in the same PR.
13. Never auto-commit — always ask first.
14. Never `git add .` or `git add -A` — stage files individually.
15. Never push directly to `main`, `develop`, or `release/*`.
16. Never `--no-verify` / `--no-gpg-sign` unless explicitly requested.
17. Never surface raw backend strings to users — map `Failure` → localized text (`Failure.localize`).
18. Never freestyle — stop and ask if a pattern is not covered by existing rules.
19. Never let a `domain/` file import `package:flutter/*`, `core/core.dart`, a feature umbrella barrel, or the `data/` layer — use the narrow barrels (`core/error`, `core/usecase`, `core/models`). Enforced by `test/architecture/domain_layer_test.dart` (fails CI).
20. Always `fvm dart format lib test tool` before committing — CI fails on unformatted Dart (`--set-exit-if-changed`).

---

## Agents & Skills

Reusable agents live in `.claude/agents/` (code-planner, coder, code-reviewer, qa, test-engineer, release-manager); skills in `.claude/skills/` (codebase-onboard, feature-planner, interview, writing-plans/review, flutter-analyze/test/codegen/build, pr-review, git, commit-message, debugger, workflow). The reference feature under `lib/features/users/` is the canonical pattern to copy when adding a feature.

> Tooling note: some skills/commands were authored for an Azure DevOps origin and are being migrated to GitHub (`gh`). Treat git/PR steps as GitHub-based.
