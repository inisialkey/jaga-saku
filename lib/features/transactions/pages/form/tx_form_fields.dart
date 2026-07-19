import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/get_accounts.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_categories.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

/// Shared field-shape for the three tx-shaped form states (add-transaction,
/// favorite, recurring). Mixed in via `with _$XState, TxFormFields`; the state
/// supplies the six abstract getters as freezed fields, this mixin derives the
/// picker projections that were verbatim-triplicated.
///
/// ponytail: the per-form status enum + submit fold + validation getter are
/// deliberately NOT unified (V4-M3 tranche A). Upgrade path (item 5): one shared
/// `FormStatus`, fold tx's `AddTxValidation` into `FormValidationError`, one
/// shared submit prologue/fold — when the review surface is worth it.
mixin TxFormFields {
  TransactionType get type;
  List<Account> get accounts;
  List<Category> get categories;
  int? get accountId;
  int? get toAccountId;
  int? get categoryId;

  bool get isTransfer => type == TransactionType.transfer;

  bool get isExpense => type == TransactionType.expense;

  /// Active (non-archived) accounts offered by the account pickers.
  List<Account> get selectableAccounts =>
      accounts.where((a) => !a.archived).toList();

  /// Non-archived, current-type categories for the picker. Reserved system
  /// categories (the V2-M6 reconcile pair) are hidden here but kept in
  /// [categories] so [selectedCategory] still resolves an edited adjustment's
  /// label. V4-M3: unified — favorite + recurring now exclude system cats too.
  List<Category> get categoriesForType => categories
      .where((c) => !c.archived && !c.isSystem && _typeMatches(c))
      .toList();

  Account? get selectedAccount => _accountById(accountId);

  Account? get selectedToAccount => _accountById(toAccountId);

  Category? get selectedCategory {
    for (final c in categories) {
      if (c.id == categoryId) return c;
    }
    return null;
  }

  bool _typeMatches(Category c) => switch (type) {
    TransactionType.income => c.type == CategoryType.income,
    _ => c.type == CategoryType.expense,
  };

  Account? _accountById(int? id) {
    if (id == null) return null;
    for (final a in accounts) {
      if (a.id == id) return a;
    }
    return null;
  }
}

/// The verbatim 3-read picker load shared by the three tx-shaped form cubits.
/// Caller applies the `isClosed` guard + `emit` (state-typed, per-cubit).
Future<(List<Account>, List<Category>)> loadTxFormLookups(
  GetAccounts getAccounts,
  GetCategories getCategories,
) async {
  final accountsResult = await getAccounts(NoParams());
  final expenseResult = await getCategories(CategoryType.expense);
  final incomeResult = await getCategories(CategoryType.income);
  final accounts = accountsResult.getRight().toNullable() ?? const <Account>[];
  final expense = expenseResult.getRight().toNullable() ?? const <Category>[];
  final income = incomeResult.getRight().toNullable() ?? const <Category>[];
  return (accounts, [...expense, ...income]);
}
