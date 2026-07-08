import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/settings/settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<DataHelper> _listLanguage = [
    DataHelper(title: Constants.get.english, type: 'en'),
    DataHelper(title: Constants.get.bahasa, type: 'id'),
  ];

  @override
  Widget build(BuildContext context) {
    // Single source of truth: derive theme + locale from SettingsCubit.
    final settingsState = context.watch<SettingsCubit>().state;
    final selectedTheme = settingsState is SettingsStateLoaded
        ? settingsState.activeTheme
        : ActiveTheme.system;
    final selectedLocale = settingsState is SettingsStateLoaded
        ? settingsState.locale
        : 'en';
    final selectedLanguage = selectedLocale == 'en'
        ? _listLanguage[0]
        : _listLanguage[1];

    return Parent(
      appBar: MyAppBar(
        title: Strings.of(context)!.settings,
        onBack: () => context.pop(),
      ),

      child: SingleChildScrollView(
        padding: EdgeInsets.all(Dimens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1
            Text(
              Strings.of(context)!.personal,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Palette.subText),
            ),
            SpacerV(value: Dimens.space8),
            Container(
              padding: EdgeInsets.all(Dimens.space12),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Palette.backgroundDark.withValues(alpha: 0.1),
                    blurRadius: 2,
                  ),
                ],
                color: Theme.of(context).brightness == Brightness.dark
                    ? Palette.primary.withValues(alpha: 0.1)
                    : Palette.background,
                borderRadius: BorderRadius.circular(Dimens.space16),
              ),
              child: Column(
                children: [
                  MenuSection(
                    title: Strings.of(context)!.userInfo,
                    onTap: () {
                      context.pushNamed(Routes.userInformation.name);
                    },
                  ),
                  MenuSection(
                    title: Strings.of(context)!.account,
                    onTap: () {
                      context.pushNamed(Routes.account.name);
                    },
                    showDivider: false,
                  ),
                ],
              ),
            ),
            SpacerV(value: Dimens.space5),

            // Section 2
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.space8),
              child: Text(
                Strings.of(context)!.other,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: Palette.subText),
              ),
            ),
            Container(
              padding: EdgeInsets.all(Dimens.space12),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Palette.backgroundDark.withValues(alpha: 0.1),
                    blurRadius: 2,
                  ),
                ],
                color: Theme.of(context).brightness == Brightness.dark
                    ? Palette.primary.withValues(alpha: 0.1)
                    : Palette.background,
                borderRadius: BorderRadius.circular(Dimens.space16),
              ),
              child: Column(
                children: [
                  MenuSection(
                    title: Strings.of(context)!.chooseTheme,

                    subtitle: Text(
                      selectedTheme == ActiveTheme.dark
                          ? Strings.of(context)!.dark
                          : Strings.of(context)!.light,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Palette.background
                            : Palette.subText,
                      ),
                    ),

                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: selectedTheme == ActiveTheme.dark,
                        onChanged: (isDark) {
                          context.read<SettingsCubit>().updateTheme(
                            isDark ? ActiveTheme.dark : ActiveTheme.light,
                          );
                        },
                      ),
                    ),
                  ),
                  MenuSection(
                    title: Strings.of(context)!.chooseLanguage,
                    subtitle: Text(
                      selectedLanguage.title ?? '-',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Palette.background
                            : Palette.subText,
                      ),
                    ),
                    showDivider: false,
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (_) => SafeArea(
                        child: Padding(
                          padding: EdgeInsets.all(Dimens.space24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _listLanguage
                                .map(
                                  (data) => ListTile(
                                    title: Text(
                                      data.title ?? '-',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: Palette.primary),
                                    ),
                                    trailing: selectedLanguage == data
                                        ? const Icon(
                                            Icons.check,
                                            color: Palette.primary,
                                          )
                                        : null,
                                    onTap: () {
                                      context
                                          .read<SettingsCubit>()
                                          .updateLanguage(data.type ?? 'en');
                                      context.pop();
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SpacerV(value: Dimens.space16),
            Center(
              child: TextButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const LogoutDialog(),
                ),
                child: Text(
                  Strings.of(context)!.logout,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
