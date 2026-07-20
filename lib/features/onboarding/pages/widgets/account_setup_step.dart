import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/accounts/domain/entities/account.dart';
import 'package:jaga_saku/features/onboarding/pages/widgets/onboarding_step_body.dart';

/// Suggested accounts, Cash aside (it is localized, so it is prepended at build
/// time). Brand names are deliberately NOT localized. Every icon key exists in
/// `AppIcons.catalog`.
const List<({String name, AccountType type, String icon})> _suggestions = [
  (name: 'BCA', type: AccountType.bank, icon: 'bank'),
  (name: 'Mandiri', type: AccountType.bank, icon: 'bank'),
  (name: 'BRI', type: AccountType.bank, icon: 'bank'),
  (name: 'BNI', type: AccountType.bank, icon: 'bank'),
  (name: 'GoPay', type: AccountType.ewallet, icon: 'ewallet'),
  (name: 'OVO', type: AccountType.ewallet, icon: 'ewallet'),
  (name: 'DANA', type: AccountType.ewallet, icon: 'ewallet'),
  (name: 'ShopeePay', type: AccountType.ewallet, icon: 'ewallet'),
];

/// Step 3 — the step with the real drop-off risk (§17). Empty: suggestion chips
/// that turn a blank form into a two-tap task. Populated: the accounts created
/// so far. Purely presentational — [onSuggestionTap] hands the prefill up to the
/// page, which pushes the real account form with it as `extra`.
class AccountSetupStep extends StatelessWidget {
  const AccountSetupStep({
    required this.accounts,
    required this.onSuggestionTap,
    super.key,
  });

  final List<Account> accounts;

  /// Receives a fully-seeded (unsaved) [Account] — name, type and icon — which
  /// the existing account form reads straight out of `state.extra`. This is the
  /// whole prefill mechanism; there is no fork of the form.
  final ValueChanged<Account> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return OnboardingStepBody(
      title: s.onboardingAccountsTitle,
      body: s.onboardingAccountsBody,
      child: accounts.isEmpty
          ? _Suggestions(onTap: onSuggestionTap)
          : _AccountList(accounts: accounts),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.onTap});

  final ValueChanged<Account> onTap;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final theme = Theme.of(context);
    // Cash first — it is the one suggestion that is localized copy, not a brand.
    final chips = <({String name, AccountType type, String icon})>[
      (name: s.cash, type: AccountType.cash, icon: 'wallet'),
      ..._suggestions,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.onboardingAccountsQuickAdd,
          style: theme.textTheme.labelMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final suggestion in chips)
              ActionChip(
                avatar: Icon(
                  AppIcons.resolve(suggestion.icon),
                  size: 18,
                  color: AppColors.primary,
                ),
                label: Text(suggestion.name),
                shape: StadiumBorder(
                  side: BorderSide(color: context.colors.border),
                ),
                onPressed: () => onTap(
                  Account(
                    name: suggestion.name,
                    type: suggestion.type,
                    icon: suggestion.icon,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _AccountList extends StatelessWidget {
  const _AccountList({required this.accounts});

  final List<Account> accounts;

  @override
  Widget build(BuildContext context) => HairlineCard(
    children: [for (final account in accounts) _AccountRow(account: account)],
  );
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final theme = Theme.of(context);
    final typeLabel = switch (account.type) {
      AccountType.cash => s.cash,
      AccountType.bank => s.bank,
      AccountType.ewallet => s.ewallet,
    };
    return Padding(
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
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  typeLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Rp0 renders as a normal amount in the default colour — never greyed
          // as "empty", never a warning (§20).
          MoneyText(amount: account.openingBalance),
        ],
      ),
    );
  }
}
