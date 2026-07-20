import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaga_saku/features/reminders/data/reminder_local_datasource.dart';
import 'package:jaga_saku/features/reminders/data/reminder_service.dart';

part 'reminder_state.dart';
part 'reminder_cubit.freezed.dart';

/// Drives the Reminders settings screen (V3-M5). Reads/writes the reminder
/// config through the datasource (local prefs — no Either/Failure, mirroring
/// `AppSettingsCubit`) and calls the [ReminderService] to (re)schedule or cancel
/// on every change. Built per-route via BlocProvider; every emit is guarded by
/// [isClosed] (rule 5).
class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit({
    required ReminderLocalDatasource reminderDatasource,
    required ReminderService reminderService,
  }) : _datasource = reminderDatasource,
       _service = reminderService,
       super(const ReminderState());

  final ReminderLocalDatasource _datasource;
  final ReminderService _service;

  /// Seeds the switches + daily time from the persisted config.
  Future<void> load() async {
    final config = await _datasource.readConfig();
    if (isClosed) return;
    emit(
      state.copyWith(
        dailyEnabled: config.dailyEnabled,
        dailyHour: config.dailyHour,
        dailyMinute: config.dailyMinute,
        recurringDueEnabled: config.recurringDueEnabled,
        budgetWarningEnabled: config.budgetWarningEnabled,
      ),
    );
  }

  Future<void> toggleDaily({required bool enabled}) async {
    if (!await _ensurePermission(enabled: enabled)) return;
    await _datasource.writeDaily(enabled: enabled);
    await _service.reconcile();
    if (isClosed) return;
    emit(state.copyWith(dailyEnabled: enabled, permissionDenied: false));
  }

  Future<void> toggleRecurring({required bool enabled}) async {
    if (!await _ensurePermission(enabled: enabled)) return;
    await _datasource.writeRecurring(enabled: enabled);
    await _service.reconcile();
    if (isClosed) return;
    emit(state.copyWith(recurringDueEnabled: enabled, permissionDenied: false));
  }

  Future<void> toggleBudget({required bool enabled}) async {
    if (!await _ensurePermission(enabled: enabled)) return;
    await _datasource.writeBudget(enabled: enabled);
    await _service.recomputeBudgetWarnings();
    if (isClosed) return;
    emit(
      state.copyWith(budgetWarningEnabled: enabled, permissionDenied: false),
    );
  }

  /// Persists the new daily time and reschedules; the switch stays as-is.
  Future<void> setDailyTime(int hour, int minute) async {
    await _datasource.writeDailyTime(hour, minute);
    await _service.reconcile();
    if (isClosed) return;
    emit(state.copyWith(dailyHour: hour, dailyMinute: minute));
  }

  /// On a toggle-ON, requests the OS permission first; a denial flags the state
  /// (the page reverts the switch + shows the hint) and blocks the write.
  /// Toggle-OFF never needs permission. Returns whether the caller may proceed.
  Future<bool> _ensurePermission({required bool enabled}) async {
    if (!enabled) return true;
    final granted = await _service.requestPermission();
    if (granted) return true;
    if (isClosed) return false;
    emit(state.copyWith(permissionDenied: true));
    return false;
  }
}
