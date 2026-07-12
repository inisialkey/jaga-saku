import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/transactions/domain/asset_trend_calculator.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

/// Contract for transaction persistence. Implemented in the data layer; every
/// method returns `Either<Failure, T>` — the repository never throws (rule 4).
abstract class TransactionRepository {
  /// Transactions whose [Transaction.date] falls in [month]'s calendar month,
  /// newest first. Powers the calendar grid dots + month view.
  Future<Either<Failure, List<Transaction>>> getTransactionsByMonth(
    DateTime month,
  );

  /// Transactions on the calendar day of [day], newest first.
  Future<Either<Failure, List<Transaction>>> getTransactionsByDay(DateTime day);

  /// The [limit] most recent transactions (by date), newest first. Reused by
  /// the Home recent-activity section (M3).
  Future<Either<Failure, List<Transaction>>> getRecentTransactions(int limit);

  /// Inserts (when [Transaction.id] is null) or updates the entry. Returns the
  /// row id.
  Future<Either<Failure, int>> saveTransaction(Transaction transaction);

  /// Hard-deletes the transaction by id.
  Future<Either<Failure, Unit>> deleteTransaction(int id);

  /// Signed monthly net deltas (`Σincome − Σexpense`; transfers ⇒ 0) over
  /// `[startMillis, endMillis)`, oldest→newest. Feeds the on-the-fly net-worth
  /// trend (V2-M7) — no category exclusion (adjustments move real assets, so
  /// the trend counts them even though the report cards do not).
  Future<Either<Failure, List<MonthDelta>>> monthlyNetDeltas(
    int startMillis,
    int endMillis,
  );
}
