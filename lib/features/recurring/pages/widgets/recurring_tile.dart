import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/recurring/domain/entities/recurring_rule.dart';

/// A single recurring-rule row on the manage list: a recurring glyph avatar +
/// the template label, its schedule summary + next-due date, and the amount.
/// Dumb widget — tap / long-press are wired by the list page. Uses a generic
/// [Iconsax.repeat] glyph (the manage cubit loads no category lookup; the label
/// carries identity).
class RecurringTile extends StatelessWidget {
  const RecurringTile({
    required this.rule,
    super.key,
    this.onTap,
    this.onLongPress,
  });

  final RecurringRule rule;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final theme = Theme.of(context);
    final template = rule.template;
    final amount = template?.amount;
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
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
                    template?.label ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${_scheduleSummary(s)} · ${s.recurringNextDue}: '
                    '${_formatDate(rule.nextDue)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            if (amount != null)
              MoneyText(amount: amount, style: theme.textTheme.bodyLarge)
            else
              Text(
                '—',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Freq label, prefixed with "Every N" when the interval > 1 (simple grammar,
  /// e.g. "Every 2 Monthly").
  String _scheduleSummary(Strings s) {
    final freq = switch (rule.freq) {
      RecurrenceFreq.daily => s.freqDaily,
      RecurrenceFreq.weekly => s.freqWeekly,
      RecurrenceFreq.monthly => s.freqMonthly,
      RecurrenceFreq.yearly => s.freqYearly,
    };
    return rule.interval > 1
        ? '${s.recurringEvery(rule.interval)} $freq'
        : freq;
  }
}

String _formatDate(int millis) => DateFormat(
  'd MMM yyyy',
  'id',
).format(DateTime.fromMillisecondsSinceEpoch(millis));
