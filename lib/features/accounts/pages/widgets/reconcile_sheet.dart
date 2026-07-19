import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/accounts/pages/reconcile/reconcile_cubit.dart';

/// Wallet reconciliation sheet (V2-M6), launched from the account edit form.
/// Shows the current derived balance, a counted-balance input (the M3 keypad),
/// a live delta preview, and a confirm button. Confirm writes ONE income/expense
/// correction tagged the reserved "Penyesuaian" category so the derived balance
/// matches the counted value; reports never see it.
///
/// Builds its own [ReconcileCubit] via [sl] in the [BlocProvider] factory
/// (route-parity — the `sl()` calls live only in the create closure). The
/// counted controller holds ONLY a positive value; the (possibly negative) delta
/// is computed in the cubit and rendered here, never fed back to the keypad — so
/// the M3 sign-strip never triggers.
class ReconcileSheet extends StatefulWidget {
  const ReconcileSheet({
    required this.accountId,
    required this.currentBalance,
    super.key,
  });

  final int accountId;
  final int currentBalance;

  static Future<void> show(
    BuildContext context, {
    required int accountId,
    required int currentBalance,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => BlocProvider(
      create: (_) => ReconcileCubit(
        getSystemCategory: sl(),
        saveTransaction: sl(),
        accountId: accountId,
        currentBalance: currentBalance,
      )..load(),
      child: ReconcileSheet(
        accountId: accountId,
        currentBalance: currentBalance,
      ),
    ),
  );

  @override
  State<ReconcileSheet> createState() => _ReconcileSheetState();
}

class _ReconcileSheetState extends State<ReconcileSheet> {
  // Positive-only, starts empty — the sign-strip is moot (see class doc).
  final _countedController = TextEditingController();

  @override
  void dispose() {
    _countedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocConsumer<ReconcileCubit, ReconcileState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ReconcileStatus.success:
            Navigator.of(context).pop();
          case ReconcileStatus.noChange:
            s.reconcileNoChange.toToastSuccess(context);
            Navigator.of(context).pop();
          case ReconcileStatus.failure:
            (state.error?.localize(context) ?? s.errorUnexpected).toToastError(
              context,
            );
          case ReconcileStatus.editing || ReconcileStatus.saving:
            break;
        }
      },
      builder: (context, state) {
        final cubit = context.read<ReconcileCubit>();
        return AppBottomSheet(
          title: s.reconcile,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FieldLabel(s.reconcileCurrent),
              MoneyText(
                amount: state.currentBalance,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              FieldLabel(s.reconcileCounted),
              AmountInputField(
                controller: _countedController,
                autofocus: true,
                onChanged: (value) =>
                    cubit.countedChanged(int.tryParse(value) ?? 0),
              ),
              const SizedBox(height: AppSpacing.md),
              _DeltaPreview(delta: state.delta),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: s.reconcile,
                isLoading: state.status == ReconcileStatus.saving,
                onPressed: state.canConfirm
                    ? () => cubit.confirm(s.reconcileNote)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Live "Will add / Will subtract / Already correct" preview for the delta.
class _DeltaPreview extends StatelessWidget {
  const _DeltaPreview({required this.delta});

  final int delta;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final (String text, Color color) = switch (delta) {
      > 0 => (s.reconcileWillAdd(formatRupiah(delta)), context.colors.income),
      < 0 => (
        s.reconcileWillSubtract(formatRupiah(delta.abs())),
        context.colors.expense,
      ),
      _ => (s.reconcileNoChange, context.colors.textSecondary),
    };
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
