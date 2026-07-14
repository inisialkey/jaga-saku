import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';
import 'package:jaga_saku/features/recurring/pages/review/recurring_review_cubit.dart';

/// Recurring review screen (`/recurring/review`): the projected pending
/// occurrences, each confirmable (writes a real tx at its due date) or skippable
/// (advances the cursor only), with a "Confirm all" header action. The cubit is
/// provided at the route. Overflow (cap 60) is surfaced in the header.
class RecurringReviewPage extends StatelessWidget {
  const RecurringReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return BlocBuilder<RecurringReviewCubit, RecurringReviewState>(
      builder: (context, state) => AppScaffold(
        appBar: AppBar(title: Text(s.recurringReviewTitle)),
        body: switch (state) {
          RecurringReviewLoading() => const ListSkeleton(),
          RecurringReviewError(:final failure) => ErrorStateView(
            title: s.errorLoadTitle,
            message: failure.localize(context),
            retryLabel: s.retry,
            onRetry: () => context.read<RecurringReviewCubit>().load(),
          ),
          RecurringReviewEmpty() => EmptyStateView(
            icon: Iconsax.tick_circle,
            title: s.recurringReviewEmpty,
          ),
          RecurringReviewLoaded(:final pending, :final busy) => _ReviewBody(
            pending: pending,
            busy: busy,
          ),
        },
      ),
    );
  }
}

class _ReviewBody extends StatelessWidget {
  const _ReviewBody({required this.pending, required this.busy});

  final List<PendingOccurrence> pending;
  final bool busy;

  /// Confirms every pending occurrence — but only behind a confirm-sheet gate
  /// (D3): this can write up to 60 real transactions, so it must never be a
  /// single-tap commit.
  Future<void> _confirmAll(BuildContext context) async {
    final s = Strings.of(context)!;
    final ok = await ConfirmSheet.show(
      context,
      title: s.recurringConfirmAllTitle,
      message: s.recurringConfirmAllMessage(pending.length),
      confirmLabel: s.recurringConfirmAll,
      cancelLabel: s.cancel,
    );
    if (ok && context.mounted) {
      context.read<RecurringReviewCubit>().confirmAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        if (pending.length >= 60) ...[
          Text(
            s.recurringOverflow(60),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        PrimaryButton(
          label: s.recurringConfirmAll,
          isLoading: busy,
          onPressed: busy ? null : () => _confirmAll(context),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final occurrence in pending)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _OccurrenceCard(occurrence: occurrence, busy: busy),
          ),
      ],
    );
  }
}

class _OccurrenceCard extends StatelessWidget {
  const _OccurrenceCard({required this.occurrence, required this.busy});

  final PendingOccurrence occurrence;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final theme = Theme.of(context);
    final template = occurrence.template;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CategoryIconAvatar.glyph(
                icon: Iconsax.repeat,
                color: context.colors.info,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _formatDate(occurrence.dueDate),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              MoneyText(
                amount: template.amount ?? 0,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: s.recurringSkip,
                  isLoading: busy,
                  onPressed: busy
                      ? null
                      : () => context.read<RecurringReviewCubit>().skip(
                          occurrence,
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PrimaryButton(
                  label: s.recurringConfirm,
                  isLoading: busy,
                  onPressed: busy
                      ? null
                      : () => context.read<RecurringReviewCubit>().confirm(
                          occurrence,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _formatDate(int millis) => DateFormat(
  'd MMM yyyy',
  'id',
).format(DateTime.fromMillisecondsSinceEpoch(millis));
