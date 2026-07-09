import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

/// Standard page scaffold (style guide §11). Applies the themed background,
/// dismisses the keyboard on tap-away, and optionally pads the body with the
/// default page padding.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.padded = false,
    this.safeArea = true,
    this.extendBody = false,
    this.backgroundColor,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Wrap [body] in the default horizontal page padding (16).
  final bool padded;
  final bool safeArea;
  final bool extendBody;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    Widget content = body;
    if (padded) {
      content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: content,
      );
    }
    if (safeArea) {
      content = SafeArea(child: content);
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        extendBody: extendBody,
        appBar: appBar,
        body: content,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }
}
