import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jaga_saku/app_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/pages/list/recurring_list_cubit.dart';
import 'package:jaga_saku/features/recurring/pages/widgets/recurring_tile.dart';

/// Recurring manage screen (`/recurring`): a non-reorderable list of
/// [RecurringTile]s (ordered by `next_due`) with add / edit / delete. Deleting a
/// rule cascade-drops its owned template. The cubit is provided at the route.
class RecurringListPage extends StatelessWidget {
  const RecurringListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocBuilder<RecurringListCubit, RecurringListState>(
      builder: (context, state) => AppScaffold(
        appBar: AppBar(
          title: Text(s.recurring),
          actions: [
            IconButton(
              tooltip: s.recurringAdd,
              icon: const Icon(Iconsax.add),
              onPressed: () => _openRecurringForm(context),
            ),
          ],
        ),
        body: switch (state) {
          RecurringListInitial() ||
          RecurringListLoading() => const ListSkeleton(),
          RecurringListError(:final failure) => ErrorStateView(
            title: s.errorLoadTitle,
            message: failure.localize(context),
            retryLabel: s.retry,
            onRetry: () => context.read<RecurringListCubit>().load(),
          ),
          RecurringListLoaded(:final rules) => _RecurringListBody(rules: rules),
        },
      ),
    );
  }
}

class _RecurringListBody extends StatelessWidget {
  const _RecurringListBody({required this.rules});

  final List<RecurringRule> rules;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    if (rules.isEmpty) {
      return EmptyStateView(
        icon: Iconsax.repeat,
        title: s.recurringEmpty,
        message: s.recurringEmptyMessage,
        actionLabel: s.recurringAdd,
        onAction: () => _openRecurringForm(context),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      itemCount: rules.length,
      itemBuilder: (context, index) {
        final rule = rules[index];
        return RecurringTile(
          key: ValueKey(rule.id),
          rule: rule,
          onTap: () => _openRecurringForm(context, rule: rule),
          onLongPress: () => _showRecurringActions(context, rule),
        );
      },
    );
  }
}

/// Pushes the recurring form (create when [rule] is null) and reloads the list
/// when it pops with a success result.
Future<void> _openRecurringForm(
  BuildContext context, {
  RecurringRule? rule,
}) async {
  final cubit = context.read<RecurringListCubit>();
  final saved = await context.push<bool>(AppRoute.recurringForm, extra: rule);
  if (saved ?? false) await cubit.load();
}

enum _RecurringAction { edit, delete }

/// Long-press actions: edit / delete (delete goes through a confirm sheet).
Future<void> _showRecurringActions(
  BuildContext context,
  RecurringRule rule,
) async {
  final cubit = context.read<RecurringListCubit>();
  final s = Strings.of(context)!;
  final action = await showModalBottomSheet<_RecurringAction>(
    context: context,
    builder: (sheetContext) => AppBottomSheet(
      title: rule.template?.label ?? s.recurring,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Iconsax.edit),
            title: Text(s.edit),
            onTap: () => Navigator.of(sheetContext).pop(_RecurringAction.edit),
          ),
          ListTile(
            leading: Icon(Iconsax.trash, color: context.colors.critical),
            title: Text(
              s.delete,
              style: TextStyle(color: context.colors.critical),
            ),
            onTap: () =>
                Navigator.of(sheetContext).pop(_RecurringAction.delete),
          ),
        ],
      ),
    ),
  );
  if (action == null || !context.mounted) return;

  switch (action) {
    case _RecurringAction.edit:
      await _openRecurringForm(context, rule: rule);
    case _RecurringAction.delete:
      final confirmed = await ConfirmSheet.show(
        context,
        title: s.delete,
        message: s.recurringDeleteConfirm,
        confirmLabel: s.delete,
        cancelLabel: s.cancel,
        destructive: true,
      );
      if (!confirmed) return;
      await cubit.delete(rule);
  }
}
