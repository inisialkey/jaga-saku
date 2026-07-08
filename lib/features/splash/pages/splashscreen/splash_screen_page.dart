import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.goNamed(Routes.onboarding.name);
    });
  }

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

        Center(
          child: Image.asset(
            Images.icLogoSplash,
            width: context.widthInPercent(55),
          ),
        ),

        Positioned(
          bottom: 28 + MediaQuery.of(context).padding.bottom,
          left: 0,
          right: 0,
          child: Text(
            Strings.of(context)!.versionLabel,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
