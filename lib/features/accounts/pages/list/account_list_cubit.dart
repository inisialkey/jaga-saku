import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/archive_account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/delete_account.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/get_accounts.dart';
import 'package:jaga_saku/features/accounts/domain/usecases/reorder_accounts.dart';

part 'account_list_cubit.freezed.dart';
part 'account_list_state.dart';

/// Result of [AccountListCubit.delete] the page acts on: a hard delete, or the
/// soft archive fallback taken when a delete is blocked (an in-use account in
/// M2). The page shows a soft "archived" toast for [archivedFallback].
enum DeleteOutcome { deleted, archivedFallback }

/// Drives the accounts list: load, archive toggle, per-item archive/delete and
/// drag reorder. Failures from usecases are folded into [AccountListError];
/// the widget localizes them (rule 17). Every emit is guarded by [isClosed].
class AccountListCubit extends Cubit<AccountListState> {
  AccountListCubit({
    required GetAccounts getAccounts,
    required DeleteAccount deleteAccount,
    required ArchiveAccount archiveAccount,
    required ReorderAccounts reorderAccounts,
  }) : _getAccounts = getAccounts,
       _deleteAccount = deleteAccount,
       _archiveAccount = archiveAccount,
       _reorderAccounts = reorderAccounts,
       super(const AccountListState.initial());

  final GetAccounts _getAccounts;
  final DeleteAccount _deleteAccount;
  final ArchiveAccount _archiveAccount;
  final ReorderAccounts _reorderAccounts;

  Future<void> load() async {
    final showArchived = switch (state) {
      AccountListLoaded(:final showArchived) => showArchived,
      _ => false,
    };
    emit(const AccountListState.loading());
    final result = await _getAccounts(NoParams());
    if (isClosed) return;
    emit(
      result.fold(
        AccountListState.error,
        (items) =>
            AccountListState.loaded(items: items, showArchived: showArchived),
      ),
    );
  }

  /// Flips the archived filter without a DB round-trip (the full set is already
  /// loaded).
  void toggleArchived() {
    final s = state;
    if (s is AccountListLoaded) {
      emit(s.copyWith(showArchived: !s.showArchived));
    }
  }

  Future<void> archive(int id, {required bool archived}) async {
    final result = await _archiveAccount(
      ArchiveAccountParams(id: id, archived: archived),
    );
    if (isClosed) return;
    final failure = result.getLeft().toNullable();
    if (failure != null) {
      emit(AccountListState.error(failure));
    } else {
      await load();
    }
  }

  Future<DeleteOutcome> delete(int id) async {
    final result = await _deleteAccount(id);
    if (isClosed) return DeleteOutcome.deleted;
    // ponytail: delete always succeeds in M1 (empty transactions table). The
    // Left path is the M2 fallback — a delete blocked by an FK archives the
    // account instead so it leaves the active list without losing history; the
    // returned outcome lets the page surface a soft "archived" notice.
    if (result.isLeft()) {
      await archive(id, archived: true);
      return DeleteOutcome.archivedFallback;
    }
    await load();
    return DeleteOutcome.deleted;
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final s = state;
    if (s is! AccountListLoaded) return;
    final result = _reordered(
      s.items,
      showArchived: s.showArchived,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );
    // Optimistic: render the new order at once (no loading flash), then persist.
    emit(s.copyWith(items: result.all));
    final saved = await _reorderAccounts(result.visibleIds);
    if (isClosed) return;
    // Revert to the DB's authoritative order if the write failed.
    if (saved.isLeft()) await load();
  }

  /// Reorders the visible (filtered) slice and returns the merged full list plus
  /// the visible ids whose `sort_order` must be persisted. Hidden (archived)
  /// rows keep their order and are appended unchanged. [newIndex] is already
  /// adjusted for the removed item (ReorderableListView `onReorderItem`).
  ({List<Account> all, List<int> visibleIds}) _reordered(
    List<Account> items, {
    required bool showArchived,
    required int oldIndex,
    required int newIndex,
  }) {
    final visible = showArchived
        ? [...items]
        : items.where((a) => !a.archived).toList();
    final hidden = showArchived
        ? <Account>[]
        : items.where((a) => a.archived).toList();
    final moved = visible.removeAt(oldIndex);
    visible.insert(newIndex, moved);
    return (
      all: [...visible, ...hidden],
      visibleIds: [
        for (final a in visible)
          if (a.id != null) a.id!,
      ],
    );
  }
}
