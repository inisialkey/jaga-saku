import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Shared PIN-entry surface (V3-M4): a row of dot indicators over a 3×4 numeric
/// keypad. Stateless — the parent owns the entered buffer; this only renders
/// [enteredCount] filled dots and reports taps. Styling mirrors
/// `calculator_keypad_sheet.dart` (soft-surface rounded keys, design tokens
/// only). The bottom-left key is a biometric shortcut when [onBiometric] is set,
/// otherwise blank.
class PinPad extends StatelessWidget {
  const PinPad({
    required this.enteredCount,
    required this.onDigit,
    required this.onBackspace,
    super.key,
    this.onBiometric,
    this.disabled = false,
    this.length = 6,
  });

  final int enteredCount;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  /// When non-null, the bottom-left key becomes a biometric shortcut.
  final VoidCallback? onBiometric;
  final bool disabled;
  final int length;

  static const double _cell = 72;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      _dots(context),
      const SizedBox(height: AppSpacing.xxl),
      for (final row in const [
        ['1', '2', '3'],
        ['4', '5', '6'],
        ['7', '8', '9'],
      ])
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [for (final digit in row) _digitKey(context, digit)],
        ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _biometricKey(context),
          _digitKey(context, '0'),
          _backspaceKey(context),
        ],
      ),
    ],
  );

  Widget _dots(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (var i = 0; i < length; i++)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < enteredCount ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: i < enteredCount
                  ? AppColors.primary
                  : context.colors.border,
              width: 1.5,
            ),
          ),
        ),
    ],
  );

  Widget _digitKey(BuildContext context, String digit) => _key(
    context,
    keyId: 'pinKey_$digit',
    onTap: disabled ? null : () => onDigit(digit),
    child: Text(
      digit,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
    ),
  );

  Widget _backspaceKey(BuildContext context) => _key(
    context,
    keyId: 'pinKey_backspace',
    onTap: (disabled || enteredCount == 0) ? null : onBackspace,
    background: Colors.transparent,
    child: Icon(
      Icons.backspace_outlined,
      color: context.colors.textSecondary,
      size: 24,
    ),
  );

  Widget _biometricKey(BuildContext context) {
    if (onBiometric == null) {
      return const SizedBox(width: _cell, height: _cell);
    }
    return _key(
      context,
      keyId: 'pinKey_biometric',
      onTap: disabled ? null : onBiometric,
      background: Colors.transparent,
      child: const Icon(Icons.fingerprint, color: AppColors.primary, size: 30),
    );
  }

  Widget _key(
    BuildContext context, {
    required String keyId,
    required VoidCallback? onTap,
    required Widget child,
    Color? background,
  }) => Padding(
    padding: const EdgeInsets.all(AppSpacing.sm),
    child: Material(
      color: background ?? context.colors.surfaceSoft,
      shape: const CircleBorder(),
      child: InkWell(
        key: ValueKey(keyId),
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: _cell,
          height: _cell,
          child: Center(child: child),
        ),
      ),
    ),
  );
}
