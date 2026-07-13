import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget.dart';
import 'package:jaga_saku/features/budgets/domain/entities/budget_status.dart';
import 'package:jaga_saku/features/budgets/pages/form/budget_form_page.dart';
import 'package:jaga_saku/features/budgets/pages/list/budget_list_cubit.dart';
import 'package:jaga_saku/features/budgets/pages/widgets/budget_item_card.dart';
import 'package:jaga_saku/features/budgets/pages/widgets/cycle_selector.dart';
import 'package:jaga_saku/features/categories/domain/entities/category.dart';

/// Budget screen (wireframe): a month selector over a list of per-category
/// [BudgetItemCard]s with full CRUD. The cubit is provided at the route (see
/// `app_router.dart`) and refreshes live via [TxChangeNotifier].
class BudgetListPage extends StatelessWidget {
  const BudgetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return AppScaffold(
      appBar: AppBar(
        title: Text(s.budget),
        actions: [
          IconButton(
            tooltip: s.createBudget,
            icon: const Icon(Iconsax.add),
            onPressed: () => _openBudgetForm(context),
          ),
        ],
      ),
      body: BlocBuilder<BudgetListCubit, BudgetListState>(
        builder: (context, state) => switch (state) {
          BudgetListInitial() || BudgetListLoading() => const ListSkeleton(),
          BudgetListError(:final failure) => ErrorStateView(
            title: s.errorLoadTitle,
            message: failure.localize(context),
            retryLabel: s.retry,
            onRetry: () => context.read<BudgetListCubit>().load(),
          ),
          BudgetListLoaded(
            :final cycleStart,
            :final cycleEnd,
            :final budgets,
            :final categoriesById,
          ) =>
            _BudgetListBody(
              cycleStart: cycleStart,
              cycleEnd: cycleEnd,
              budgets: budgets,
              categoriesById: categoriesById,
            ),
        },
      ),
    );
  }
}

class _BudgetListBody extends StatelessWidget {
  const _BudgetListBody({
    required this.cycleStart,
    required this.cycleEnd,
    required this.budgets,
    required this.categoriesById,
  });

  final int cycleStart;
  final int cycleEnd;
  final List<Budget> budgets;
  final Map<int, Category> categoriesById;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final cubit = context.read<BudgetListCubit>();
    final now = DateTime.now();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: CycleSelector(
            start: cycleStart,
            end: cycleEnd,
            onPrevious: cubit.previousCycle,
            onNext: cubit.nextCycle,
          ),
        ),
        Expanded(
          child: budgets.isEmpty
              ? EmptyStateView(
                  icon: Iconsax.wallet_money,
                  title: s.budgetEmptyTitle,
                  message: s.budgetEmptyMessage,
                  actionLabel: s.createBudget,
                  onAction: () => _openBudgetForm(
                    context,
                    month: DateTime.fromMillisecondsSinceEpoch(cycleStart),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.xxl,
                  ),
                  itemCount: budgets.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final budget = budgets[index];
                    final status = BudgetStatus.compute(
                      limitAmount: budget.limitAmount,
                      spent: budget.spent,
                      now: now,
                      periodStart: budget.periodStart,
                      periodEnd: budget.periodEnd,
                    );
                    return BudgetItemCard(
                      budget: budget,
                      status: status,
                      category: categoriesById[budget.categoryId],
                      onTap: () => _openBudgetForm(context, initial: budget),
                      onDelete: () => _confirmDelete(context, budget),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Pushes the budget form (create when [initial] is null, seeded to [month]) and
/// reloads the list when it pops with a success result.
Future<void> _openBudgetForm(
  BuildContext context, {
  Budget? initial,
  DateTime? month,
}) async {
  final cubit = context.read<BudgetListCubit>();
  final saved = await context.push<bool>(
    AppRoute.budgetForm,
    extra: BudgetFormArgs(initial: initial, month: month),
  );
  if (saved ?? false) await cubit.load();
}

Future<void> _confirmDelete(BuildContext context, Budget budget) async {
  final cubit = context.read<BudgetListCubit>();
  final s = Strings.of(context)!;
  final confirmed = await ConfirmSheet.show(
    context,
    title: s.delete,
    message: s.deleteBudgetConfirm,
    confirmLabel: s.delete,
    cancelLabel: s.cancel,
    destructive: true,
  );
  if (!confirmed || budget.id == null) return;
  await cubit.delete(budget.id!);
}
