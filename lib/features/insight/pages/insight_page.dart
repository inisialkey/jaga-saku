import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/insight/pages/insight_cubit.dart';
import 'package:jaga_saku/features/insight/pages/widgets/expense_donut_chart.dart';
import 'package:jaga_saku/features/insight/pages/widgets/insight_card.dart';
import 'package:jaga_saku/features/insight/pages/widgets/monthly_overview_card.dart';
import 'package:jaga_saku/features/insight/pages/widgets/need_want_card.dart';
import 'package:jaga_saku/features/insight/pages/widgets/planned_unplanned_card.dart';
import 'package:jaga_saku/features/insight/pages/widgets/section_empty.dart';

/// Insight tab (wireframe §4, design screen 4): a month selector over the
/// Monthly Overview, the Expense-by-Category donut + legend, Planned vs.
/// Unplanned, Need vs. Want, and the rule-based Spending Insight cards. The
/// cubit is provided at the route (see `app_router.dart`) and refreshes live via
/// [TxChangeNotifier]. Every section has its own empty state, so an empty month
/// is a calm zero-report, never an error.
class InsightPage extends StatelessWidget {
  const InsightPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return AppScaffold(
      appBar: AppBar(
        title: Text(s.insight),
        actions: [
          IconButton(
            tooltip: s.moneyStory,
            icon: const Icon(Icons.auto_stories_outlined),
            onPressed: () => context.push(AppRoute.moneyStory),
          ),
        ],
      ),
      body: BlocBuilder<InsightCubit, InsightState>(
        builder: (context, state) => switch (state) {
          InsightInitial() ||
          InsightLoading() => const Center(child: Loading()),
          InsightError(:final failure) => ErrorStateView(
            title: s.errorLoadTitle,
            message: failure.localize(context),
            retryLabel: s.retry,
            onRetry: () => context.read<InsightCubit>().reload(),
          ),
          InsightLoaded(:final report) => _InsightBody(report: report),
        },
      ),
    );
  }
}

class _InsightBody extends StatelessWidget {
  const _InsightBody({required this.report});

  final InsightReport report;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final cubit = context.read<InsightCubit>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: [
        MonthSelector(
          month: report.month,
          onPrevious: cubit.previousMonth,
          onNext: cubit.nextMonth,
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: s.monthlyOverview),
        MonthlyOverviewCard(
          income: report.income,
          expense: report.expense,
          saved: report.saved,
        ),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(title: s.expenseByCategory),
        ExpenseDonutChart(
          slices: report.expenseByCategory,
          totalExpense: report.expense,
          categoriesById: report.categoriesById,
        ),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(title: s.plannedVsUnplanned),
        PlannedUnplannedCard(split: report.plannedVsUnplanned),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(title: s.needVsWant),
        NeedWantCard(needVsWant: report.needVsWant),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(title: s.spendingInsight),
        _InsightList(report: report),
      ],
    );
  }
}

/// The fired insight cards, or a gentle empty note when no rule fired.
class _InsightList extends StatelessWidget {
  const _InsightList({required this.report});

  final InsightReport report;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    if (!report.hasInsights) {
      return AppCard(
        child: SectionEmpty(
          icon: Icons.lightbulb_outline_rounded,
          text: s.noInsightThisMonth,
        ),
      );
    }
    return Column(
      children: [
        for (final (index, item) in report.insights.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.md),
          InsightCard(item: item),
        ],
      ],
    );
  }
}
