import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/security/pages/pin/pin_entry_cubit.dart';
import 'package:jaga_saku/features/security/pages/widgets/pin_pad.dart';

/// Route args for the PIN-entry flow (`AppRoute.pinEntry`).
class PinEntryArgs {
  const PinEntryArgs({required this.purpose, required this.title});

  final PinEntryPurpose purpose;
  final String title;
}

/// The create / change / disable PIN screen (V3-M4). Step titles switch with the
/// cubit state; `done` toasts the purpose-specific success and pops `true` so the
/// Security page reloads. Mismatch / wrong current PIN toast (+ haptic).
class PinEntryPage extends StatelessWidget {
  const PinEntryPage({required this.purpose, required this.title, super.key});

  final PinEntryPurpose purpose;
  final String title;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final cubit = context.read<PinEntryCubit>();
    final theme = Theme.of(context);
    return AppScaffold(
      appBar: AppBar(title: Text(title)),
      body: BlocConsumer<PinEntryCubit, PinEntryState>(
        listener: (context, state) {
          switch (state) {
            case PinEntryDone():
              _doneMessage(s).toToastSuccess(context);
              context.pop(true);
            case PinEntryMismatch():
              HapticFeedback.mediumImpact();
              s.securityPinMismatch.toToastError(context);
            case PinEntryWrong():
              HapticFeedback.mediumImpact();
              s.securityWrongPin.toToastError(context);
            case PinEntryVerifyCurrent():
            case PinEntryEnterNew():
            case PinEntryConfirm():
            case PinEntrySubmitting():
              break;
          }
        },
        builder: (context, state) {
          final entered = switch (state) {
            PinEntryVerifyCurrent(:final enteredCount) => enteredCount,
            PinEntryEnterNew(:final enteredCount) => enteredCount,
            PinEntryConfirm(:final enteredCount) => enteredCount,
            PinEntrySubmitting() => 6,
            _ => 0,
          };
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_stepTitle(s, state), style: theme.textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.xxl),
                  PinPad(
                    enteredCount: entered,
                    disabled: state is PinEntrySubmitting,
                    onDigit: cubit.addDigit,
                    onBackspace: cubit.backspace,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _stepTitle(Strings s, PinEntryState state) => switch (state) {
    PinEntryVerifyCurrent() => s.securityEnterCurrentPin,
    PinEntryEnterNew() => s.securityEnterNewPin,
    PinEntryConfirm() => s.securityConfirmPin,
    _ => s.securityEnterPin,
  };

  String _doneMessage(Strings s) => switch (purpose) {
    PinEntryPurpose.create => s.securityPinCreated,
    PinEntryPurpose.change => s.securityPinChanged,
    PinEntryPurpose.disable => s.securityPinDisabled,
  };
}
