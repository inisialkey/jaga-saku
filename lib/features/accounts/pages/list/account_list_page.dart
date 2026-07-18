import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/accounts/pages/list/account_list_cubit.dart';
import 'package:jaga_saku/features/accounts/pages/widgets/account_tile.dart';

/// Accounts list: Total Asset header + reorderable [AccountTile]s with full CRUD
/// and archive. The cubit is provided at the route (see `app_router.dart`).
class AccountListPage extends StatelessWidget {
  const AccountListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocBuilder<AccountListCubit, AccountListState>(
      builder: (context, state) {
        final showArchived = state is AccountListLoaded && state.showArchived;
        return AppScaffold(
          appBar: AppBar(
            title: Text(s.accounts),
            actions: [
              if (state is AccountListLoaded)
                IconButton(
                  tooltip: showArchived ? s.hideArchived : s.showArchived,
                  icon: Icon(showArchived ? Iconsax.eye : Iconsax.eye_slash),
                  onPressed: () =>
                      context.read<AccountListCubit>().toggleArchived(),
                ),
              IconButton(
                tooltip: s.addAccount,
                icon: const Icon(Iconsax.add),
                onPressed: () => _openAccountForm(context),
              ),
            ],
          ),
          body: switch (state) {
            AccountListInitial() ||
            AccountListLoading() => const ListSkeleton(),
            AccountListError(:final failure) => ErrorStateView(
              title: s.errorLoadTitle,
              message: failure.localize(context),
              retryLabel: s.retry,
              onRetry: () => context.read<AccountListCubit>().load(),
            ),
            AccountListLoaded(:final items, :final showArchived) =>
              _AccountListBody(
                items: items,
                showArchived: showArchived,
                total: state.totalBalance,
              ),
          },
        );
      },
    );
  }
}

class _AccountListBody extends StatelessWidget {
  const _AccountListBody({
    required this.items,
    required this.showArchived,
    required this.total,
  });

  final List<Account> items;
  final bool showArchived;

  /// Σ balance over non-archived accounts (resolved by `AccountListState`).
  final int total;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final visible = showArchived
        ? items
        : items.where((a) => !a.archived).toList();

    if (visible.isEmpty) {
      return EmptyStateView(
        icon: Iconsax.wallet,
        title: s.emptyAccountsTitle,
        message: s.emptyAccountsMessage,
        actionLabel: s.addAccount,
        onAction: () => _openAccountForm(context),
      );
    }

    return Column(
      children: [
        _TotalAssetHeader(total: total),
        Expanded(
          child: ReorderableListView.builder(
            buildDefaultDragHandles: false,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            itemCount: visible.length,
            onReorderItem: (oldIndex, newIndex) =>
                context.read<AccountListCubit>().reorder(oldIndex, newIndex),
            itemBuilder: (context, index) {
              final account = visible[index];
              return AccountTile(
                key: ValueKey(account.id),
                account: account,
                index: index,
                onTap: () => _openAccountForm(context, account: account),
                onLongPress: () => _showAccountActions(context, account),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TotalAssetHeader extends StatelessWidget {
  const _TotalAssetHeader({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.of(context)!.totalAsset,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            MoneyText(amount: total, style: theme.textTheme.displayMedium),
          ],
        ),
      ),
    );
  }
}

/// Pushes the account form (create when [account] is null) and reloads the list
/// when it pops with a success result.
Future<void> _openAccountForm(BuildContext context, {Account? account}) async {
  final cubit = context.read<AccountListCubit>();
  final saved = await context.push<bool>(AppRoute.accountForm, extra: account);
  if (saved ?? false) await cubit.load();
}

enum _AccountAction { edit, archive, delete }

/// Long-press actions: edit / archive-toggle / delete (delete goes through a
/// confirm sheet).
Future<void> _showAccountActions(BuildContext context, Account account) async {
  final cubit = context.read<AccountListCubit>();
  final s = Strings.of(context)!;
  final action = await showModalBottomSheet<_AccountAction>(
    context: context,
    builder: (sheetContext) => AppBottomSheet(
      title: account.name,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Iconsax.edit),
            title: Text(s.edit),
            onTap: () => Navigator.of(sheetContext).pop(_AccountAction.edit),
          ),
          ListTile(
            leading: Icon(
              account.archived ? Iconsax.archive_tick : Iconsax.archive,
            ),
            title: Text(account.archived ? s.unarchive : s.archive),
            onTap: () => Navigator.of(sheetContext).pop(_AccountAction.archive),
          ),
          ListTile(
            leading: Icon(Iconsax.trash, color: context.colors.critical),
            title: Text(
              s.delete,
              style: TextStyle(color: context.colors.critical),
            ),
            onTap: () => Navigator.of(sheetContext).pop(_AccountAction.delete),
          ),
        ],
      ),
    ),
  );
  if (action == null || !context.mounted) return;

  switch (action) {
    case _AccountAction.edit:
      await _openAccountForm(context, account: account);
    case _AccountAction.archive:
      await cubit.archive(account.id!, archived: !account.archived);
    case _AccountAction.delete:
      final confirmed = await ConfirmSheet.show(
        context,
        title: s.delete,
        message: s.deleteAccountConfirm,
        confirmLabel: s.delete,
        cancelLabel: s.cancel,
        destructive: true,
      );
      if (!confirmed) return;
      final outcome = await cubit.delete(account.id!);
      if (outcome == DeleteOutcome.archivedFallback && context.mounted) {
        s.accountArchivedFallback.toToastSuccess(context);
      }
  }
}
