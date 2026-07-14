import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/calendar/pages/calendar_cubit.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/form/add_transaction_page.dart';
import 'package:table_calendar/table_calendar.dart';

/// Calendar ledger (wireframe §2): a green-themed month grid with per-day event
/// dots, a selected-day income/expense/balance summary, and that day's
/// transaction list. Tapping a tile edits it; long-press deletes via a confirm
/// sheet. The cubit is provided at the route (see `app_router.dart`).
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) => AppScaffold(
        appBar: AppBar(title: Text(s.calendar)),
        body: state.status == CalendarStatus.error && state.failure != null
            ? ErrorStateView(
                title: s.errorLoadTitle,
                message: state.failure!.localize(context),
                retryLabel: s.retry,
                onRetry: () => context.read<CalendarCubit>().load(),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  kFabScrollBottomInset, // clear the center Add FAB
                ),
                children: [
                  _CalendarCard(state: state),
                  const SizedBox(height: AppSpacing.lg),
                  _DaySummaryCard(state: state),
                  const SizedBox(height: AppSpacing.lg),
                  _DayList(state: state),
                ],
              ),
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({required this.state});

  final CalendarState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<CalendarCubit>();
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      child: TableCalendar<Transaction>(
        locale: 'id',
        firstDay: DateTime(2000),
        lastDay: DateTime(2100, 12, 31),
        focusedDay: state.calendarFocusedDay,
        currentDay: DateTime.now(),
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableGestures: AvailableGestures.horizontalSwipe,
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        selectedDayPredicate: (day) => isSameDay(day, state.selectedDay),
        eventLoader: state.transactionsOn,
        onDaySelected: (selectedDay, _) => cubit.selectDay(selectedDay),
        onPageChanged: cubit.changeMonth,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: theme.textTheme.titleMedium ?? const TextStyle(),
          leftChevronIcon: Icon(
            Icons.chevron_left_rounded,
            color: context.colors.textSecondary,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right_rounded,
            color: context.colors.textSecondary,
          ),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w600,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
          markersMaxCount: 1,
          markerSize: 5,
          markerDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _DaySummaryCard extends StatelessWidget {
  const _DaySummaryCard({required this.state});

  final CalendarState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = Strings.of(context)!;
    final balancePositive = state.dayBalance >= 0;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _formatDay(state.selectedDay),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          _SummaryRow(
            label: s.incomeLabel,
            amount: state.dayIncome,
            sign: MoneySign.income,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SummaryRow(
            label: s.expenseLabel,
            amount: state.dayExpense,
            sign: MoneySign.expense,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(color: context.colors.border, height: 1),
          ),
          _SummaryRow(
            label: s.balanceLabel,
            amount: state.dayBalance.abs(),
            sign: balancePositive ? MoneySign.income : MoneySign.expense,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amount,
    required this.sign,
  });

  final String label;
  final int amount;
  final MoneySign sign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        MoneyText(
          amount: amount,
          sign: sign,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _DayList extends StatelessWidget {
  const _DayList({required this.state});

  final CalendarState state;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final transactions = state.selectedDayTransactions;
    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xxl),
        child: EmptyStateView(
          icon: Icons.receipt_long_outlined,
          title: s.emptyDayTitle,
          message: s.emptyDayMessage,
        ),
      );
    }
    return Column(
      children: [
        for (final transaction in transactions)
          _TransactionRow(state: state, transaction: transaction),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.state, required this.transaction});

  final CalendarState state;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final t = transaction;
    final account = state.accountOf(t);
    final category = state.categoryOf(t);
    final toAccount = state.toAccountOf(t);
    final note = t.note?.trim();
    final hasNote = note != null && note.isNotEmpty;

    final String? iconKey;
    final int? color;
    final MoneySign sign;
    final String title;
    final String subtitle;
    final badges = <String>[];

    switch (t.type) {
      case TransactionType.transfer:
        iconKey = 'transfer';
        color = AppColors.transfer.toARGB32();
        sign = MoneySign.transfer;
        title = hasNote ? note : s.transfer;
        subtitle = '${account?.name ?? '-'} → ${toAccount?.name ?? '-'}';
      case TransactionType.income:
        iconKey = category?.icon;
        color = category?.color;
        sign = MoneySign.income;
        title = hasNote ? note : (category?.name ?? s.income);
        subtitle = _joinParts([category?.name, account?.name]);
      case TransactionType.expense:
        iconKey = category?.icon;
        color = category?.color;
        sign = MoneySign.expense;
        title = hasNote ? note : (category?.name ?? s.expense);
        subtitle = _joinParts([category?.name, account?.name]);
        final spending = _spendingLabel(s, t.spendingType);
        final planned = _plannedLabel(s, t.plannedStatus);
        if (spending != null) badges.add(spending);
        if (planned != null) badges.add(planned);
    }

    return TransactionTile(
      icon: iconKey,
      color: color,
      title: title,
      subtitle: subtitle,
      badges: badges,
      amount: t.amount,
      sign: sign,
      hasReceipt: t.receiptPath != null,
      onTap: () => _edit(context),
      onLongPress: () => _confirmDelete(context),
    );
  }

  /// Opens the edit form. Fire-and-forget: a successful save pings
  /// [TxChangeNotifier], which refreshes this calendar via its subscription — so
  /// no manual `refresh()` is needed here (the W2 fix).
  void _edit(BuildContext context) =>
      context.push(AppRoute.add, extra: AddTransactionArgs(edit: transaction));

  Future<void> _confirmDelete(BuildContext context) async {
    final cubit = context.read<CalendarCubit>();
    final s = Strings.of(context)!;
    final confirmed = await ConfirmSheet.show(
      context,
      title: s.deleteTransaction,
      message: s.deleteTransactionConfirm,
      confirmLabel: s.delete,
      cancelLabel: s.cancel,
      destructive: true,
    );
    if (!confirmed || transaction.id == null) return;
    await cubit.deleteTransaction(transaction.id!);
  }
}

/// Joins the non-empty parts with " • " (e.g. "Makan • Cash").
String _joinParts(List<String?> parts) =>
    parts.where((p) => p != null && p.isNotEmpty).join(' • ');

String? _spendingLabel(Strings s, SpendingType? type) => switch (type) {
  SpendingType.need => s.need,
  SpendingType.want => s.want,
  SpendingType.lifestyle => s.lifestyle,
  SpendingType.emergency => s.emergency,
  null => null,
};

String? _plannedLabel(Strings s, PlannedStatus? status) => switch (status) {
  PlannedStatus.planned => s.planned,
  PlannedStatus.unplanned => s.unplanned,
  null => null,
};

/// "8 Jul 2026" in Indonesian month names (id symbols loaded in main.dart).
String _formatDay(DateTime day) => DateFormat('d MMM yyyy', 'id').format(day);
