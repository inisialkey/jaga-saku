import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/backup/pages/backup/cubit/backup_cubit.dart';

/// Backup & Restore screen (`/backup-restore`): export the whole database to a
/// shareable JSON file, or pick a backup and restore it via a
/// validate → preview → destructive-confirm → atomic full-replace flow. The
/// cubit is provided at the route. Feedback is via oktoast (repo convention);
/// a successful restore pops back.
class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  Future<void> _confirmRestore(BuildContext context) async {
    final s = Strings.of(context)!;
    final ok = await ConfirmSheet.show(
      context,
      title: s.backupRestoreConfirmTitle,
      message: '${s.backupRestoreConfirmBody}\n\n${s.backupRestoreWarning}',
      confirmLabel: s.backupRestoreData,
      cancelLabel: s.cancel,
      destructive: true,
    );
    if (ok && context.mounted) {
      context.read<BackupCubit>().restore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocConsumer<BackupCubit, BackupState>(
      listener: (context, state) {
        switch (state) {
          case BackupExportSuccess():
            s.backupExportSuccess.toToastSuccess(context);
          case BackupRestoreSuccess():
            s.backupRestoreSuccess.toToastSuccess(context);
            context.pop();
          case BackupFailureState(:final failure):
            failure.localize(context).toToastError(context);
          default:
            break;
        }
      },
      builder: (context, state) {
        final busy =
            state is BackupExporting ||
            state is BackupValidating ||
            state is BackupRestoring;
        return AppScaffold(
          appBar: AppBar(title: Text(s.backupRestore)),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            children: [
              SectionHeader(title: s.backupSectionBackup),
              _BackupCard(state: state, busy: busy),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(title: s.backupSectionRestore),
              _RestoreCard(
                state: state,
                busy: busy,
                onConfirmRestore: () => _confirmRestore(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BackupCard extends StatelessWidget {
  const _BackupCard({required this.state, required this.busy});

  final BackupState state;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            s.backupExportSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _LastExportLine(state: state),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: s.backupExport,
            isLoading: state is BackupExporting,
            onPressed: busy
                ? null
                : () => context.read<BackupCubit>().exportBackup(),
          ),
        ],
      ),
    );
  }
}

class _LastExportLine extends StatelessWidget {
  const _LastExportLine({required this.state});

  final BackupState state;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final style = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: context.colors.textSecondary);

    if (state case BackupIdle(
      :final lastExportedAt,
      :final lastItemCount,
    ) when lastExportedAt != null) {
      final date = DateFormat(
        'd MMM yyyy, HH:mm',
      ).format(DateTime.fromMillisecondsSinceEpoch(lastExportedAt));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.backupLastExport(date), style: style),
          if (lastItemCount != null)
            Text(s.backupItemCount(lastItemCount), style: style),
        ],
      );
    }
    return Text(s.backupNoBackupYet, style: style);
  }
}

class _RestoreCard extends StatelessWidget {
  const _RestoreCard({
    required this.state,
    required this.busy,
    required this.onConfirmRestore,
  });

  final BackupState state;
  final bool busy;
  final VoidCallback onConfirmRestore;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final preview = state is BackupPreviewReady
        ? (state as BackupPreviewReady).preview
        : null;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SecondaryButton(
            label: s.backupChooseFile,
            isLoading: state is BackupValidating,
            onPressed: busy
                ? null
                : () => context.read<BackupCubit>().pickAndValidate(),
          ),
          if (preview != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              s.backupPreviewTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            _CountRow(label: s.accounts, count: preview.accounts),
            _CountRow(label: s.transactions, count: preview.transactions),
            _CountRow(label: s.categories, count: preview.categories),
            _CountRow(label: s.budget, count: preview.budgets),
            _CountRow(label: s.favorites, count: preview.templates),
            _CountRow(label: s.recurring, count: preview.recurring),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: s.backupRestoreData,
              isLoading: state is BackupRestoring,
              onPressed: busy ? null : onConfirmRestore,
            ),
          ],
        ],
      ),
    );
  }
}

class _CountRow extends StatelessWidget {
  const _CountRow({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            '$count',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
