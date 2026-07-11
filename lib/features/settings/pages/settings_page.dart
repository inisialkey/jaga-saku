import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/core/app_settings/app_settings_cubit.dart';
import 'package:jaga_saku/features/settings/pages/widgets/setting_option_tile.dart';

/// Settings screen (More → Settings, M6): switch the app language
/// (System / Indonesia / English) and edit the greeting name. Both read + write
/// the app-global [AppSettingsCubit], so a language change re-localizes the
/// whole app instantly and the name change updates the Home greeting live; both
/// persist across restarts.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final AppSettingsCubit _settings;
  late final TextEditingController _nameController;
  late final FocusNode _nameFocus;

  /// Last greeting name we persisted (trimmed). Dedupes the submit-then-blur
  /// double fire (the "done" IME action both submits and unfocuses) and skips a
  /// blur with no edit. Tracked locally because the cubit's `userName` only
  /// updates on the async emit, so it is stale right after a submit.
  late String _lastSavedName;

  @override
  void initState() {
    super.initState();
    // Seed from the already-loaded app-global settings (loaded pre-runApp).
    // Capture the cubit here (context.read is safe in initState) so the blur
    // listener can persist without touching context during teardown.
    _settings = context.read<AppSettingsCubit>();
    _lastSavedName = _settings.state.userName ?? '';
    _nameController = TextEditingController(text: _lastSavedName);
    _nameFocus = FocusNode()..addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_nameFocus.hasFocus) _persistName(_nameController.text);
  }

  /// Persist the greeting name on commit / focus loss — not per keystroke.
  /// No-ops when the trimmed value is unchanged.
  void _persistName(String value) {
    final trimmed = value.trim();
    if (trimmed == _lastSavedName) return;
    _lastSavedName = trimmed;
    _settings.setUserName(value);
  }

  @override
  void dispose() {
    _nameFocus
      ..removeListener(_onFocusChange)
      ..dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final languages = <(String, Locale?)>[
      (s.languageSystem, null),
      (s.languageIndonesian, const Locale('id')),
      (s.languageEnglish, const Locale('en')),
    ];
    return AppScaffold(
      appBar: AppBar(title: Text(s.settings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          SectionHeader(title: s.language),
          BlocBuilder<AppSettingsCubit, AppSettingsState>(
            buildWhen: (a, b) => a.locale != b.locale,
            builder: (context, state) => SettingsCard(
              children: [
                for (final (label, locale) in languages)
                  SettingOptionTile(
                    label: label,
                    selected: state.locale == locale,
                    onTap: () => _settings.setLocale(locale),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(title: s.name),
          AppCard(
            child: Row(
              children: [
                Icon(
                  Iconsax.user,
                  size: 20,
                  color: context.colors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: s.nameHint,
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                    // Persist on commit (keyboard "done") and on focus loss (see
                    // _onFocusChange) — not per keystroke, so a name edit no
                    // longer triggers a sqflite write + emit on every character.
                    onSubmitted: _persistName,
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
