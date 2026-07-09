import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaga_saku/core/core.dart';

/// Large amount entry (style guide §13.11): 72h, 28 bold, `Rp` prefix,
/// digits-only. The caller owns the [controller].
class AmountInputField extends StatelessWidget {
  const AmountInputField({
    required this.controller,
    super.key,
    this.hint = '0',
    this.autofocus = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final amountStyle = Theme.of(context).textTheme.displayMedium;
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Text(
            'Rp',
            style: amountStyle?.copyWith(color: context.colors.textTertiary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autofocus,
              onChanged: onChanged,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: amountStyle,
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: hint,
                hintStyle: amountStyle?.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
