import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaga_saku/core/database/app_database.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/core/utils/services/receipt_storage_service.dart';
import 'package:jaga_saku/core/utils/services/settings/settings_service.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/accounts/data/datasources/account_local_datasource.dart';
import 'package:jaga_saku/features/accounts/data/models/account_model.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/repositories/account_repository.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/archive_account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/delete_account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/get_accounts.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/reorder_accounts.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/save_account.dart';
import 'package:jaga_saku/features/budgets/data/datasources/budget_local_datasource.dart';
import 'package:jaga_saku/features/budgets/data/models/budget_model.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/repositories/budget_repository.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/delete_budget.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/get_budgets_for_period.dart';
import 'package:jaga_saku/features/budgets/domain/usecases/save_budget.dart';
import 'package:jaga_saku/features/categories/data/datasources/category_local_datasource.dart';
import 'package:jaga_saku/features/categories/data/models/category_model.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/repositories/category_repository.dart';
import 'package:jaga_saku/features/categories/domain/usecases/archive_category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/delete_category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
import 'package:jaga_saku/features/categories/domain/usecases/reorder_categories.dart';
import 'package:jaga_saku/features/categories/domain/usecases/save_category.dart';
import 'package:jaga_saku/features/templates/data/datasources/tx_template_local_datasource.dart';
import 'package:jaga_saku/features/templates/data/models/tx_template_model.dart';
import 'package:jaga_saku/features/templates/domain/entities/tx_template.dart';
import 'package:jaga_saku/features/templates/domain/repositories/tx_template_repository.dart';
import 'package:jaga_saku/features/templates/domain/usecases/delete_tx_template.dart';
import 'package:jaga_saku/features/templates/domain/usecases/get_favorites.dart';
import 'package:jaga_saku/features/templates/domain/usecases/reorder_templates.dart';
import 'package:jaga_saku/features/templates/domain/usecases/save_tx_template.dart';
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

class MockSettingsService extends Mock implements SettingsService {}

class MockTxChangeNotifier extends Mock implements TxChangeNotifier {}

class MockReceiptStorageService extends Mock implements ReceiptStorageService {}

class MockImagePicker extends Mock implements ImagePicker {}

// ── Accounts ────────────────────────────────────────────────────────────────
class MockAccountLocalDatasource extends Mock
    implements AccountLocalDatasource {}

class MockAccountRepository extends Mock implements AccountRepository {}

class MockGetAccounts extends Mock implements GetAccounts {}

class MockSaveAccount extends Mock implements SaveAccount {}

class MockDeleteAccount extends Mock implements DeleteAccount {}

class MockArchiveAccount extends Mock implements ArchiveAccount {}

class MockReorderAccounts extends Mock implements ReorderAccounts {}

// ── Budgets ──────────────────────────────────────────────────────────────────
class MockBudgetLocalDatasource extends Mock implements BudgetLocalDatasource {}

class MockBudgetRepository extends Mock implements BudgetRepository {}

class MockGetBudgetsForPeriod extends Mock implements GetBudgetsForPeriod {}

class MockSaveBudget extends Mock implements SaveBudget {}

class MockDeleteBudget extends Mock implements DeleteBudget {}

// ── Categories ──────────────────────────────────────────────────────────────
class MockCategoryLocalDatasource extends Mock
    implements CategoryLocalDatasource {}

class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockGetCategories extends Mock implements GetCategories {}

class MockSaveCategory extends Mock implements SaveCategory {}

class MockDeleteCategory extends Mock implements DeleteCategory {}

class MockArchiveCategory extends Mock implements ArchiveCategory {}

class MockReorderCategories extends Mock implements ReorderCategories {}

// ── Templates (favorites) ─────────────────────────────────────────────────────
class MockTxTemplateLocalDatasource extends Mock
    implements TxTemplateLocalDatasource {}

class MockTxTemplateRepository extends Mock implements TxTemplateRepository {}

class MockGetFavorites extends Mock implements GetFavorites {}

class MockSaveTxTemplate extends Mock implements SaveTxTemplate {}

class MockDeleteTxTemplate extends Mock implements DeleteTxTemplate {}

class MockReorderTemplates extends Mock implements ReorderTemplates {}

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
  registerFallbackValue(
    const Budget(categoryId: 0, period: '2026-01', limitAmount: 0),
  );
  registerFallbackValue(
    const BudgetModel(categoryId: 0, period: '2026-01', limitAmount: 0),
  );
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
  registerFallbackValue(
    const TxTemplate(label: '', type: TransactionType.expense, accountId: 0),
  );
  registerFallbackValue(
    const TxTemplateModel(
      label: '',
      type: TransactionType.expense,
      accountId: 0,
    ),
  );
  registerFallbackValue(DateTime(2000));
  // For `pickImage(source: any(named: 'source'))` / `pickAndStore(any())`.
  registerFallbackValue(ImageSource.gallery);
}
