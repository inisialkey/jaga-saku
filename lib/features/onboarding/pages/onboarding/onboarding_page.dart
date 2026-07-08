import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) => Parent(
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
          bottom: 220.w,
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
                  Strings.of(context)!.onboardingTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.sp,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SpacerV(value: Dimens.space12),
                Text(
                  Strings.of(context)!.onboardingSubtitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
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
                Button(
                  width: double.maxFinite,
                  title: Strings.of(context)!.joinForFree,
                  onPressed: () => context.pushNamed(Routes.register.name),
                  color: Theme.of(context).primaryColor,
                  titleColor: Colors.white,
                ),
                SpacerV(value: Dimens.space12),
                Button(
                  width: double.maxFinite,
                  title: Strings.of(context)!.login,
                  onPressed: () => context.pushNamed(Routes.login.name),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Palette.buttonDark
                      : Palette.button,
                  titleColor: Palette.text,
                ),
                SpacerV(value: Dimens.space24),
                Text(
                  Strings.of(context)!.measureWithoutLogin,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Palette.textDark
                        : Palette.text,
                  ),
                ),
                SpacerV(value: 32.w),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
