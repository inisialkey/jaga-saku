import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/auth/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _conName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();
  final _conPasswordRepeat = TextEditingController();
  final _conPhone = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPasswordRepeatVisible = false;
  bool _isAgreed = false;

  final _fnName = FocusNode();
  final _fnEmail = FocusNode();
  final _fnPassword = FocusNode();
  final _fnPasswordRepeat = FocusNode();
  final _fnPhone = FocusNode();

  final _formValidator = <String, bool>{};

  @override
  void dispose() {
    _conName.dispose();
    _conEmail.dispose();
    _conPassword.dispose();
    _conPasswordRepeat.dispose();
    _conPhone.dispose();
    _fnName.dispose();
    _fnEmail.dispose();
    _fnPassword.dispose();
    _fnPasswordRepeat.dispose();
    _fnPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Parent(
    avoidBottomInset: false,
    appBar: const MyAppBar(),
    extendBodyBehindAppBar: true,
    child: BlocListener<AuthCubit, AuthState>(
      listener: (_, state) => switch (state) {
        AuthStateLoading() => context.show(),
        AuthStateSuccess() => (() {
          context.dismiss();
          TextInput.finishAutofillContext();
          context.goNamed(Routes.root.name);
        })(),
        AuthStateFailure(:final failure) => (() {
          context.dismiss();
          failure.localize(context).toToastError(context);
        })(),
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Theme.of(context).brightness == Brightness.dark
                      ? AppAssets.bgDark
                      : AppAssets.bgLight,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned.fill(
            bottom: 350.w,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.icLogo,
                    width: Dimens.logo,
                    height: Dimens.logo,
                    fit: BoxFit.cover,
                  ),
                  SpacerV(value: Dimens.space24),
                  Text(
                    Strings.of(context)!.registerTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SpacerV(value: Dimens.space12),
                  Text(
                    Strings.of(context)!.registerSubtitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimens.space24),
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(Dimens.cornerRadius),
                  topRight: Radius.circular(Dimens.cornerRadius),
                ),
                color: Theme.of(context).brightness == Brightness.dark
                    ? Palette.cardDark
                    : Palette.card,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SpacerV(),
                      Container(
                        width: 140.w,
                        height: Dimens.space6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.w),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Palette.handleBarDark
                              : Palette.handleBarLight,
                        ),
                      ),
                      SpacerV(value: 22.w),
                      TextF(
                        autoFillHints: const [AutofillHints.name],
                        key: const Key('name'),
                        focusNode: _fnName,
                        textInputAction: TextInputAction.next,
                        controller: _conName,
                        keyboardType: TextInputType.name,
                        hint: Strings.of(context)!.name,
                        isValid: _formValidator.putIfAbsent(
                          'name',
                          () => false,
                        ),
                        validatorListener: (String value) {
                          _formValidator['name'] = value.trim().isNotEmpty;
                          setState(() {});
                        },
                        errorMessage: Strings.of(context)!.errorEmptyField,
                      ),
                      SpacerV(value: Dimens.space12),
                      TextF(
                        autoFillHints: const [AutofillHints.email],
                        key: const Key('email'),
                        focusNode: _fnEmail,
                        textInputAction: TextInputAction.next,
                        controller: _conEmail,
                        keyboardType: TextInputType.emailAddress,
                        hint: Strings.of(context)!.loginEmailHint,
                        isValid: _formValidator.putIfAbsent(
                          'email',
                          () => false,
                        ),
                        validatorListener: (String value) {
                          _formValidator['email'] = value.isValidEmail();
                          setState(() {});
                        },
                        errorMessage: Strings.of(context)!.errorInvalidEmail,
                      ),
                      SpacerV(value: Dimens.space12),
                      TextF(
                        autoFillHints: const [AutofillHints.password],
                        key: const Key('password'),
                        focusNode: _fnPassword,
                        textInputAction: TextInputAction.done,
                        controller: _conPassword,
                        keyboardType: TextInputType.text,
                        obscureText: !_isPasswordVisible,
                        hint: Strings.of(context)!.password,
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            _isPasswordVisible = !_isPasswordVisible;
                            setState(() {});
                          },
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        isValid: _formValidator.putIfAbsent(
                          'password',
                          () => false,
                        ),
                        validatorListener: (String value) {
                          _formValidator['password'] = value.length > 5;
                          setState(() {});
                        },
                        errorMessage: Strings.of(context)!.errorPasswordLength,
                      ),
                      SpacerV(value: Dimens.space12),
                      TextF(
                        key: const Key('repeat_password'),
                        focusNode: _fnPasswordRepeat,
                        textInputAction: TextInputAction.done,
                        controller: _conPasswordRepeat,
                        keyboardType: TextInputType.text,
                        obscureText: !_isPasswordRepeatVisible,
                        hint: '••••••••••••',
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            _isPasswordRepeatVisible =
                                !_isPasswordRepeatVisible;
                            setState(() {});
                          },
                          icon: Icon(
                            !_isPasswordRepeatVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        isValid: _formValidator.putIfAbsent(
                          'repeat_password',
                          () => false,
                        ),
                        validatorListener: (String value) {
                          _formValidator['repeat_password'] =
                              value == _conPassword.text;
                          setState(() {});
                        },
                        errorMessage: Strings.of(
                          context,
                        )!.errorPasswordNotMatch,
                        semantic: 'repeat_password',
                      ),
                      SpacerV(value: Dimens.space12),
                      TextF(
                        autoFillHints: const [AutofillHints.telephoneNumber],
                        key: const Key('phone'),
                        focusNode: _fnPhone,
                        textInputAction: TextInputAction.done,
                        controller: _conPhone,
                        keyboardType: TextInputType.phone,
                        hint: Strings.of(context)!.phoneNumber,
                      ),
                      SpacerV(value: Dimens.space12),
                      CheckboxAgreement(
                        value: _isAgreed,
                        onChanged: (value) {
                          setState(() => _isAgreed = value ?? false);
                          setState(() {});
                        },
                        onTapTerms: () =>
                            context.pushNamed(Routes.termsOfService.name),
                        onTapPrivacy: () =>
                            context.pushNamed(Routes.privacyPolicy.name),
                      ),
                      SpacerV(value: Dimens.space24),
                      Button(
                        width: double.maxFinite,
                        title: Strings.of(context)!.next,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Palette.buttonDark
                            : Palette.button,
                        titleColor: Palette.text,
                        onPressed: (_formValidator.validate() && _isAgreed)
                            ? () {
                                final phone = _conPhone.text.trim();
                                context.read<AuthCubit>().register(
                                  RegisterParams(
                                    name: _conName.text.trim(),
                                    email: _conEmail.text,
                                    password: _conPassword.text,
                                    phone: phone.isEmpty ? null : phone,
                                  ),
                                );
                              }
                            : null,
                      ),
                      SpacerV(value: 32.w),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
