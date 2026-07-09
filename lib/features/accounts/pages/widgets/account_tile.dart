import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';

/// A single reorderable account row: icon avatar + name + type label, trailing
/// balance and a drag handle. Dumb widget — tap/long-press are wired by the
/// list page. Needs a stable ancestor [Key] from the [ReorderableListView].
class AccountTile extends StatelessWidget {
  const AccountTile({
    required this.account,
    required this.index,
    super.key,
    this.onTap,
    this.onLongPress,
  });

  final Account account;

  /// Position in the reorderable list — drives the drag handle.
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tile = Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          CategoryIconAvatar(icon: account.icon, color: account.color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  _typeLabel(context, account.type),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          MoneyText(amount: account.balance, style: theme.textTheme.bodyLarge),
          const SizedBox(width: AppSpacing.sm),
          ReorderableDragStartListener(
            index: index,
            child: Icon(
              Icons.drag_indicator_rounded,
              color: context.colors.textTertiary,
            ),
          ),
        ],
      ),
    );

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Opacity(opacity: account.archived ? 0.5 : 1, child: tile),
    );
  }

  String _typeLabel(BuildContext context, AccountType type) {
    final s = Strings.of(context)!;
    return switch (type) {
      AccountType.cash => s.cash,
      AccountType.bank => s.bank,
      AccountType.ewallet => s.ewallet,
    };
  }
}
