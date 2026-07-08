import 'package:flutter/material.dart';

class Parent extends StatelessWidget {
  final Widget? child;
  final PreferredSizeWidget? appBar;
  final bool avoidBottomInset;
  final Widget? floatingButton;
  final Widget? bottomNavigation;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final Key? scaffoldKey;
  final bool extendBodyBehindAppBar;
  final bool extendBody;

  const Parent({
    super.key,
    this.child,
    this.appBar,
    this.avoidBottomInset = true,
    this.floatingButton,
    this.backgroundColor,
    this.bottomNavigation,
    this.drawer,
    this.scaffoldKey,
    this.endDrawer,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    child: Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: avoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
      appBar: appBar,
      body: child,
      drawer: drawer,
      endDrawer: endDrawer,
      floatingActionButton: floatingButton,
      bottomNavigationBar: bottomNavigation,
    ),
  );
}
