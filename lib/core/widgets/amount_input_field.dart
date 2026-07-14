import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Large amount entry (style guide §13.11): 72h, 28 bold, `Rp` prefix. Tapping
/// the field opens the in-app [CalculatorKeypadSheet] instead of the system
/// keyboard; the sheet returns the evaluated integer rupiah.
///
/// The caller owns the [controller] and receives the value as a decimal string
/// via [onChanged] (parse with `int.tryParse`) — the pre-keypad public API, so
/// the four amount call sites need no change.
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

  Future<void> _openKeypad(BuildContext context) async {
    final result = await CalculatorKeypadSheet.show(
      context,
      initial: controller.text,
    );
    if (!context.mounted) return;
    if (result == null) return; // dismissed — leave the amount unchanged
    final display = result == 0 ? '' : '$result';
    controller.text = display;
    onChanged?.call(display);
  }

  @override
  Widget build(BuildContext context) {
    final amountStyle = Theme.of(context).textTheme.displayMedium;
    final s = Strings.of(context);
    final display = controller.text.isEmpty ? hint : controller.text;
    // Announce as a button (opens the keypad), not an editable field, and read
    // the current amount in the label since the inner field is excluded.
    return Semantics(
      button: true,
      label: s == null ? 'Rp $display' : '${s.amount}, Rp $display',
      excludeSemantics: true,
      onTap: () => _openKeypad(context),
      child: GestureDetector(
        // Opaque so the whole 72px pill is tappable (the Rp prefix + the
        // horizontal padding were dead zones), not just the inner field.
        behavior: HitTestBehavior.opaque,
        onTap: () => _openKeypad(context),
        child: Container(
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
                style: amountStyle?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: controller,
                  autofocus: autofocus,
                  readOnly: true,
                  showCursor: true,
                  onTap: () => _openKeypad(context),
                  style: amountStyle,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: hint,
                    hintStyle: amountStyle?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
