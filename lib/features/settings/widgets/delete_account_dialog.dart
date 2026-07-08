import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';

class DeleteAccountDialog extends StatefulWidget {
  final VoidCallback onConfirm;

  const DeleteAccountDialog({required this.onConfirm, super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _conPassword = TextEditingController();
  final _fnPassword = FocusNode();

  bool _isPasswordVisible = false;
  bool _isPasswordValid = false;

  @override
  void dispose() {
    _conPassword.dispose();
    _fnPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: EdgeInsets.symmetric(horizontal: Dimens.space24),
    child: Container(
      padding: EdgeInsets.all(Dimens.space24),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Palette.formDark
            : Palette.card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Title
          Text(
            Strings.of(context)!.deleteAccount,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Palette.red,
              fontWeight: FontWeight.bold,
            ),
          ),

          SpacerV(value: Dimens.space12),

          /// Description
          Text(
            Strings.of(context)!.thisActionIsPermanent,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Palette.card
                  : Palette.cardDark,
              fontWeight: FontWeight.w500,
            ),
          ),

          SpacerV(value: Dimens.space24),

          /// Password Field
          TextF(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Palette.backgroundDark
                : Palette.form,
            key: const Key('deletePassword'),
            focusNode: _fnPassword,
            controller: _conPassword,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            obscureText: !_isPasswordVisible,
            hint: Strings.of(context)!.password,
            isValid: _isPasswordValid,
            noErrorSpace: true,
            suffixIcon: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            validatorListener: (String value) {
              if (!mounted) return;
              setState(() => _isPasswordValid = value.length > 5);
            },
            errorMessage: Strings.of(context)!.errorPasswordLength,
          ),

          SpacerV(value: Dimens.space24),

          /// Buttons
          Row(
            children: [
              /// Cancel
              Expanded(
                child: Button(
                  title: Strings.of(context)!.cancel,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Palette.background
                      : Palette.button,
                  titleColor: Theme.of(context).brightness == Brightness.dark
                      ? Palette.primary
                      : Palette.text,
                  onPressed: () => context.pop(),
                ),
              ),

              SpacerH(value: Dimens.space12),

              /// Delete
              Expanded(
                child: Button(
                  title: Strings.of(context)!.yesDelete,
                  color: _isPasswordValid
                      ? Palette.red
                      : Palette.red.withValues(alpha: 0.4),
                  titleColor: Colors.white,
                  onPressed: _isPasswordValid
                      ? () {
                          context.pop();
                          widget.onConfirm();
                        }
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
