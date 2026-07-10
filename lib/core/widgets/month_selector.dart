import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Indonesian month names indexed 1..12. Hand-rolled (like `formatRupiah`) so
/// the selector never depends on intl locale data being initialized — the app
/// shows Indonesian month names everywhere regardless of the UI locale.
const List<String> _idMonths = [
  '',
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

/// A `‹ Month YYYY ›` selector (wireframe Budget + Insight screens): prev / next
/// chevrons around the current month label. Dumb widget — the cubit owns the
/// month and reloads on [onPrevious] / [onNext]. Shared by Budget and Insight
/// (promoted from `budgets/` to `core/widgets` in M5).
class MonthSelector extends StatelessWidget {
  const MonthSelector({
    required this.month,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        tooltip: Strings.of(context)!.selectMonth,
        icon: const Icon(Icons.chevron_left_rounded),
        onPressed: onPrevious,
      ),
      Text(
        '${_idMonths[month.month]} ${month.year}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      IconButton(
        tooltip: Strings.of(context)!.selectMonth,
        icon: const Icon(Icons.chevron_right_rounded),
        onPressed: onNext,
      ),
    ],
  );
}
