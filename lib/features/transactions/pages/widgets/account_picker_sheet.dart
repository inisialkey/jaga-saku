import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';

/// Bottom sheet listing accounts (icon avatar + name + type), returning the
/// chosen [Account] (or `null` if dismissed). Reuses [AppBottomSheet] (M1).
/// Pass [excludeId] to drop an account from the list — used by the transfer
/// "To" picker so it can never equal the "From" account.
class AccountPickerSheet extends StatelessWidget {
  const AccountPickerSheet({
    required this.title,
    required this.accounts,
    super.key,
    this.selectedId,
  });

  final String title;
  final List<Account> accounts;
  final int? selectedId;

  static Future<Account?> show(
    BuildContext context, {
    required String title,
    required List<Account> accounts,
    int? selectedId,
    int? excludeId,
  }) {
    final options = excludeId == null
        ? accounts
        : accounts.where((a) => a.id != excludeId).toList();
    return showModalBottomSheet<Account>(
      context: context,
      builder: (_) => AccountPickerSheet(
        title: title,
        accounts: options,
        selectedId: selectedId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBottomSheet(
      title: title,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final account = accounts[index];
          final selected = account.id != null && account.id == selectedId;
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CategoryIconAvatar(
              icon: account.icon,
              color: account.color,
            ),
            title: Text(account.name, style: theme.textTheme.bodyLarge),
            subtitle: Text(_typeLabel(context, account.type)),
            trailing: selected
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                  )
                : null,
            onTap: () => Navigator.of(context).pop(account),
          );
        },
      ),
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
