import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/settings/widgets/widgets.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _conCurrentPassword = TextEditingController();
  final _conNewPassword = TextEditingController();
  final _conConfirmPassword = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final _fnCurrentPassword = FocusNode();
  final _fnNewPassword = FocusNode();
  final _fnConfirmPassword = FocusNode();

  bool _isCurrentPasswordValid = false;
  bool _isNewPasswordValid = false;
  bool _isConfirmPasswordValid = false;

  bool get _isFormValid =>
      _isCurrentPasswordValid && _isNewPasswordValid && _isConfirmPasswordValid;

  void _onSave() {
    if (!_isFormValid) return;
    showDialog(
      context: context,
      builder: (_) => ConfirmChangePasswordDialog(
        onConfirm: () {
          Strings.of(context)!.featureNotAvailableYet.toToastError(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    _conCurrentPassword.dispose();
    _conNewPassword.dispose();
    _conConfirmPassword.dispose();
    _fnCurrentPassword.dispose();
    _fnNewPassword.dispose();
    _fnConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Parent(
    appBar: MyAppBar(
      title: Strings.of(context)!.changePassword,
      onBack: () => context.pop(),
    ),
    bottomNavigation: Padding(
      padding: EdgeInsets.all(Dimens.space24),
      child: Button(
        width: double.maxFinite,
        title: Strings.of(context)!.updatePassword,
        onPressed: _isFormValid ? _onSave : null,
      ),
    ),
    child: SingleChildScrollView(
      padding: EdgeInsets.all(Dimens.space24),
      child: Container(
        padding: EdgeInsets.all(Dimens.space12),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 2,
            ),
          ],
          color: Theme.of(context).brightness == Brightness.dark
              ? Palette.primary.withValues(alpha: 0.1)
              : Palette.background,
          borderRadius: BorderRadius.circular(Dimens.space16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Password
            Text(
              Strings.of(context)!.currentPassword,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Palette.subText),
            ),
            SpacerV(value: Dimens.space8),
            TextF(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Palette.backgroundDark
                  : Palette.form,
              autoFillHints: const [AutofillHints.password],
              key: const Key('currentPassword'),
              focusNode: _fnCurrentPassword,
              textInputAction: TextInputAction.next,
              controller: _conCurrentPassword,
              keyboardType: TextInputType.text,
              obscureText: !_isCurrentPasswordVisible,
              hint: Strings.of(context)!.currentPassword,
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => setState(
                  () => _isCurrentPasswordVisible = !_isCurrentPasswordVisible,
                ),
                icon: Icon(
                  _isCurrentPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
              isValid: _isCurrentPasswordValid,
              validatorListener: (String value) {
                if (!mounted) return;
                setState(() => _isCurrentPasswordValid = value.length > 5);
              },
              errorMessage: Strings.of(context)!.errorPasswordLength,
            ),
            SizedBox(height: Dimens.space12),

            // New Password
            Text(
              Strings.of(context)!.newPassword,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Palette.subText),
            ),
            SpacerV(value: Dimens.space8),
            TextF(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Palette.backgroundDark
                  : Palette.form,
              autoFillHints: const [AutofillHints.newPassword],
              key: const Key('newPassword'),
              focusNode: _fnNewPassword,
              textInputAction: TextInputAction.next,
              controller: _conNewPassword,
              keyboardType: TextInputType.text,
              obscureText: !_isNewPasswordVisible,
              hint: Strings.of(context)!.newPassword,
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => setState(
                  () => _isNewPasswordVisible = !_isNewPasswordVisible,
                ),
                icon: Icon(
                  _isNewPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
              isValid: _isNewPasswordValid,
              validatorListener: (String value) {
                if (!mounted) return;
                setState(() {
                  _isNewPasswordValid = value.length > 5;
                  // Re-validasi confirm password jika sudah diisi
                  _isConfirmPasswordValid =
                      _conConfirmPassword.text == value &&
                      _conConfirmPassword.text.isNotEmpty;
                });
              },
              errorMessage: Strings.of(context)!.errorPasswordLength,
            ),
            SizedBox(height: Dimens.space12),

            // Confirm New Password
            Text(
              Strings.of(context)!.reTypeNewPassword,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Palette.subText),
            ),
            SpacerV(value: Dimens.space8),
            TextF(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Palette.backgroundDark
                  : Palette.form,
              autoFillHints: const [AutofillHints.newPassword],
              key: const Key('confirmPassword'),
              focusNode: _fnConfirmPassword,
              textInputAction: TextInputAction.done,
              controller: _conConfirmPassword,
              keyboardType: TextInputType.text,
              obscureText: !_isConfirmPasswordVisible,
              hint: Strings.of(context)!.reTypeNewPassword,
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => setState(
                  () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
                ),
                icon: Icon(
                  _isConfirmPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
              isValid: _isConfirmPasswordValid,
              validatorListener: (String value) {
                if (!mounted) return;
                setState(
                  () => _isConfirmPasswordValid =
                      value == _conNewPassword.text && value.isNotEmpty,
                );
              },
              errorMessage: Strings.of(context)!.errorPasswordNotMatch,
            ),
          ],
        ),
      ),
    ),
  );
}
