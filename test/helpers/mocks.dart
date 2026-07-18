import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaga_saku/core/database/app_database.dart';
import 'package:jaga_saku/core/utils/services/secure_storage/secure_storage_service.dart';
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
import 'package:jaga_saku/features/categories/domain/usecases/get_system_category.dart';
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
import 'package:jaga_saku/features/transactions/domain/usecases/get_asset_trend.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_recent_transactions.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_transactions_by_day.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/get_transactions_by_month.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/save_transaction.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/search_transactions.dart';
import 'package:jaga_saku/features/recurring/data/datasources/recurring_local_datasource.dart';
import 'package:jaga_saku/features/recurring/data/models/recurring_model.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/repositories/recurring_repository.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/confirm_occurrence.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/delete_recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/get_due_occurrences.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/get_recurring_rules.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/save_recurring_rule.dart';
import 'package:jaga_saku/features/recurring/domain/usecases/skip_occurrence.dart';
import 'package:jaga_saku/core/utils/services/backup_file_service.dart';
import 'package:jaga_saku/core/utils/services/export_file_service.dart';
import 'package:jaga_saku/features/export/domain/repositories/export_repository.dart';
import 'package:jaga_saku/features/export/domain/usecases/export_transactions_csv.dart';
import 'package:jaga_saku/features/transactions/domain/entities/search_transaction_params.dart';
import 'package:jaga_saku/features/backup/data/datasources/backup_local_datasource.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_file.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_preview.dart';
import 'package:jaga_saku/features/backup/domain/repositories/backup_repository.dart';
import 'package:jaga_saku/features/backup/domain/usecases/export_backup.dart';
import 'package:jaga_saku/features/backup/domain/usecases/restore_backup.dart';
import 'package:jaga_saku/features/backup/domain/usecases/validate_backup.dart';
import 'package:jaga_saku/features/security/app_lock_service.dart';
import 'package:jaga_saku/features/security/data/datasources/biometric_auth_datasource.dart';
import 'package:jaga_saku/features/security/data/datasources/pin_secure_datasource.dart';
import 'package:jaga_saku/features/security/domain/entities/auto_lock_duration.dart';
import 'package:jaga_saku/features/security/domain/entities/lock_config.dart';
import 'package:jaga_saku/features/security/domain/entities/pin_check.dart';
import 'package:jaga_saku/features/security/domain/repositories/security_repository.dart';
import 'package:jaga_saku/features/security/domain/usecases/authenticate_biometric.dart';
import 'package:jaga_saku/features/security/domain/usecases/change_pin.dart';
import 'package:jaga_saku/features/security/domain/usecases/disable_pin.dart';
import 'package:jaga_saku/features/security/domain/usecases/get_lock_config.dart';
import 'package:jaga_saku/features/security/domain/usecases/is_biometric_available.dart';
import 'package:jaga_saku/features/security/domain/usecases/set_auto_lock_duration.dart';
import 'package:jaga_saku/features/security/domain/usecases/set_biometric_enabled.dart';
import 'package:jaga_saku/features/security/domain/usecases/set_pin.dart';
import 'package:jaga_saku/features/security/domain/usecases/verify_pin.dart';
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

// ── Security (V3-M4) — secure-storage seam ────────────────────────────────────
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockPinSecureDatasource extends Mock implements PinSecureDatasource {}

class MockBiometricAuthDatasource extends Mock
    implements BiometricAuthDatasource {}

class MockSecurityRepository extends Mock implements SecurityRepository {}

class MockGetLockConfig extends Mock implements GetLockConfig {}

class MockSetPin extends Mock implements SetPin {}

class MockVerifyPin extends Mock implements VerifyPin {}

class MockChangePin extends Mock implements ChangePin {}

class MockDisablePin extends Mock implements DisablePin {}

class MockSetBiometricEnabled extends Mock implements SetBiometricEnabled {}

class MockIsBiometricAvailable extends Mock implements IsBiometricAvailable {}

class MockAuthenticateBiometric extends Mock implements AuthenticateBiometric {}

class MockSetAutoLockDuration extends Mock implements SetAutoLockDuration {}

class MockAppLockService extends Mock implements AppLockService {}

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

class MockGetSystemCategory extends Mock implements GetSystemCategory {}

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

class MockSearchTransactions extends Mock implements SearchTransactions {}

class MockGetAssetTrend extends Mock implements GetAssetTrend {}

class MockSaveTransaction extends Mock implements SaveTransaction {}

class MockDeleteTransaction extends Mock implements DeleteTransaction {}

// ── Recurring (V2-M5) ─────────────────────────────────────────────────────────
class MockRecurringLocalDatasource extends Mock
    implements RecurringLocalDatasource {}

class MockRecurringRepository extends Mock implements RecurringRepository {}

class MockGetRecurringRules extends Mock implements GetRecurringRules {}

class MockSaveRecurringRule extends Mock implements SaveRecurringRule {}

class MockDeleteRecurringRule extends Mock implements DeleteRecurringRule {}

class MockGetDueOccurrences extends Mock implements GetDueOccurrences {}

class MockConfirmOccurrence extends Mock implements ConfirmOccurrence {}

class MockSkipOccurrence extends Mock implements SkipOccurrence {}

// ── Backup / Restore (V3-M1) ──────────────────────────────────────────────────
class MockBackupLocalDatasource extends Mock implements BackupLocalDatasource {}

class MockBackupRepository extends Mock implements BackupRepository {}

class MockBackupFileService extends Mock implements BackupFileService {}

class MockExportBackup extends Mock implements ExportBackup {}

class MockValidateBackup extends Mock implements ValidateBackup {}

class MockRestoreBackup extends Mock implements RestoreBackup {}

// ── Export (V3-M2) ────────────────────────────────────────────────────────────
class MockExportRepository extends Mock implements ExportRepository {}

class MockExportTransactionsCsv extends Mock implements ExportTransactionsCsv {}

class MockExportFileService extends Mock implements ExportFileService {}

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
  registerFallbackValue(AssetTrendParams(baseline: 0, now: DateTime(2000)));
  // For `pickImage(source: any(named: 'source'))` / `pickAndStore(any())`.
  registerFallbackValue(ImageSource.gallery);
  // ── Recurring (V2-M5) ──
  const recurringRuleFallback = RecurringRule(
    templateId: 0,
    freq: RecurrenceFreq.monthly,
    startDate: 0,
    nextDue: 0,
  );
  const txTemplateFallback = TxTemplate(
    label: '',
    type: TransactionType.expense,
    accountId: 0,
  );
  registerFallbackValue(recurringRuleFallback);
  registerFallbackValue(
    const RecurringModel(
      templateId: 0,
      freq: RecurrenceFreq.monthly,
      startDate: 0,
      nextDue: 0,
    ),
  );
  registerFallbackValue(
    const PendingOccurrence(
      rule: recurringRuleFallback,
      template: txTemplateFallback,
      dueDate: 0,
    ),
  );
  registerFallbackValue(
    const SaveRecurringRuleParams(
      template: txTemplateFallback,
      rule: recurringRuleFallback,
    ),
  );
  // ── Backup / Restore (V3-M1) ──
  registerFallbackValue(const BackupData());
  registerFallbackValue(
    const BackupFile(
      schemaVersion: 0,
      exportedAt: 0,
      itemCount: 0,
      content: '',
    ),
  );
  registerFallbackValue(const BackupPreview());
  // ── Export (V3-M2) ──
  registerFallbackValue(const SearchTransactionParams());
  // ── Security (V3-M4) ──
  registerFallbackValue(const LockConfig());
  registerFallbackValue(const PinCheck.ok());
  registerFallbackValue(AutoLockDuration.immediately);
  registerFallbackValue(const SetBiometricParams(enabled: false, reason: ''));
}
