import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/core/usecase/usecase.dart';
import 'package:jaga_saku/features/security/app_lock_service.dart';
import 'package:jaga_saku/features/security/domain/entities/pin_check.dart';
import 'package:jaga_saku/features/security/domain/usecases/change_pin.dart';
import 'package:jaga_saku/features/security/domain/usecases/disable_pin.dart';
import 'package:jaga_saku/features/security/domain/usecases/set_pin.dart';
import 'package:jaga_saku/features/security/domain/usecases/verify_pin.dart';

part 'pin_entry_cubit.freezed.dart';
part 'pin_entry_state.dart';

/// What the PIN-entry flow is for. Drives the initial step + the terminal write.
enum PinEntryPurpose { create, change, disable }

enum _Step { verifyCurrent, enterNew, confirm }

/// The create / change / disable state machine (V3-M4). A confirm mismatch never
/// persists (restarts at enterNew); a wrong current PIN inherits the datasource
/// backoff. Every emit after an `await` is guarded by [isClosed].
class PinEntryCubit extends Cubit<PinEntryState> {
  PinEntryCubit({
    required PinEntryPurpose purpose,
    required SetPin setPin,
    required ChangePin changePin,
    required DisablePin disablePin,
    required VerifyPin verifyPin,
    required AppLockService appLock,
  }) : _purpose = purpose,
       _setPin = setPin,
       _changePin = changePin,
       _disablePin = disablePin,
       _verifyPin = verifyPin,
       _appLock = appLock,
       _step = purpose == PinEntryPurpose.create
           ? _Step.enterNew
           : _Step.verifyCurrent,
       super(
         purpose == PinEntryPurpose.create
             ? const PinEntryState.enterNew()
             : const PinEntryState.verifyCurrent(),
       );

  final PinEntryPurpose _purpose;
  final SetPin _setPin;
  final ChangePin _changePin;
  final DisablePin _disablePin;
  final VerifyPin _verifyPin;
  final AppLockService _appLock;

  static const int _pinLength = 6;

  _Step _step;
  String _current = '';
  String _newPin = '';

  void addDigit(String digit) {
    if (state is PinEntrySubmitting) return;
    if (_current.length >= _pinLength) return;
    _current += digit;
    _emitStep();
    if (_current.length == _pinLength) unawaited(_advance());
  }

  void backspace() {
    if (state is PinEntrySubmitting) return;
    if (_current.isEmpty) return;
    _current = _current.substring(0, _current.length - 1);
    _emitStep();
  }

  void _emitStep() => emit(switch (_step) {
    _Step.verifyCurrent => PinEntryState.verifyCurrent(
      enteredCount: _current.length,
    ),
    _Step.enterNew => PinEntryState.enterNew(enteredCount: _current.length),
    _Step.confirm => PinEntryState.confirm(enteredCount: _current.length),
  });

  Future<void> _advance() async {
    switch (_step) {
      case _Step.verifyCurrent:
        await _verifyCurrent();
      case _Step.enterNew:
        _newPin = _current;
        _current = '';
        _step = _Step.confirm;
        emit(const PinEntryState.confirm());
      case _Step.confirm:
        if (_current == _newPin) {
          await _persistNew();
        } else {
          _resetTo(_Step.enterNew);
          emit(const PinEntryState.mismatch());
          _emitStep();
        }
    }
  }

  Future<void> _verifyCurrent() async {
    emit(const PinEntryState.submitting());
    final result = await _verifyPin(_current);
    if (isClosed) return;
    // A Left (storage glitch) is treated as a retryable wrong entry.
    final check = result.getOrElse(
      (_) => const PinCheck.wrong(failedAttempts: 0),
    );
    switch (check) {
      case PinCheckOk():
        await _afterVerifyCurrent();
      case PinCheckWrong(:final cooldownUntilMs):
        _wrongCurrent(cooldownUntilMs);
      case PinCheckLockedOut(:final cooldownUntilMs):
        _wrongCurrent(cooldownUntilMs);
    }
  }

  Future<void> _afterVerifyCurrent() async {
    if (_purpose == PinEntryPurpose.disable) {
      await _disable();
    } else {
      // change → capture the new PIN next.
      _resetTo(_Step.enterNew);
      _emitStep();
    }
  }

  void _wrongCurrent(int? cooldownUntilMs) {
    _resetTo(_Step.verifyCurrent);
    emit(PinEntryState.wrong(cooldownUntilMs: cooldownUntilMs));
    _emitStep();
  }

  Future<void> _persistNew() async {
    emit(const PinEntryState.submitting());
    final result = await (_purpose == PinEntryPurpose.create
        ? _setPin(_newPin)
        : _changePin(_newPin));
    await _appLock.refreshConfig();
    if (isClosed) return;
    result.match((_) {
      // Rare secure-storage write fault — restart the new-PIN step.
      _resetTo(_Step.enterNew);
      _emitStep();
    }, (_) => emit(const PinEntryState.done()));
  }

  Future<void> _disable() async {
    emit(const PinEntryState.submitting());
    final result = await _disablePin(NoParams());
    await _appLock.refreshConfig();
    if (isClosed) return;
    result.match((_) {
      _resetTo(_Step.verifyCurrent);
      _emitStep();
    }, (_) => emit(const PinEntryState.done()));
  }

  void _resetTo(_Step step) {
    _step = step;
    _current = '';
    if (step != _Step.confirm) _newPin = '';
  }
}
