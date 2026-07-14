import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// How a money value is signed + colored (style guide §7, §13.8).
enum MoneySign {
  /// `+Rp …` in green.
  income,

  /// `-Rp …` in red.
  expense,

  /// `Rp …` in blue.
  transfer,

  /// `Rp …` in the default text color.
  neutral,
}

/// Renders a rupiah amount with the sign + semantic color for its type.
class MoneyText extends StatelessWidget {
  const MoneyText({
    required this.amount,
    super.key,
    this.sign = MoneySign.neutral,
    this.style,
  });

  /// Positive integer rupiah (sign is derived from [sign]).
  final int amount;
  final MoneySign sign;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final prefix = switch (sign) {
      MoneySign.income => '+',
      MoneySign.expense => '-',
      MoneySign.transfer || MoneySign.neutral => '',
    };
    final color = switch (sign) {
      MoneySign.income => context.colors.income,
      MoneySign.expense => context.colors.expense,
      MoneySign.transfer => context.colors.transfer,
      MoneySign.neutral => null,
    };

    final base = style ?? Theme.of(context).textTheme.titleMedium;
    return Text(
      formatRupiah(amount, sign: prefix),
      style: base?.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
        // Ledger digits align in columns (equal-width figures).
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
