import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/features/settings/pages/widgets/setting_option_tile.dart';

/// Appearance screen (More → Appearance, M6): pick the app theme mode
/// (Light / Dark / System). Reads + writes the app-global [AppSettingsCubit]
/// (provided at the root in `app.dart`), so a tap re-themes the whole app
/// instantly and persists across restarts.
class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final cubit = context.read<AppSettingsCubit>();
    final options = <(String, ThemeMode)>[
      (s.themeLight, ThemeMode.light),
      (s.themeDark, ThemeMode.dark),
      (s.themeSystem, ThemeMode.system),
    ];
    return AppScaffold(
      appBar: AppBar(title: Text(s.appearance)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          BlocBuilder<AppSettingsCubit, AppSettingsState>(
            buildWhen: (a, b) => a.themeMode != b.themeMode,
            builder: (context, state) => SettingsCard(
              children: [
                for (final (label, mode) in options)
                  SettingOptionTile(
                    label: label,
                    selected: state.themeMode == mode,
                    onTap: () => cubit.setThemeMode(mode),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
