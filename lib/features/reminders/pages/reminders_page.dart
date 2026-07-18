import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/reminders/pages/reminder_cubit.dart';

/// Reminders settings (Settings → Reminders, V3-M5): toggle the daily check-in
/// (+ pick its time), the recurring-due nudge and budget warnings. The first
/// enable of any toggle triggers the OS permission prompt; a denial keeps the
/// switch off and surfaces a hint (oktoast, never SnackBar). Reads/writes the
/// per-route [ReminderCubit].
class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final cubit = context.read<ReminderCubit>();
    return AppScaffold(
      appBar: AppBar(title: Text(s.reminders)),
      body: BlocListener<ReminderCubit, ReminderState>(
        // Fire only on the false → true transition so the hint shows once.
        listenWhen: (a, b) => !a.permissionDenied && b.permissionDenied,
        listener: (context, state) =>
            s.reminderPermissionRequired.toToastError(context),
        child: BlocBuilder<ReminderCubit, ReminderState>(
          builder: (context, state) => ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            children: [
              HairlineCard(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(s.reminderDaily),
                    value: state.dailyEnabled,
                    onChanged: (enabled) => cubit.toggleDaily(enabled: enabled),
                  ),
                  // Time row only makes sense while the daily nudge is on.
                  if (state.dailyEnabled)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(s.reminderDailyTime),
                      subtitle: Text(
                        _formatTime(state.dailyHour, state.dailyMinute),
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: context.colors.textTertiary,
                      ),
                      onTap: () => _pickTime(context, cubit, state),
                    ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(s.reminderRecurringDue),
                    value: state.recurringDueEnabled,
                    onChanged: (enabled) =>
                        cubit.toggleRecurring(enabled: enabled),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(s.reminderBudgetWarning),
                    value: state.budgetWarningEnabled,
                    onChanged: (enabled) =>
                        cubit.toggleBudget(enabled: enabled),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    ReminderCubit cubit,
    ReminderState state,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: state.dailyHour, minute: state.dailyMinute),
    );
    if (picked == null || !context.mounted) return;
    await cubit.setDailyTime(picked.hour, picked.minute);
  }

  String _formatTime(int hour, int minute) =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
