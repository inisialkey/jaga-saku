# V2-M3 — Calculator Amount Input

Fourth V2 milestone. Replaces the digits-only amount keyboard with an **in-app calculator keypad** so users can enter `12.000 + 3.500` and commit the result. Pure UI + one pure evaluator — **no schema, no route, no migration**. The smallest V2 feature; a good palate-cleanser between M2 (favorite) and M4 (receipt).

**Build-order context:** V2-M0 ✓ → V2-M1 ✓ → V2-M2 ✓ → **V2-M3 Calculator** → V2-M4 Receipt → V2-M5 Recurring → V2-M6 Reconciliation (**reuses this keypad for the "counted balance" input**) → V2-M7 Money Story.

**Source of truth:** the grill (2026-07-12). Today `AmountInputField` (`lib/core/widgets/amount_input_field.dart`) is a raw `TextField` — `keyboardType: number`, `inputFormatters:[FilteringTextInputFormatter.digitsOnly]` (`:44-45`), a static `Rp` prefix (`:35`), parsed by callers via `int.tryParse(value) ?? 0` (`add_transaction_page.dart:108`). No thousands grouping, no operators.

**Definition of done:** `analyze` 0, format, build_runner green (none needed — no codegen), ARB parity, coverage ≥40%, existing goldens updated for the new field. Tapping any amount field opens the keypad; `12000+3500` yields `15500`; the value is an integer rupiah; every `AmountInputField` call site (tx amount, account opening-balance, budget limit) inherits it with **zero call-site change**.

---

## 1. Dependencies
**None new** (no package — a hand-rolled keypad + a ~40-line evaluator). Depends on nothing but the shared `AmountInputField` widget. Ships independently to `develop`.

## 2. Scope
- A **pure `CalcEngine`** that evaluates a `+ − × ÷` expression to an integer rupiah.
- A **keypad bottom sheet** (`CalculatorKeypadSheet`) replacing the system keyboard when an `AmountInputField` is focused.
- Upgrade the **shared `AmountInputField`** so all three amount sites get it for free.

## 3. Not in scope
- Decimals / cents (the app is integer rupiah — `migrations.dart:11`; division rounds to int).
- Parentheses, percent, memory keys, scientific ops.
- Standard operator precedence — **left-to-right calculator semantics** (`2+3×4 = 20`), the cheap-calculator norm; `// ponytail:` shunting-yard precedence only if users ask.
- History/tape of past calculations.

---

## 4. Data model / migration changes
**None.** No table, no column, no `_vN`, no seed. `latestVersion` unchanged. (Called out explicitly so the schema-parity test is untouched.)

## 5. Domain / model changes
- **Pure helper** `lib/core/utils/helper/calc_engine.dart` — **flutter-free**, unit-tested (mirrors `money.dart`/`BudgetCycle` precedent):
  - `int CalcEngine.evaluate(String expr)` — tokenizes digits + `+ − × ÷`, folds **left-to-right**, rounds each division to the nearest int (`(a / b).round()`), returns `0` on empty/invalid, ignores a trailing dangling operator.
  - `String CalcEngine.format(String expr)` — inserts thousands separators into each numeric token for the live expression line (reuses `money.dart` grouping logic; extract a shared `groupDigits(String)` so `formatRupiah` `money.dart:8-16` and the keypad agree).
  - No side effects, no `dynamic` (rule 2), no throws — invalid input degrades to the last valid value.

## 6. Datasource / repository / usecase changes
**None.** This is presentation + a pure helper only. No datasource, repo, usecase, or DI entry.

## 7. Cubit / state changes
**None (no BLoC).** Keypad state (the working expression string) is **widget-local** — a `ValueNotifier<String>` inside the sheet, or the sheet returns the evaluated `int` to `AmountInputField` on "done". Business logic stays out of the widget: all evaluation/formatting lives in `CalcEngine` (rule 5/keep-logic-pure). `AmountInputField` keeps exposing an `onChanged(int)` / controller so callers are unchanged.

## 8. UI changes
- **`AmountInputField`** (`amount_input_field.dart`): stop raising the system keyboard (`readOnly: true` + `showCursor`), keep the large display + `Rp` prefix (`:35`); on tap → `showModalBottomSheet` with the keypad, seeded from the current value; on "done" → set the value (formatted for display, integer for the caller). The `digitsOnly` formatter (`:44-45`) is removed (input now flows only through the keypad). **Public API (controller / `onChanged(int)`) unchanged** → tx amount (`add_transaction_page.dart:104`), account opening-balance (`account_form_page.dart:81-86`), budget limit, and M2's favorite-amount field all inherit the keypad with no edit.
- **`CalculatorKeypadSheet`** (`lib/core/widgets/calculator_keypad_sheet.dart`, added to the `widgets.dart` barrel): an `AppBottomSheet` (`bottom_sheet.dart`) containing an expression line (`CalcEngine.format(expr)`) + a live result (`= Rp {CalcEngine.evaluate(expr)}`, via `MoneyText`/`formatRupiah`) + a 4×4 grid `[7 8 9 ÷][4 5 6 ×][1 2 3 −][C 0 ⌫ +]` and an `=`/`Selesai` bar. `=` collapses the expression to its result (chainable); `Selesai` returns the integer and pops.

## 9. Routes / DI / l10n
- **Routes:** none (a sheet, not a screen).
- **DI:** none.
- **l10n:** minimal — `calcDone` ("Selesai"), `calcClear` ("C"). Numeric/operator glyphs are not localized. `gen-l10n` + parity.

## 10. Testing plan
- **`CalcEngine` (pure) — the guard:** `50000 → 50000`; `12000+3500 → 15500`; `2+3*4 → 20` (left-to-right, documents the choice); `10000/3 → 3333` (round); `100-250 → -150` (negative allowed — matters for M6 reconcile deltas); empty/`""` → 0; trailing operator `12000+` → 12000; garbage → 0; `format('1000000') → '1.000.000'`.
- **`groupDigits` shared** — assert `formatRupiah` output is unchanged after the extraction (regression guard on `money.dart`).
- **Widget test** — `AmountInputField` no longer opens the system keyboard; tapping shows the sheet; `1``2`... then done sets the caller's `int`.
- **Goldens** — update the existing amount-field goldens; add a keypad-sheet golden. (`--update-goldens`, committed CI variant.)
- Existing account/budget/tx form tests: amount now arrives via the sheet — update the test drivers to push the value through the field's `onChanged`, assert numbers unchanged.

## 11. Acceptance
- [ ] `CalcEngine` pure (rule 19-style, flutter-free), unit-tested incl. negative results + rounding + invalid-degrades-to-0
- [ ] Keypad sheet replaces the system keyboard on `AmountInputField`; live expression + result shown
- [ ] All three existing amount sites (tx, account opening-balance, budget limit) + M2 favorite amount inherit it with **no call-site change**
- [ ] `formatRupiah` output byte-identical after `groupDigits` extraction
- [ ] `analyze` 0 · format · ARB parity · coverage ≥40% · goldens regenerated & committed · existing tests green

## 12. Risks & edge cases
- **Division rounding drift** — `10000/3` = 3333 loses 1 rupiah; acceptable for a manual entry aid; documented in the test.
- **Negative results** — allowed (needed by M6); `AmountInputField` must not clamp to ≥0 at the widget layer — callers that require positivity (tx amount) validate in their cubit as today (`amountRequired`), not the widget.
- **Overflow** — cap expression length / operand size to avoid `int` overflow on absurd input (Dart int is 64-bit; a soft length cap in the keypad is enough).
- **Accessibility** — keypad keys need semantic labels; the field stays focusable/announced as an amount.
- **Paste** — with the system keyboard gone, wire a long-press "paste digits" into the keypad (strip non-digits) so clipboard entry still works.
- **iOS/Android sheet inset** — the keypad sheet must sit above the home indicator / nav bar (safe-area padding in `AppBottomSheet`).

## 13. Recommended implementation order
1. Extract `groupDigits` from `money.dart`; regression-test `formatRupiah`.
2. `CalcEngine.evaluate` + `format` + full unit suite (red→green).
3. `CalculatorKeypadSheet` widget + golden.
4. Rewire `AmountInputField` to `readOnly` + open the sheet; keep the public API; add paste handling.
5. Regenerate goldens; update account/budget/tx form test drivers.
6. l10n (`calcDone`, `calcClear`) + parity; final sweep.

---

### Reference-pattern note
`CalcEngine` is the sixth **pure calculation helper** and the single evaluator for any amount math. Because the upgrade lives in the **shared** `AmountInputField`, M6's "counted balance" input (and any future amount field) gets the keypad for free — record that the widget is now the one amount-entry surface.
