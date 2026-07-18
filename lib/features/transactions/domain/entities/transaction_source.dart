/// How a ledger entry originated — a transaction property shared by Search
/// (V3-M3, a filter facet) and the CSV `source` column (V3-M2).
///
/// V2 stores no `source` column, so this is **derived**: a transaction whose
/// category is one of the reserved reconcile categories
/// (`system_key ∈ {adjustment_in, adjustment_out}`) is a [reconciliation];
/// everything else (incl. a transfer with a null category) is [manual].
/// [fromSystemKey] is the single, unit-tested derivation point — a future real
/// `source` column only swaps this resolver.
///
/// Pure domain value — no Flutter / data / SQL dependency (rule 19). It lives in
/// `transactions/domain` (not `export/domain`) because it is a transaction
/// property the shared [SearchTransactionParams] filters on; the export feature
/// imports it from here (domain → domain, dependency the right way round).
enum TransactionSource {
  manual('manual'),
  reconciliation('reconciliation');

  const TransactionSource(this.value);

  /// The string written to the CSV `source` cell.
  final String value;

  /// Reserved reconcile `system_key`s (seeded by `_v6`). The single source of
  /// truth for both [fromSystemKey] and the data-layer `source` WHERE predicate,
  /// so the enum's key set and the SQL IN-list can never drift.
  static const Set<String> adjustmentSystemKeys = {
    'adjustment_in',
    'adjustment_out',
  };

  /// Derives the source from the joined `categories.system_key`. A null / normal
  /// key is [manual]; a reserved adjustment key is [reconciliation].
  static TransactionSource fromSystemKey(String? key) =>
      (key != null && adjustmentSystemKeys.contains(key))
      ? TransactionSource.reconciliation
      : TransactionSource.manual;
}
