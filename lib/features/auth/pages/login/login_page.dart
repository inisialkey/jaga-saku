import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/auth/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();

  bool _isPasswordVisible = false;

  final _fnEmail = FocusNode();
  final _fnPassword = FocusNode();

  final _formValidator = <String, bool>{};

  @override
  void dispose() {
    _conEmail.dispose();
    _conPassword.dispose();
    _fnEmail.dispose();
    _fnPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Parent(
    avoidBottomInset: false,
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
                    Strings.of(context)!.loginWelcomeBack,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SpacerV(value: Dimens.space12),
                  Text(
                    Strings.of(context)!.loginSubtitle,
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
                      _loginForm(),
                      SpacerV(value: Dimens.space24),
                      Text(
                        Strings.of(context)!.loginTerms,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
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

  Widget _loginForm() => Column(
    children: [
      TextF(
        autoFillHints: const [AutofillHints.email],
        key: const Key('email'),
        focusNode: _fnEmail,
        textInputAction: TextInputAction.next,
        controller: _conEmail,
        keyboardType: TextInputType.emailAddress,
        hint: Strings.of(context)!.loginEmailHint,
        isValid: _formValidator.putIfAbsent('email', () => false),
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
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
        ),
        isValid: _formValidator.putIfAbsent('password', () => false),
        validatorListener: (String value) {
          _formValidator['password'] = value.length > 5;
          setState(() {});
        },
        errorMessage: Strings.of(context)!.errorPasswordLength,
      ),
      SpacerV(value: Dimens.space12),
      Align(
        alignment: Alignment.centerRight,
        child: Text(
          Strings.of(context)!.loginForgotPassword,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? Palette.textDark
                : Palette.text,
          ),
        ),
      ),
      SpacerV(value: Dimens.space24),
      Button(
        width: double.maxFinite,
        title: Strings.of(context)!.login,
        onPressed: _formValidator.validate()
            ? () => context.read<AuthCubit>().login(
                LoginParams(email: _conEmail.text, password: _conPassword.text),
              )
            : null,
      ),
    ],
  );
}
