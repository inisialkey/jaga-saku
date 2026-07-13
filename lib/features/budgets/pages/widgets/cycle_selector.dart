import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Short Indonesian month names indexed 1..12. Hand-rolled (like `MonthSelector`
/// / `formatRupiah`) so the selector never depends on intl locale data being
/// initialized — the app shows Indonesian month names everywhere regardless of
/// the UI locale.
const List<String> _idShortMonths = [
  '',
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// A `‹ 25 Jul – 24 Agu ›` budget-cycle stepper (V2-M1). The Budget-screen
/// counterpart of the FROZEN, shared `MonthSelector` (which backs Insight +
/// M7 MoneyStory in calendar months) — kept SEPARATE so those screens carry
/// zero regression risk. Dumb widget: the cubit owns the cycle and reloads on
/// [onPrevious] / [onNext].
///
/// [start] / [end] are the half-open cycle window (local-midnight millis); the
/// label shows the INCLUSIVE end (`end − 1 day`), so `[25 Jul, 25 Aug)` reads
/// "25 Jul – 24 Agu".
class CycleSelector extends StatelessWidget {
  const CycleSelector({
    required this.start,
    required this.end,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  final int start;
  final int end;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  String _fmt(DateTime d) => '${d.day} ${_idShortMonths[d.month]}';

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    final startDate = DateTime.fromMillisecondsSinceEpoch(start);
    final endInclusive = DateTime.fromMillisecondsSinceEpoch(
      end,
    ).subtract(const Duration(days: 1));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: s.selectMonth,
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: onPrevious,
        ),
        Text(
          s.budgetCycleRange(_fmt(startDate), _fmt(endInclusive)),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          tooltip: s.selectMonth,
          icon: const Icon(Icons.chevron_right_rounded),
          onPressed: onNext,
        ),
      ],
    );
  }
}
