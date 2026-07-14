import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/insight/pages/money_story_cubit.dart';
import 'package:jaga_saku/features/insight/pages/widgets/asset_trend_chart.dart';
import 'package:jaga_saku/features/insight/pages/widgets/need_want_card.dart';

/// Money Story screen (V2-M7, `/money-story`): a view-only monthly recap — a
/// saved-this-month hero, top category, biggest single expense, income-vs-expense
/// month-over-month, need/want, and the app's first net-worth `LineChart`
/// (12-month trend). The cubit is provided at the route (see `app_router.dart`)
/// and refreshes live via [TxChangeNotifier]. An empty month is a calm empty
/// state, never an error.
class MoneyStoryPage extends StatelessWidget {
  const MoneyStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return AppScaffold(
      appBar: AppBar(title: Text(s.moneyStoryTitle)),
      body: BlocBuilder<MoneyStoryCubit, MoneyStoryState>(
        builder: (context, state) => switch (state) {
          MoneyStoryInitial() ||
          MoneyStoryLoading() => const DashboardSkeleton(),
          MoneyStoryError(:final failure) => ErrorStateView(
            title: s.errorLoadTitle,
            message: failure.localize(context),
            retryLabel: s.retry,
            onRetry: () => context.read<MoneyStoryCubit>().reload(),
          ),
          MoneyStoryLoaded(:final story) => _StoryBody(story: story),
        },
      ),
    );
  }
}

class _StoryBody extends StatelessWidget {
  const _StoryBody({required this.story});

  final MoneyStory story;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final cubit = context.read<MoneyStoryCubit>();
    final selector = MonthSelector(
      month: story.month,
      onPrevious: cubit.previousMonth,
      onNext: cubit.nextMonth,
    );

    if (!story.hasData) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          selector,
          const SizedBox(height: AppSpacing.xxl),
          EmptyStateView(
            icon: Icons.auto_stories_outlined,
            title: s.noExpenseThisMonth,
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: [
        selector,
        const SizedBox(height: AppSpacing.lg),
        _HeroCard(story: story),
        if (story.topCategory != null) ...[
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(title: s.storyTopCategory),
          _TopCategoryCard(story: story),
        ],
        if (story.biggestExpense != null) ...[
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(title: s.storyBiggestExpense),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: _BiggestExpenseTile(story: story),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(title: s.storyVsLastMonth),
        _MoMCard(story: story),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(title: s.storyNeedWant),
        NeedWantCard(needVsWant: story.needVsWant),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(title: s.netWorth),
        _NetWorthHeader(story: story),
        const SizedBox(height: AppSpacing.md),
        AssetTrendChart(points: story.trend),
      ],
    );
  }
}

/// The saved-this-month hero: a narrative line + the big colored figure + the
/// savings rate. A deficit month (`saved < 0`) flips the copy and the sign.
class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.story});

  final MoneyStory story;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final theme = Theme.of(context);
    final compact = formatCompactRupiah(story.saved.abs());
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            story.isDeficit
                ? s.storyDeficit(compact)
                : s.storySavedHero(compact),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          MoneyText(
            amount: story.saved.abs(),
            sign: story.isDeficit ? MoneySign.expense : MoneySign.income,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            s.storySavingsRate(story.savingsRatePct),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// The single biggest-spending category this month (system excluded).
class _TopCategoryCard extends StatelessWidget {
  const _TopCategoryCard({required this.story});

  final MoneyStory story;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = story.topCategory;
    return AppCard(
      child: Row(
        children: [
          CategoryIconAvatar(icon: category?.icon, color: category?.color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(category?.name ?? '', style: theme.textTheme.bodyLarge),
          ),
          MoneyText(amount: story.topCategoryAmount, sign: MoneySign.expense),
        ],
      ),
    );
  }
}

/// Reuses [TransactionTile] for the biggest single expense, resolving its
/// category / account display values from the story lookups.
class _BiggestExpenseTile extends StatelessWidget {
  const _BiggestExpenseTile({required this.story});

  final MoneyStory story;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final t = story.biggestExpense!;
    final category = t.categoryId == null
        ? null
        : story.categoriesById[t.categoryId];
    final account = story.accountsById[t.accountId];
    final note = t.note ?? '';
    final title = note.isNotEmpty ? note : (category?.name ?? s.expense);
    final subtitle = [
      category?.name,
      account?.name,
    ].where((p) => p != null && p.isNotEmpty).join(' • ');
    return TransactionTile(
      icon: category?.icon,
      color: category?.color,
      title: title,
      subtitle: subtitle,
      amount: t.amount,
      sign: MoneySign.expense,
      hasReceipt: t.receiptPath != null,
    );
  }
}

/// Income + expense each with an up/down arrow vs the previous month.
class _MoMCard extends StatelessWidget {
  const _MoMCard({required this.story});

  final MoneyStory story;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return AppCard(
      child: Column(
        children: [
          _MoMRow(label: s.income, delta: story.momIncome),
          const SizedBox(height: AppSpacing.md),
          _MoMRow(label: s.expense, delta: story.momExpense),
        ],
      ),
    );
  }
}

class _MoMRow extends StatelessWidget {
  const _MoMRow({required this.label, required this.delta});

  final String label;
  final int delta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rose = delta >= 0;
    return Row(
      children: [
        Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
        Icon(
          rose ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
          size: 16,
          color: context.colors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.xs),
        MoneyText(amount: delta.abs(), style: theme.textTheme.bodyLarge),
      ],
    );
  }
}

/// The "12 months" label + the current net-worth figure above the trend chart.
class _NetWorthHeader extends StatelessWidget {
  const _NetWorthHeader({required this.story});

  final MoneyStory story;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          s.assetTrend12mo,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        MoneyText(amount: story.netWorth, style: theme.textTheme.titleMedium),
      ],
    );
  }
}
