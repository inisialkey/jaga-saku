import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaga_saku/core/core.dart';

/// In-app calculator keypad (V2-M3) that replaces the system number keyboard for
/// [AmountInputField]. A live expression line + evaluated `Rp` result sit over a
/// 4×4 operator grid; "Done" pops the evaluated integer rupiah.
///
/// State is a widget-local [ValueNotifier] holding the raw ASCII expression
/// (digits + `+ - * /`); [CalcEngine] does all the maths and formatting.
class CalculatorKeypadSheet extends StatefulWidget {
  const CalculatorKeypadSheet({super.key, this.initial = ''});

  /// The caller's current amount text (a plain integer string, e.g. `'15500'`).
  /// Non-digits are stripped so the keypad reopens on the bare number.
  final String initial;

  /// Opens the keypad and resolves to the evaluated integer, or `null` when the
  /// sheet is dismissed (drag / barrier tap) without pressing "Done".
  static Future<int?> show(BuildContext context, {String initial = ''}) =>
      showModalBottomSheet<int>(
        context: context,
        isScrollControlled: true,
        builder: (_) => CalculatorKeypadSheet(initial: initial),
      );

  @override
  State<CalculatorKeypadSheet> createState() => _CalculatorKeypadSheetState();
}

class _CalculatorKeypadSheetState extends State<CalculatorKeypadSheet> {
  /// Longest operand run allowed — 18 digits stays inside a 64-bit int.
  static const int _maxDigits = 18;

  late final ValueNotifier<String> _expr = ValueNotifier<String>(
    widget.initial.replaceAll(RegExp('[^0-9]'), ''),
  );

  @override
  void dispose() {
    _expr.dispose();
    super.dispose();
  }

  bool _isOp(String ch) => ch == '+' || ch == '-' || ch == '*' || ch == '/';

  void _appendDigit(String digit) {
    final expr = _expr.value;
    final trailing = RegExp(r'[0-9]*$').firstMatch(expr)?.group(0) ?? '';
    if (trailing.length >= _maxDigits) return; // cap a single operand
    _expr.value = expr + digit;
  }

  void _appendOp(String op) {
    final expr = _expr.value;
    if (expr.isEmpty) {
      // Only a leading '-' is meaningful (re-editable negative); ignore others.
      if (op == '-') _expr.value = op;
      return;
    }
    final last = expr[expr.length - 1];
    _expr.value = _isOp(last)
        ? expr.substring(0, expr.length - 1) +
              op // replace trailing operator
        : expr + op;
  }

  void _clear() => _expr.value = '';

  void _backspace() {
    final expr = _expr.value;
    if (expr.isNotEmpty) _expr.value = expr.substring(0, expr.length - 1);
  }

  void _equals() => _expr.value = CalcEngine.evaluate(_expr.value).toString();

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (!mounted) return;
    final digits = data?.text?.replaceAll(RegExp('[^0-9]'), '') ?? '';
    if (digits.isEmpty) return;
    _expr.value = digits.length > _maxDigits
        ? digits.substring(0, _maxDigits)
        : digits;
  }

  void _done() => Navigator.of(context).pop(CalcEngine.evaluate(_expr.value));

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return AppBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<String>(
            valueListenable: _expr,
            builder: (context, expr, _) => _display(context, expr),
          ),
          const SizedBox(height: AppSpacing.lg),
          _row(context, [
            _digit(context, '7'),
            _digit(context, '8'),
            _digit(context, '9'),
            _op(context, keyId: 'calcKey_div', label: '÷', op: '/'),
          ]),
          _row(context, [
            _digit(context, '4'),
            _digit(context, '5'),
            _digit(context, '6'),
            _op(context, keyId: 'calcKey_mul', label: '×', op: '*'),
          ]),
          _row(context, [
            _digit(context, '1'),
            _digit(context, '2'),
            _digit(context, '3'),
            _op(context, keyId: 'calcKey_sub', label: '−', op: '-'),
          ]),
          _row(context, [
            _cell(
              context,
              keyId: 'calcKey_clear',
              label: s.calcClear,
              onTap: _clear,
              textColor: context.colors.expense,
            ),
            _digit(context, '0'),
            _cell(
              context,
              keyId: 'calcKey_backspace',
              label: '⌫',
              onTap: _backspace,
            ),
            _op(context, keyId: 'calcKey_add', label: '+', op: '+'),
          ]),
          _row(context, [
            _cell(
              context,
              keyId: 'calcKey_equals',
              label: '=',
              onTap: _equals,
              textColor: AppColors.primary,
            ),
            _cell(
              context,
              keyId: 'calcDone',
              label: s.calcDone,
              onTap: _done,
              color: AppColors.primary,
              textColor: AppColors.white,
              flex: 2,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _display(BuildContext context, String expr) {
    final theme = Theme.of(context);
    final result = CalcEngine.evaluate(expr);
    return GestureDetector(
      onLongPress: _paste,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            expr.isEmpty ? '0' : CalcEngine.format(expr),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.displayMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '= ${formatRupiah(result, sign: result < 0 ? '-' : '')}',
            textAlign: TextAlign.right,
            style: theme.textTheme.titleMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, List<Widget> cells) => Row(children: cells);

  Widget _digit(BuildContext context, String digit) => _cell(
    context,
    keyId: 'calcKey_$digit',
    label: digit,
    onTap: () => _appendDigit(digit),
  );

  Widget _op(
    BuildContext context, {
    required String keyId,
    required String label,
    required String op,
  }) => _cell(
    context,
    keyId: keyId,
    label: label,
    onTap: () => _appendOp(op),
    textColor: AppColors.primary,
  );

  Widget _cell(
    BuildContext context, {
    required String keyId,
    required String label,
    required VoidCallback onTap,
    Color? color,
    Color? textColor,
    int flex = 1,
  }) {
    final radius = BorderRadius.circular(AppRadius.lg);
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Semantics(
          button: true,
          label: label,
          child: Material(
            color: color ?? context.colors.surfaceSoft,
            borderRadius: radius,
            child: InkWell(
              key: ValueKey(keyId),
              onTap: onTap,
              borderRadius: radius,
              child: SizedBox(
                height: 56,
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
