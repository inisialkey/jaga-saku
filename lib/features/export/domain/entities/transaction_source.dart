/// How a ledger entry originated, as surfaced in the CSV `source` column.
///
/// V2 stores no `source` column, so this is **derived**: a transaction whose
/// category is one of the reserved reconcile categories
/// (`system_key ∈ {adjustment_in, adjustment_out}`) is a [reconciliation];
/// everything else is [manual]. [fromSystemKey] is the single, unit-tested
/// derivation point — a future real `source` column only swaps this resolver.
enum TransactionSource {
  manual('manual'),
  reconciliation('reconciliation');

  const TransactionSource(this.value);

  /// The string written to the CSV cell.
  final String value;

  /// Reserved reconcile `system_key`s (seeded by `_v6`). Kept here beside the
  /// resolver so the one derivation rule reads in one place.
  static const String _adjustmentIn = 'adjustment_in';
  static const String _adjustmentOut = 'adjustment_out';

  /// Derives the source from the joined `categories.system_key`. A null / normal
  /// key is [manual]; the reserved adjustment pair is [reconciliation].
  static TransactionSource fromSystemKey(String? key) =>
      (key == _adjustmentIn || key == _adjustmentOut)
      ? TransactionSource.reconciliation
      : TransactionSource.manual;
}
