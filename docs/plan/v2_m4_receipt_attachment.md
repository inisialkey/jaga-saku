# V2-M4 — Receipt Attachment

Fifth V2 milestone. Lets a user attach **one photo** (camera or gallery) to a transaction as a receipt. This is the first V2 feature to touch **native platform config + new packages** — there is currently *zero* file/picker/permission plumbing in the app (`grep image_picker|path_provider|permission_handler` = empty across `lib/`, `pubspec`, `android/`, `ios/`).

**Build-order context:** V2-M0 ✓ → V2-M1 ✓ → V2-M2 ✓ → V2-M3 ✓ → **V2-M4 Receipt** → V2-M5 Recurring → V2-M6 Reconciliation → V2-M7 Money Story. Independent of M2/M3/M5 (no shared code); can ship in any slot after V2-M0.

**Source of truth:** the grill (2026-07-12). Storage model resolved to a **single `receipt_path` column** (1 receipt/tx), file on disk in app-docs, relative path stored.

**Definition of done:** `analyze` 0, format, build_runner green (entity/model regenerated), ARB parity, coverage ≥40%, schema-parity + migration tests green, **builds on both dev (apk) + iOS (no-codesign)** with the new native config, existing V1/M1 tests + goldens green. A picked photo is copied into app storage, survives the source being deleted from the gallery, is shown in the edit form + flagged on the tile, and is deleted when its transaction is deleted or replaced.

---

## 1. Dependencies
- **New packages:** `image_picker` (camera + gallery; handles its own runtime permission prompts) + `path_provider` (`getApplicationDocumentsDirectory()`). **No `permission_handler`** — `image_picker`'s platform channels cover the camera/photo prompts; adding a manual permission layer is YAGNI (`// ponytail:` add only if a platform needs a pre-prompt).
- **Native config (must ship in the same PR):**
  - iOS `ios/Runner/Info.plist`: `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription` (Bahasa strings).
  - Android: `image_picker` uses the system camera/photo-picker intents — no manifest runtime permission required on modern SDKs; declare `<uses-feature android:name="android.hardware.camera" android:required="false"/>`.
- Requires V2-M0's chained-`onCreate` migration path for the `_vN` ALTER.

> **CI-gate note (from project memory):** removing a dep needs native cleanup; **adding** one needs native *setup* + a build check. Verify the CI iOS build (macOS runner, no-codesign) passes with the new `Info.plist` keys, and dev apk builds.

## 2. Scope
- `transactions.receipt_path TEXT` (nullable, relative path).
- A `ReceiptStorageService` (pick → copy into app-docs → resolve → delete).
- Attach/replace/remove + thumbnail + full-screen view in the add/edit tx flow; a receipt indicator on the tx tile.
- File cleanup on tx delete/replace (centralised so **every** delete path is covered).

## 3. Not in scope
- Multiple receipts per tx (would be a separate `attachments` table — additive later; 1/tx fits personal finance).
- PDF/document attachments, OCR/amount extraction, cloud backup of images (offline-only).
- Editing/annotating the image. Re-compression settings UI (a fixed `imageQuality` is baked).

---

## 4. Data model — `transactions` gains `receipt_path`
- `receipt_path TEXT` (nullable). Stores a **relative** path like `receipts/1720800000000000.jpg`, resolved against `getApplicationDocumentsDirectory()` at read — the iOS documents-container absolute path changes across reinstalls/OS updates, so an absolute path would dangle.
- No other column changes; money/date conventions untouched (`migrations.dart:11`).

## 5. Database migration changes
- **`_v4`** (next sequential after M2's `_v3`; renumber per build order): `ALTER TABLE transactions ADD COLUMN receipt_path TEXT;`.
  - **Replay-safe reasoning:** `onCreate` replays `_v1` (creates `transactions` *without* the column) → `_v2` → `_v3` → `_v4` (adds it) — runs exactly once on fresh install ⇒ column present. `migrate` runs `_v4` for `oldVersion < 4`. `ADD COLUMN` has no `IF NOT EXISTS`, but each `_vN` executes once per path, so no double-add. Fresh == migrated (parity test proves it).
- Bump `latestVersion` → `4`; wire `_v4` into `onCreate` (`:24-27`) **and** `migrate` (`:31-37`).
- Extend `schema_parity_test` `latestVersion == 4` check (`:59-61`); add a **migration test**: v3→v4 adds `receipt_path` (via `PRAGMA table_info`), existing rows get `NULL`, spend/balance SQL unaffected.

## 6. Domain / model changes
- **Entity** `transaction.dart` (`@freezed`, `:81`): add `String? receiptPath`. No effect on `TransactionType`/aggregation.
- **Model** `transaction_model.dart`: add `receiptPath` to `fromMap` (`:28-43`), `toMap` (`:62-74`, write `null` not `''`), `fromEntity`/`toEntity` (`:45-88`). Rerun build_runner, commit generated.
- **No pure helper** — receipts are I/O, not calculation.

## 7. Datasource / repository / usecase changes
- **`ReceiptStorageService`** `lib/core/utils/services/receipt_storage_service.dart` (registered in DI, reached via cubit — rule 5, never the widget):
  - `Future<String?> pickAndStore(ImageSource source)` — `image_picker` (with `imageQuality: 70`, `maxWidth: 1600` to cap size) → copy bytes into `<docs>/receipts/<micros>.jpg` (filename = `DateTime.now().microsecondsSinceEpoch`, collision-free, no id-rename dance) → return the **relative** path.
  - `Future<File?> resolve(String relativePath)` — join against `getApplicationDocumentsDirectory()`; null if missing.
  - `Future<void> delete(String relativePath)` — remove the file (no-throw if absent).
- **Repo delete = root-cause file cleanup.** `transaction_repository_impl.dart` `deleteTransaction` (currently row-only): inject `ReceiptStorageService`, read the row's `receipt_path` *before* the row delete, then `service.delete(path)`. This covers **every** delete caller (edit-form, any future swipe-to-delete) in one place — the ponytail root-cause fix, not a per-caller guard. Keep returning `Either<Failure,Unit>`; a failed file delete logs via `logger` and still succeeds the row delete (a stale file is harmless; a blocked delete is not).
- **Replace** handled in the cubit: on picking a new receipt when one exists, `service.delete(old)` after the new path is committed.
- No new usecase — `SaveTransaction`/`DeleteTransaction` unchanged in signature (the model now carries `receiptPath`).

## 8. Cubit / state changes
- **`AddTransactionCubit`** (`add_transaction_cubit.dart`): deps gain `ReceiptStorageService`. State gains `String? receiptPath`. Methods: `pickReceipt(ImageSource)` → `service.pickAndStore` → emit path (delete prior file if replacing); `removeReceipt()` → `service.delete` + null the field. `_commit` (`:169-206`) includes `receiptPath` in the built `Transaction`. On **edit-delete**, the repo cleanup (§7) handles the file; the cubit needn't.
- No other cubit changes (aggregation, home, insight untouched — `receiptPath` is inert to them).

## 9. UI changes
- **Add/edit tx** (`add_transaction_page.dart`): a "Struk / Lampiran" row below the note field — if empty, a `SelectorField`-style "Tambah struk" that opens a source sheet (Kamera / Galeri); if set, a thumbnail (`Image.file(service.resolve(...))`) with remove (✕) + tap-to-view. Uses the existing `bottom_sheet.dart` for the source picker.
- **Full-screen view:** tap thumbnail → a simple `Dialog` with `InteractiveViewer` + `Image.file` (pinch-zoom, no new dep). No route needed.
- **Tx tile** (`core/widgets/transaction_tile.dart`, takes primitives): add an optional `bool hasReceipt` → a small paperclip glyph in the trailing area. Calendar/Home/Insight pass `receiptPath != null`.

## 10. Routes / DI / l10n
- **Routes:** none (source sheet + view dialog are modals).
- **DI** (`dependencies_injection.dart`): register `ReceiptStorageService` as a lazy singleton (app-wide block `:48-56`); inject into `TransactionRepositoryImpl` and the `AddTransactionCubit` `BlocProvider`.
- **l10n:** `receiptAttach`, `receiptCamera`, `receiptGallery`, `receiptRemove`, `receiptView`, `receiptPickFailed`. `gen-l10n` + parity.

## 11. Testing plan
- **Migration:** v3→v4 adds `receipt_path`; existing rows NULL; parity fresh==migrated; `latestVersion==4`.
- **Model:** `fromMap`/`toMap` round-trip with `receiptPath` set and null; `toMap` omits nothing but writes null correctly.
- **`ReceiptStorageService`:** with a temp dir + a fake `ImagePicker`/file — `pickAndStore` copies bytes to a relative path; `resolve` finds it; `delete` is idempotent; a re-pick then delete-old removes the first file. (sqflite_common_ffi already a dev dep; use a temp `Directory` for path_provider via a test override.)
- **Repo delete cleanup:** deleting a tx with a `receipt_path` calls `service.delete` once and removes the row even if the file is already gone.
- **`AddTransactionCubit`:** `pickReceipt` sets path (and deletes prior on replace); `removeReceipt` clears + deletes; `_commit` carries `receiptPath`.
- **Widget/golden:** attach row empty vs thumbnail; tile paperclip indicator (golden).
- **Build check:** dev apk + CI iOS no-codesign build succeed with the new `Info.plist` keys.

## 12. Acceptance
- [ ] `receipt_path` via `_v4` in both migration paths; `latestVersion=4`; migration + parity tests green
- [ ] `image_picker` + `path_provider` added; iOS `Info.plist` usage strings + Android camera feature declared; **CI iOS + dev apk build green**
- [ ] Pick (camera/gallery) copies into app-docs; relative path resolves at read; survives gallery deletion of the original
- [ ] Deleting or replacing a tx deletes its receipt file (verified via the repo-level cleanup, all callers)
- [ ] Thumbnail + full-screen view in the form; paperclip indicator on the tile
- [ ] `analyze` 0 · format · build_runner green · ARB parity · coverage ≥40% · existing tests + goldens green

## 13. Risks & edge cases
- **Orphaned files** — a crash between file-copy and row-save leaves a stray file. Low harm (a few KB); a `// ponytail:` note to add a startup orphan-sweep (files in `receipts/` with no referencing row) only if it accumulates.
- **Absolute-path dangling** — the reason we store relative + resolve at read; a test asserts a stored path has no leading `/` and no container prefix.
- **Permission denied / user cancels** — `pickAndStore` returns null; UI stays unchanged, optional toast on error.
- **Large images** — `imageQuality`/`maxWidth` cap keeps files small; without it, a 12MP photo bloats storage.
- **Editing a tx and cancelling** — if a receipt was picked then the form dismissed without save, the copied file is orphaned; delete-on-dismiss in the cubit if a new (uncommitted) file exists.
- **FK/cascade** — tx have no `ON DELETE` cascade from accounts/categories (RESTRICT), so receipts are never orphaned by an account delete; only direct tx deletes free them (covered §7).
- **iOS container migration** — after an OS restore the docs dir path changes; relative resolution handles it, but a missing file must render a graceful placeholder, not crash.

## 14. Recommended implementation order
1. Add deps + native config; verify a clean dev + iOS build *before* any Dart.
2. Schema `_v4` + `latestVersion` + both paths; entity/model + build_runner; migration + parity tests.
3. `ReceiptStorageService` + unit tests (temp dir).
4. Repo-level delete cleanup + test (root-cause coverage).
5. `AddTransactionCubit` pick/remove/commit + tests.
6. UI: attach row, thumbnail, full-screen view, tile indicator + goldens.
7. l10n + parity; build-check + coverage sweep.

---

### Reference-pattern note
`ReceiptStorageService` is the first **file-I/O service** in the app and the template for any future on-device asset (export files, backups). Record: assets are stored as **relative** paths under app-docs and resolved at read; deletion cleanup lives at the **repository** layer so all callers are covered.
