import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jaga_saku/app_router.dart';
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
            builder: (context, state) => HairlineCard(
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
          const SizedBox(height: AppSpacing.xl),
          // Budget cycle start-day (V2-M1). Day 1 == the calendar month (the
          // default, zero behavior change); a custom day makes every budget run
          // day-N → day-(N-1). The picker writes through the app-global cubit,
          // which pings the tx bus so open budget views recompute live.
          BlocBuilder<AppSettingsCubit, AppSettingsState>(
            buildWhen: (a, b) => a.budgetCycleStartDay != b.budgetCycleStartDay,
            builder: (context, state) {
              final day = state.budgetCycleStartDay;
              return MenuSection(
                title: s.budgetCycle,
                tiles: [
                  MenuTile(
                    icon: Iconsax.calendar_1,
                    title: day == 1
                        ? s.budgetCycleMonthly
                        : s.budgetCycleStartDay(day),
                    onTap: () => _showCycleStartDayPicker(context, day),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          // Reminders (V3-M5): local notification settings on their own screen
          // (decision 5 — a Settings row, not a top-level More tile).
          MenuSection(
            title: s.reminders,
            tiles: [
              MenuTile(
                icon: Iconsax.notification,
                title: s.reminders,
                onTap: () => context.push(AppRoute.reminders),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Day-of-month picker (1..31): day 1 is labelled "monthly calendar", the rest
  /// "Day N". Choosing one persists it via the app-global cubit (which pings the
  /// tx bus so budget views recompute live) and closes the sheet. Scroll-
  /// controlled so the whole month fits, and opens scrolled to the current day
  /// (D6).
  Future<void> _showCycleStartDayPicker(BuildContext context, int current) {
    final s = Strings.of(context)!;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => AppBottomSheet(
        title: s.budgetCycle,
        child: _CycleStartDayPicker(
          current: current,
          onSelected: (day) {
            _settings.setBudgetCycleStartDay(day);
            Navigator.of(sheetContext).pop();
          },
        ),
      ),
    );
  }
}

/// The 1..31 day list for the budget-cycle picker (D6). Opens scrolled to the
/// current day instead of always at the top; owns + disposes its
/// [ScrollController].
class _CycleStartDayPicker extends StatefulWidget {
  const _CycleStartDayPicker({required this.current, required this.onSelected});

  final int current;
  final ValueChanged<int> onSelected;

  @override
  State<_CycleStartDayPicker> createState() => _CycleStartDayPickerState();
}

class _CycleStartDayPickerState extends State<_CycleStartDayPicker> {
  static const double _itemExtent = 48;

  late final ScrollController _controller;
  bool _controllerInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Build the controller here (not initState) so the initial offset uses the
    // Dynamic-Type-scaled row extent: MediaQuery is available in
    // didChangeDependencies and it runs once before the first build. With a
    // scaled row height but a base-48 offset the selected day scrolls off-screen
    // for high days at >1.0×. Lands the current day ~two rows below the top of
    // the viewport (byte-identical to the 48px math at 1.0×).
    if (_controllerInitialized) return;
    _controllerInitialized = true;
    final extent = MediaQuery.textScalerOf(context).scale(_itemExtent);
    _controller = ScrollController(
      initialScrollOffset: ((widget.current - 1) * extent - 2 * extent).clamp(
        0.0,
        double.infinity,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    // Scale the row extent with Dynamic Type (pixel-identical at 1.0×) so the
    // day label isn't vertically clipped when the system font size grows.
    final itemExtent = MediaQuery.textScalerOf(context).scale(_itemExtent);
    return SizedBox(
      height: 360,
      child: ListView.builder(
        controller: _controller,
        padding: EdgeInsets.zero,
        itemCount: 31,
        itemExtent: itemExtent,
        itemBuilder: (_, index) {
          final day = index + 1;
          return SettingOptionTile(
            label: day == 1 ? s.budgetCycleMonthly : s.budgetCycleStartDay(day),
            selected: day == widget.current,
            onTap: () => widget.onSelected(day),
          );
        },
      ),
    );
  }
}
