import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';

/// The More tab: an app-info header + grouped menu (Finance / Data / App).
/// Live tiles: Accounts / Categories / Budget (Finance) and Appearance /
/// Settings / About (App). Still deferred to V2 (muted "Soon" badge, inert):
/// Recurring, Export CSV, Backup & Restore, and Security.
class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final colors = context.colors;
    return AppScaffold(
      appBar: AppBar(title: Text(s.more)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          const _AppInfoHeader(),
          const SizedBox(height: AppSpacing.xl),
          MenuSection(
            title: s.finance,
            tiles: [
              MenuTile(
                icon: Iconsax.wallet,
                title: s.accounts,
                onTap: () => context.push(AppRoute.accounts),
              ),
              MenuTile(
                icon: Iconsax.category_2,
                iconColor: colors.transfer,
                title: s.categories,
                onTap: () => context.push(AppRoute.categories),
              ),
              MenuTile(
                icon: Iconsax.wallet_money,
                iconColor: colors.warning,
                title: s.budget,
                onTap: () => context.push(AppRoute.budget),
              ),
              MenuTile(
                icon: Iconsax.star,
                iconColor: colors.income,
                title: s.favorites,
                onTap: () => context.push(AppRoute.favorites),
              ),
              MenuTile(
                icon: Iconsax.repeat,
                iconColor: colors.info,
                title: s.recurring,
                trailing: const ComingSoonBadge(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          MenuSection(
            title: s.data,
            tiles: [
              MenuTile(
                icon: Iconsax.document_download,
                iconColor: colors.success,
                title: s.exportCsv,
                trailing: const ComingSoonBadge(),
              ),
              MenuTile(
                icon: Iconsax.cloud,
                iconColor: colors.transfer,
                title: s.backupRestore,
                trailing: const ComingSoonBadge(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          MenuSection(
            title: s.app,
            tiles: [
              MenuTile(
                icon: Iconsax.brush_1,
                iconColor: colors.warning,
                title: s.appearance,
                onTap: () => context.push(AppRoute.appearance),
              ),
              MenuTile(
                icon: Iconsax.shield_tick,
                iconColor: colors.info,
                title: s.security,
                trailing: const ComingSoonBadge(),
              ),
              MenuTile(
                icon: Iconsax.setting_2,
                iconColor: colors.textSecondary,
                title: s.settings,
                onTap: () => context.push(AppRoute.settings),
              ),
              MenuTile(
                icon: Iconsax.info_circle,
                iconColor: colors.info,
                title: s.about,
                onTap: () => context.push(AppRoute.about),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppInfoHeader extends StatelessWidget {
  const _AppInfoHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(Iconsax.wallet, color: AppColors.primaryDark),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Constants.get.appName, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  Strings.of(context)!.appTagline,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
