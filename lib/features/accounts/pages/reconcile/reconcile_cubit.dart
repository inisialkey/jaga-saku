import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/helper/common.dart';
import 'package:jaga_saku/features/categories/domain/usecases/get_system_category.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/domain/usecases/save_transaction.dart';

part 'reconcile_state.dart';
part 'reconcile_cubit.freezed.dart';

/// Sheet-scoped cubit for wallet reconciliation (V2-M6). Resolves the reserved
/// "Penyesuaian" pair once via [GetSystemCategory], tracks the counted balance,
/// and on [confirm] writes ONE income/expense correction so the always-derived
/// balance matches the counted value — the correction is a real ledger row that
/// moves balance for free (unchanged balance SQL) yet is excluded from reports.
///
/// Every emit is guarded by [isClosed] (rule 5). Built fresh per sheet open, so
/// each reconcile starts from clean state.
class ReconcileCubit extends Cubit<ReconcileState> {
  ReconcileCubit({
    required GetSystemCategory getSystemCategory,
    required SaveTransaction saveTransaction,
    required int accountId,
    required int currentBalance,
  }) : _getSystemCategory = getSystemCategory,
       _saveTransaction = saveTransaction,
       _accountId = accountId,
       super(ReconcileState(currentBalance: currentBalance));

  final GetSystemCategory _getSystemCategory;
  final SaveTransaction _saveTransaction;
  final int _accountId;
  int? _adjustmentInId;
  int? _adjustmentOutId;

  /// Resolves the reserved pair once. Either id missing (a `Right(null)` or a
  /// `Left` — a botched migration) ⇒ `systemReady = false` ⇒ confirm disabled +
  /// log; never crash, never write an untagged correction (C5).
  Future<void> load() async {
    final inRes = await _getSystemCategory('adjustment_in');
    final outRes = await _getSystemCategory('adjustment_out');
    if (isClosed) return;
    _adjustmentInId = inRes.getRight().toNullable()?.id;
    _adjustmentOutId = outRes.getRight().toNullable()?.id;
    final ready = _adjustmentInId != null && _adjustmentOutId != null;
    if (!ready) {
      log.e('Reconcile: reserved Penyesuaian pair missing — confirm disabled');
    }
    emit(state.copyWith(systemReady: ready));
  }

  void countedChanged(int counted) =>
      emit(state.copyWith(counted: counted, status: ReconcileStatus.editing));

  /// Writes one correction so the derived balance matches `counted`. [note] is
  /// the localized "Penyesuaian saldo" passed from the page (rule 17 — the cubit
  /// holds no raw user-facing strings). A no-op when the reserved pair is
  /// unavailable or [delta] is zero.
  Future<void> confirm(String note) async {
    if (!state.canConfirm) return;
    final delta = state.delta;
    if (delta == 0) {
      emit(state.copyWith(status: ReconcileStatus.noChange));
      return;
    }
    final isAdd = delta > 0;
    final categoryId = isAdd ? _adjustmentInId : _adjustmentOutId;
    // Belt-and-suspenders: canConfirm already gates on systemReady.
    if (categoryId == null) return;

    emit(state.copyWith(status: ReconcileStatus.saving));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final tx = Transaction(
      type: isAdd ? TransactionType.income : TransactionType.expense,
      amount: delta.abs(), // positive rupiah; sign implied by type
      accountId: _accountId,
      categoryId: categoryId,
      date: today,
      note: note,
      createdAt: now.millisecondsSinceEpoch,
    );
    final result = await _saveTransaction(tx);
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(status: ReconcileStatus.failure, error: failure)),
      (_) => emit(state.copyWith(status: ReconcileStatus.success)),
    );
  }
}
