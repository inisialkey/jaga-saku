// Flutter's material.dart also exports a `LockState` (keyboard shortcuts); hide
// it so the name resolves to our lock-screen state union.
import 'package:flutter/material.dart' hide LockState;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/security/pages/lock/lock_cubit.dart';
import 'package:jaga_saku/features/security/pages/widgets/pin_pad.dart';

/// The full-screen lock gate (V3-M4, `AppRoute.lock`). Back is blocked
/// ([PopScope] `canPop: false`) so the gate cannot be dismissed; unlock happens
/// only via a correct PIN or biometric. A wrong PIN triggers a haptic + toast
/// (via the [BlocListener]); a cooldown shows a live countdown and disables the
/// pad.
class LockScreen extends StatelessWidget {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final cubit = context.read<LockCubit>();
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: AppScaffold(
        body: BlocConsumer<LockCubit, LockState>(
          listenWhen: (_, curr) => curr is LockError,
          listener: (context, _) {
            HapticFeedback.mediumImpact();
            s.securityWrongPin.toToastError(context);
          },
          builder: (context, state) {
            final remaining = state is LockCooldown
                ? state.remainingSeconds
                : null;
            final entered = switch (state) {
              LockInput(:final enteredCount) => enteredCount,
              LockVerifying() => 6,
              _ => 0,
            };
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Iconsax.shield_tick,
                      size: 48,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      s.securityLockedTitle,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      remaining != null
                          ? s.securityTryAgainIn(remaining)
                          : s.securityEnterPin,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    PinPad(
                      enteredCount: entered,
                      disabled: remaining != null || state is LockVerifying,
                      onDigit: cubit.addDigit,
                      onBackspace: cubit.backspace,
                      onBiometric: cubit.isBiometricEnabled
                          ? cubit.authenticateWithBiometric
                          : null,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
