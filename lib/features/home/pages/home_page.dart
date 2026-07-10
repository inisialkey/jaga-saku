import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/home/pages/home_cubit.dart';
import 'package:jaga_saku/features/home/pages/widgets/budget_guard_card.dart';
import 'package:jaga_saku/features/home/pages/widgets/daily_review_card.dart';
import 'package:jaga_saku/features/home/pages/widgets/home_header.dart';
import 'package:jaga_saku/features/home/pages/widgets/total_balance_card.dart';
import 'package:jaga_saku/features/settings/pages/app_settings_cubit.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';

/// Home dashboard (wireframe §1): greeting header, the Total Balance hero, a
/// Budget Guard card (empty state until M4), a Daily Review of today's spending,
/// and the recent transactions. The cubit is provided at the route (see
/// `app_router.dart`) and refreshes live via [TxChangeNotifier].
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return AppScaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) => switch (state) {
          HomeInitial() || HomeLoading() => const Center(child: Loading()),
          HomeError(:final failure) => ErrorStateView(
            title: s.errorLoadTitle,
            message: failure.localize(context),
            retryLabel: s.retry,
            onRetry: () => context.read<HomeCubit>().load(),
          ),
          HomeLoaded(:final dashboard) => _HomeBody(dashboard: dashboard),
        },
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.dashboard});

  final HomeDashboard dashboard;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    children: [
      // The greeting name is app-global (M6): read it from AppSettingsCubit so
      // editing it in Settings updates Home live. Only the header rebuilds.
      BlocBuilder<AppSettingsCubit, AppSettingsState>(
        buildWhen: (a, b) => a.userName != b.userName,
        builder: (context, settings) => HomeHeader(userName: settings.userName),
      ),
      const SizedBox(height: AppSpacing.xl),
      TotalBalanceCard(
        totalBalance: dashboard.totalBalance,
        monthIncome: dashboard.monthIncome,
        monthExpense: dashboard.monthExpense,
      ),
      const SizedBox(height: AppSpacing.lg),
      BudgetGuardCard(guard: dashboard.budgetGuard),
      const SizedBox(height: AppSpacing.lg),
      DailyReviewCard(
        todaySpent: dashboard.todaySpent,
        todayUnplanned: dashboard.todayUnplanned,
        topCategoryName: dashboard.topCategoryName,
      ),
      const SizedBox(height: AppSpacing.xl),
      _RecentSection(dashboard: dashboard),
    ],
  );
}

/// "Recent Transactions" header + up to 5 tiles. "See All" switches to the
/// Calendar tab (a branch change, hence `context.go`). Empty → a friendly state
/// with an "Add Transaction" CTA onto the `/add` route.
class _RecentSection extends StatelessWidget {
  const _RecentSection({required this.dashboard});

  final HomeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final recent = dashboard.recent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: s.recentTransactions,
          actionLabel: recent.isEmpty ? null : s.seeAll,
          onAction: recent.isEmpty ? null : () => context.go(AppRoute.calendar),
        ),
        if (recent.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: EmptyStateView(
              icon: Icons.receipt_long_outlined,
              title: s.emptyTransactionsTitle,
              message: s.emptyTransactionsMessage,
              actionLabel: s.addTransaction,
              onAction: () => context.push(AppRoute.add),
            ),
          )
        else
          for (final transaction in recent)
            _RecentTile(dashboard: dashboard, transaction: transaction),
      ],
    );
  }
}

/// One recent-transaction row. Resolves the account / category names from the
/// dashboard lookups (the same shape [CalendarPage] uses) and reuses the shared
/// [TransactionTile]. Tapping edits it via `/add`; the save pings
/// [TxChangeNotifier], which refreshes Home — no manual reload here.
class _RecentTile extends StatelessWidget {
  const _RecentTile({required this.dashboard, required this.transaction});

  final HomeDashboard dashboard;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final t = transaction;
    final account = dashboard.accountOf(t);
    final category = dashboard.categoryOf(t);
    final toAccount = dashboard.toAccountOf(t);
    final note = t.note?.trim();
    final hasNote = note != null && note.isNotEmpty;

    final String? iconKey;
    final int? color;
    final MoneySign sign;
    final String title;
    final String subtitle;

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
    }

    return TransactionTile(
      icon: iconKey,
      color: color,
      title: title,
      subtitle: subtitle,
      amount: t.amount,
      sign: sign,
      onTap: () => context.push(AppRoute.add, extra: t),
    );
  }
}

/// Joins the non-empty parts with " • " (e.g. "Makan • Cash").
String _joinParts(List<String?> parts) =>
    parts.where((p) => p != null && p.isNotEmpty).join(' • ');
