import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/transactions/domain/asset_trend_calculator.dart';
import 'package:jaga_saku/features/transactions/domain/repositories/transaction_repository.dart';

/// [baseline] = `Σ opening_balance` over NON-ARCHIVED accounts (summed in the
/// cubit); [now] scopes the window end; [months] trailing points to show.
class AssetTrendParams extends Equatable {
  const AssetTrendParams({
    required this.baseline,
    required this.now,
    this.months = 12,
  });

  final int baseline;
  final DateTime now;
  final int months;

  @override
  List<Object?> get props => [baseline, now, months];
}

/// Builds the net-worth trend on read (no snapshot). Cumulates the FULL history
/// from [AssetTrendParams.baseline], then returns the trailing `months` points —
/// so the last point equals current net worth (reconciles with Home) even when
/// history predates the window. Empty history ⇒ a single baseline dot.
///
/// Why `start = 0` (all history), not "12 months ago": cumulating from
/// `Σopening` over the full history makes the last point equal current net
/// worth **regardless of how old the history is**; the 12-month "window" is
/// just a display trim of the tail. A literal 12-month delta query would drop
/// pre-window history and the reconciliation identity would silently break.
class GetAssetTrend extends UseCase<List<TrendPoint>, AssetTrendParams> {
  GetAssetTrend(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, List<TrendPoint>>> call(
    AssetTrendParams params,
  ) async {
    // Start of next month → includes all of the current month.
    final end = DateTime(
      params.now.year,
      params.now.month + 1,
    ).millisecondsSinceEpoch;
    final result = await _repository.monthlyNetDeltas(
      0,
      end,
    ); // 0 = all history
    return result.map((deltas) {
      final points = AssetTrendCalculator.cumulate(
        baseline: params.baseline,
        deltas: deltas,
      );
      if (points.isEmpty) {
        final month = DateTime(
          params.now.year,
          params.now.month,
        ).millisecondsSinceEpoch;
        return [TrendPoint(monthMillis: month, netWorth: params.baseline)];
      }
      return points.length <= params.months
          ? points
          : points.sublist(points.length - params.months);
    });
  }
}
