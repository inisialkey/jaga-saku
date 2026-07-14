/// The first-failing-field reason for a form submit, surfaced as a toast (D1).
///
/// Pure Dart (no Flutter import) so the form cubits/states can reference it while
/// staying material-free; [FormValidationErrorX.localize] (a widget-layer
/// extension) maps each case to a localized [Strings] message. Each form derives
/// its own `firstError` getter over these cases in the same order as its
/// `isValid` rule.
enum FormValidationError {
  amountRequired,
  accountRequired,
  categoryRequired,
  toAccountRequired,
  transferSameAccount,
  nameRequired,
  labelRequired,
  startDateRequired,
  endDateBeforeStart,
}
