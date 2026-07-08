import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jaga_saku/core/core.dart';

void main() {
  // Wraps a widget in ScreenUtilInit (Dimens uses flutter_screenutil's `.sp`,
  // which throws unless ScreenUtil is initialized) + the app's light theme so
  // `context.colors` / the AppColors extension resolve.
  Widget themed(Widget child) => ScreenUtilInit(
    designSize: const Size(375, 667),
    builder: (context, _) => Theme(
      data: themeLight(context),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );

  goldenTest(
    'Button renders its states',
    fileName: 'button',
    builder: () => GoldenTestGroup(
      columns: 1,
      children: [
        GoldenTestScenario(
          name: 'enabled',
          child: themed(Button(title: 'Submit', onPressed: () {})),
        ),
        GoldenTestScenario(
          name: 'disabled',
          child: themed(const Button(title: 'Submit', onPressed: null)),
        ),
        GoldenTestScenario(
          name: 'custom color',
          child: themed(
            Button(title: 'Delete', color: Colors.red, onPressed: () {}),
          ),
        ),
      ],
    ),
  );
}
