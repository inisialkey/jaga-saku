import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/transactions/domain/entities/transaction.dart';
import 'package:jaga_saku/features/transactions/pages/form/add_transaction_page.dart';
import 'package:jaga_saku/features/transactions/pages/search/search_transaction_cubit.dart';
import 'package:jaga_saku/features/transactions/pages/search/widgets/active_filter_chips.dart';
import 'package:jaga_saku/features/transactions/pages/search/widgets/search_filter_sheet.dart';

/// Advanced Search screen (`/search`, V3-M3): an AppBar keyword field + filter
/// button, an active-filter chip bar, and a sorted result list over the existing
/// `transactions` table. The cubit is provided at the route; a debounced keyword
/// or an applied filter runs a single dynamic DAO query. Reached from the
/// Calendar search icon and More → Search Transactions.
class SearchTransactionPage extends StatefulWidget {
  const SearchTransactionPage({super.key});

  @override
  State<SearchTransactionPage> createState() => _SearchTransactionPageState();
}

class _SearchTransactionPageState extends State<SearchTransactionPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocBuilder<SearchTransactionCubit, SearchTransactionState>(
      builder: (context, state) {
        final cubit = context.read<SearchTransactionCubit>();
        return AppScaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                cubit.setKeyword(value);
                setState(() {}); // reflect the clear-button visibility
              },
              decoration: InputDecoration(
                hintText: s.searchHint,
                border: InputBorder.none,
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        tooltip: s.cancel,
                        onPressed: () {
                          _controller.clear();
                          cubit.reset();
                          setState(() {});
                        },
                      ),
              ),
            ),
            actions: [
              _FilterAction(
                count: state.params.activeFilterCount,
                onPressed: () => _openFilters(context),
              ),
            ],
          ),
          body: Column(
            children: [
              ActiveFilterChips(
                params: state.params,
                accountName: cubit.accountName,
                categoryName: cubit.categoryName,
                onRemove: cubit.updateFilters,
                onClearAll: cubit.clearFilters,
              ),
              Expanded(child: _SearchBody(state: state)),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openFilters(BuildContext context) async {
    final cubit = context.read<SearchTransactionCubit>();
    final result = await SearchFilterSheet.show(
      context,
      current: cubit.state.params,
      accounts: cubit.accountOptions,
      categories: cubit.categoryOptions,
    );
    if (result == null) return;
    await cubit.updateFilters(result);
  }
}

/// The filter [IconButton], badged with the active-filter count when non-zero.
class _FilterAction extends StatelessWidget {
  const _FilterAction({required this.count, required this.onPressed});

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final button = IconButton(
      icon: const Icon(Iconsax.filter),
      tooltip: s.searchFilters,
      onPressed: onPressed,
    );
    if (count == 0) return button;
    return Badge.count(count: count, child: button);
  }
}

/// Renders the body for the current [SearchTransactionState]: prompt / loading /
/// results (count header + list) / empty / failure.
class _SearchBody extends StatelessWidget {
  const _SearchBody({required this.state});

  final SearchTransactionState state;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return switch (state) {
      SearchInitial() => EmptyStateView(
        icon: Iconsax.search_normal,
        title: s.searchPromptTitle,
        message: s.searchPromptBody,
      ),
      SearchLoading() => const ListSkeleton(),
      SearchEmpty() => EmptyStateView(
        icon: Icons.search_off_rounded,
        title: s.searchEmptyTitle,
        message: s.searchEmptyBody,
      ),
      SearchFailure(:final failure) => ErrorStateView(
        title: s.errorLoadTitle,
        message: failure.localize(context),
        retryLabel: s.retry,
        onRetry: () =>
            context.read<SearchTransactionCubit>().updateFilters(state.params),
      ),
      SearchResults(:final items) => _ResultList(items: items),
    };
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({required this.items});

  final List<Transaction> items;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        kFabScrollBottomInset,
      ),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(
              s.searchResultCount(items.length),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          );
        }
        return _ResultRow(transaction: items[index - 1]);
      },
    );
  }
}

/// One result row — mirrors the Calendar ledger row (transfer / income / expense
/// branches, semantic sign + badges) and taps through to the existing edit form.
class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final cubit = context.read<SearchTransactionCubit>();
    final t = transaction;
    final account = cubit.accountOf(t);
    final category = cubit.categoryOf(t);
    final toAccount = cubit.toAccountOf(t);
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
      onTap: () =>
          context.push(AppRoute.add, extra: AddTransactionArgs(edit: t)),
    );
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
