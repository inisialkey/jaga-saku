import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';

/// Contract for account persistence. Implemented in the data layer; every
/// method returns `Either<Failure, T>` — the repository never throws (rule 4).
abstract class AccountRepository {
  /// Accounts ordered by `sort_order`, each with its derived [Account.balance].
  /// Archived rows are excluded unless [includeArchived] is set.
  Future<Either<Failure, List<Account>>> getAccounts({
    bool includeArchived = false,
  });

  /// Inserts (when [Account.id] is null) or updates the account. Returns the
  /// row id.
  Future<Either<Failure, int>> saveAccount(Account account);

  /// Hard-deletes the account. May fail (e.g. an FK from transactions in M2);
  /// callers fall back to [archiveAccount].
  Future<Either<Failure, Unit>> deleteAccount(int id);

  /// Sets the archived flag.
  Future<Either<Failure, Unit>> archiveAccount(
    int id, {
    required bool archived,
  });

  /// Persists a new ordering — `sort_order` becomes each id's index.
  Future<Either<Failure, Unit>> reorderAccounts(List<int> orderedIds);
}
