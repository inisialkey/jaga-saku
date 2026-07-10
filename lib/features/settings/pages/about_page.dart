import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/settings/pages/widgets/setting_option_tile.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// About screen (More → About, M6): app icon, name, tagline and the real
/// runtime version (via `package_info_plus`), plus a Licenses row that opens
/// Flutter's built-in [showLicensePage]. Read-only.
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _info = info);
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final info = _info;
    final version = info == null
        ? null
        : '${info.version} (${info.buildNumber})';
    return AppScaffold(
      appBar: AppBar(title: Text(s.about)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          _AboutHeader(version: version),
          const SizedBox(height: AppSpacing.xl),
          SettingsCard(
            children: [
              MenuTile(
                icon: Iconsax.document_text,
                iconColor: context.colors.info,
                title: s.licenses,
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: Constants.get.appName,
                  applicationVersion: info?.version,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutHeader extends StatelessWidget {
  const _AboutHeader({required this.version});

  final String? version;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = Strings.of(context)!;
    return AppCard(
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(
              Iconsax.wallet,
              color: AppColors.primaryDark,
              size: 30,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(Constants.get.appName, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            s.appTagline,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          if (version != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              s.appVersion(version!),
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.colors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
