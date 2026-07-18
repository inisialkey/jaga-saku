import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/security/domain/entities/auto_lock_duration.dart';
import 'package:jaga_saku/features/security/pages/pin/pin_entry_cubit.dart';
import 'package:jaga_saku/features/security/pages/pin/pin_entry_page.dart';
import 'package:jaga_saku/features/security/pages/security/security_cubit.dart';
import 'package:jaga_saku/features/settings/pages/widgets/setting_option_tile.dart';

/// Security settings (More → Security, V3-M4): enable/disable the PIN lock,
/// biometric unlock (shown only when a PIN is set AND the device supports it),
/// auto-lock timing, and Change PIN. Enable/disable/change PIN push the shared
/// PIN-entry flow; the cubit reloads on return.
class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final cubit = context.read<SecurityCubit>();
    return AppScaffold(
      appBar: AppBar(title: Text(s.security)),
      body: BlocBuilder<SecurityCubit, SecurityState>(
        builder: (context, state) {
          final config = state.config;
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            children: [
              Text(
                s.securitySubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              HairlineCard(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(s.securityEnablePin),
                    value: config.isPinEnabled,
                    onChanged: state.busy
                        ? null
                        : (enable) =>
                              _togglePin(context, cubit, enable: enable),
                  ),
                  if (config.isPinEnabled && state.biometricAvailable)
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(s.securityEnableBiometric),
                      value: config.isBiometricEnabled,
                      onChanged: state.busy
                          ? null
                          : (enable) => _toggleBiometric(
                              context,
                              cubit,
                              s,
                              enable: enable,
                            ),
                    ),
                  if (config.isPinEnabled)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(s.securityAutoLock),
                      subtitle: Text(
                        _autoLockLabel(s, config.autoLockDuration),
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: context.colors.textTertiary,
                      ),
                      onTap: () => _showAutoLockPicker(
                        context,
                        cubit,
                        s,
                        config.autoLockDuration,
                      ),
                    ),
                  if (config.isPinEnabled)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(s.securityChangePin),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: context.colors.textTertiary,
                      ),
                      onTap: () => _openPinEntry(
                        context,
                        cubit,
                        s,
                        PinEntryPurpose.change,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _togglePin(
    BuildContext context,
    SecurityCubit cubit, {
    required bool enable,
  }) => _openPinEntry(
    context,
    cubit,
    Strings.of(context)!,
    enable ? PinEntryPurpose.create : PinEntryPurpose.disable,
  );

  Future<void> _openPinEntry(
    BuildContext context,
    SecurityCubit cubit,
    Strings s,
    PinEntryPurpose purpose,
  ) async {
    await context.push<bool>(
      AppRoute.pinEntry,
      extra: PinEntryArgs(purpose: purpose, title: _pinEntryTitle(s, purpose)),
    );
    if (!context.mounted) return;
    await cubit.refresh();
  }

  Future<void> _toggleBiometric(
    BuildContext context,
    SecurityCubit cubit,
    Strings s, {
    required bool enable,
  }) async {
    final result = await cubit.toggleBiometric(
      enabled: enable,
      reason: s.securityUseBiometric,
    );
    if (!context.mounted) return;
    switch (result) {
      case BiometricToggleResult.enabled:
        s.securityBiometricEnabled.toToastSuccess(context);
      case BiometricToggleResult.cancelled:
        s.securityBiometricNotConfirmed.toToastError(context);
      case BiometricToggleResult.failure:
        s.securityBiometricUnavailable.toToastError(context);
      case BiometricToggleResult.disabled:
        break;
    }
  }

  Future<void> _showAutoLockPicker(
    BuildContext context,
    SecurityCubit cubit,
    Strings s,
    AutoLockDuration current,
  ) => showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => AppBottomSheet(
      title: s.securityAutoLock,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in AutoLockDuration.values)
            SettingOptionTile(
              label: _autoLockLabel(s, option),
              selected: option == current,
              onTap: () {
                cubit.setAutoLockDuration(option);
                Navigator.of(sheetContext).pop();
              },
            ),
        ],
      ),
    ),
  );

  String _pinEntryTitle(Strings s, PinEntryPurpose purpose) =>
      switch (purpose) {
        PinEntryPurpose.create => s.securityEnablePin,
        PinEntryPurpose.change => s.securityChangePin,
        PinEntryPurpose.disable => s.securityEnablePin,
      };

  String _autoLockLabel(Strings s, AutoLockDuration duration) =>
      switch (duration) {
        AutoLockDuration.immediately => s.autoLockImmediately,
        AutoLockDuration.oneMinute => s.autoLockOneMinute,
        AutoLockDuration.fiveMinutes => s.autoLockFiveMinutes,
        AutoLockDuration.fifteenMinutes => s.autoLockFifteenMinutes,
      };
}
