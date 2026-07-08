import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/settings/settings.dart';

void main() {
  Widget host(Widget child) => ScreenUtilInit(
    designSize: const Size(375, 667),
    builder: (context, _) => MaterialApp(
      localizationsDelegates: const [
        Strings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      locale: const Locale('en'),
      theme: themeLight(context),
      home: child,
    ),
  );

  Button button(WidgetTester tester) =>
      tester.widget<Button>(find.byType(Button));

  testWidgets('EditTextFieldPage enables Save only once input is valid', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(EditTextFieldPage(config: EditTextFieldConfig.email())),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('email')), findsOneWidget);
    expect(
      button(tester).onPressed,
      isNull,
      reason: 'Save disabled with empty field',
    );

    await tester.enterText(find.byKey(const Key('email')), 'user@mock.com');
    await tester.pump(const Duration(milliseconds: 500));

    expect(
      button(tester).onPressed,
      isNotNull,
      reason: 'Save enabled once the email is valid',
    );
  });

  testWidgets('EditTextFieldPage.age renders the unit label', (tester) async {
    await tester.pumpWidget(
      host(EditTextFieldPage(config: EditTextFieldConfig.age())),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('age')), findsOneWidget);
    // age config carries a trailing unit label — rendered beside the field.
    expect(find.text('Year Old'), findsOneWidget);
  });
}
