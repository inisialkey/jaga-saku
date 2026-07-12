import 'package:equatable/equatable.dart';

/// One month's net portfolio change (`Σincome − Σexpense`, transfers net to 0),
/// produced by `TransactionLocalDatasource.monthlyNetDeltas`. [monthMillis] is
/// the local month-start epoch millis (`DateTime(y, m)`).
class MonthDelta extends Equatable {
  const MonthDelta({required this.monthMillis, required this.delta});

  final int monthMillis;
  final int delta;

  @override
  List<Object?> get props => [monthMillis, delta];
}

/// Month-end net worth for the trend line.
class TrendPoint extends Equatable {
  const TrendPoint({required this.monthMillis, required this.netWorth});

  final int monthMillis;
  final int netWorth;

  @override
  List<Object?> get props => [monthMillis, netWorth];
}

/// The eighth pure calculation helper — **no Flutter, no DB** (rule 19, mirrors
/// [TransactionAggregator]). Reconstructs net-worth-over-time without a snapshot
/// table: `running = baseline; running += delta` per month, in order.
///
/// Net-worth identity: across the whole portfolio transfers cancel
/// (`−amount` on one account, `+amount` on another), so a month's net change is
/// `Σincome − Σexpense` (adjustments included — they move real assets). With
/// `baseline = Σ opening_balance`, the running total equals
/// `Σopening + Σ(income−expense)` = the summed account balance at each
/// month-end.
///
/// ponytail: the identity is exact only for a portfolio of non-archived
/// accounts whose transfers never cross the archived boundary. Archived-account
/// history (or an account created/archived mid-window whose `opening_balance`
/// applies from t0) causes minor drift — acceptable for a trend, not a ledger.
class AssetTrendCalculator {
  const AssetTrendCalculator._();

  /// One [TrendPoint] per [deltas] entry, cumulated in order. Order preserved,
  /// negatives kept (no clamp). Empty [deltas] ⇒ `const []` (the caller seeds a
  /// baseline point / flat-lines — see `GetAssetTrend`).
  static List<TrendPoint> cumulate({
    required int baseline,
    required List<MonthDelta> deltas,
  }) {
    var running = baseline;
    final points = <TrendPoint>[];
    for (final d in deltas) {
      running += d.delta;
      points.add(TrendPoint(monthMillis: d.monthMillis, netWorth: running));
    }
    return points;
  }
}
