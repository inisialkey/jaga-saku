import 'package:flutter/cupertino.dart';
import 'package:jaga_saku/core/database/app_database.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/accounts/data/datasources/account_local_datasource.dart';
import 'package:jaga_saku/features/accounts/data/models/account_model.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/repositories/account_repository.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/archive_account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/delete_account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/get_accounts.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/reorder_accounts.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/save_account.dart';
import 'package:jaga_saku/features/categories/data/datasources/category_local_datasource.dart';
import 'package:jaga_saku/features/categories/data/models/category_model.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/repositories/category_repository.dart';
import 'package:jaga_saku/features/categories/domain/usecases/archive_category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/delete_category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
import 'package:jaga_saku/features/categories/domain/usecases/reorder_categories.dart';
import 'package:jaga_saku/features/categories/domain/usecases/save_category.dart';
import 'package:jaga_saku/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:jaga_saku/features/transactions/data/models/transaction_model.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_recent_transactions.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_transactions_by_day.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_transactions_by_month.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/save_transaction.dart';
import 'package:mocktail/mocktail.dart';

/// Shared mocktail declarations + fallback registration for the test suite.
/// One thin `MockX extends Mock implements X` per mocked type; register a
/// fallback for any custom type passed to `any()` / `captureAny()`.

class MockBuildContext extends Mock implements BuildContext {}

class MockAppDatabase extends Mock implements AppDatabase {}

// ── Accounts ────────────────────────────────────────────────────────────────
class MockAccountLocalDatasource extends Mock
    implements AccountLocalDatasource {}

class MockAccountRepository extends Mock implements AccountRepository {}

class MockGetAccounts extends Mock implements GetAccounts {}

class MockSaveAccount extends Mock implements SaveAccount {}

class MockDeleteAccount extends Mock implements DeleteAccount {}

class MockArchiveAccount extends Mock implements ArchiveAccount {}

class MockReorderAccounts extends Mock implements ReorderAccounts {}

// ── Categories ──────────────────────────────────────────────────────────────
class MockCategoryLocalDatasource extends Mock
    implements CategoryLocalDatasource {}

class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockGetCategories extends Mock implements GetCategories {}

class MockSaveCategory extends Mock implements SaveCategory {}

class MockDeleteCategory extends Mock implements DeleteCategory {}

class MockArchiveCategory extends Mock implements ArchiveCategory {}

class MockReorderCategories extends Mock implements ReorderCategories {}

// ── Transactions ──────────────────────────────────────────────────────────────
class MockTransactionLocalDatasource extends Mock
    implements TransactionLocalDatasource {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockGetTransactionsByMonth extends Mock
    implements GetTransactionsByMonth {}

class MockGetTransactionsByDay extends Mock implements GetTransactionsByDay {}

class MockGetRecentTransactions extends Mock implements GetRecentTransactions {}

class MockSaveTransaction extends Mock implements SaveTransaction {}

class MockDeleteTransaction extends Mock implements DeleteTransaction {}

/// Registers fallback sentinels for custom (non-nullable) types used with
/// `any()` / `captureAny()` matchers. Idempotent — safe to call repeatedly.
void registerFallbackValues() {
  registerFallbackValue(NoParams());
  registerFallbackValue(const Account(name: '', type: AccountType.cash));
  registerFallbackValue(const AccountModel(name: '', type: AccountType.cash));
  registerFallbackValue(const ArchiveAccountParams(id: 0, archived: true));
  registerFallbackValue(const Category(name: '', type: CategoryType.expense));
  registerFallbackValue(
    const CategoryModel(name: '', type: CategoryType.expense),
  );
  registerFallbackValue(const ArchiveCategoryParams(id: 0, archived: true));
  registerFallbackValue(CategoryType.expense);
  registerFallbackValue(<int>[]);
  registerFallbackValue(
    const Transaction(type: TransactionType.expense, amount: 0, accountId: 0),
  );
  registerFallbackValue(
    const TransactionModel(
      type: TransactionType.expense,
      amount: 0,
      accountId: 0,
    ),
  );
  registerFallbackValue(DateTime(2000));
}
