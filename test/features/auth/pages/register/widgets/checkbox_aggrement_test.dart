import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/auth/auth.dart';
import '../../../../../helpers/mocks.dart';

void main() {
  Widget rootWidget(Widget body, {bool isDarkTheme = false}) => ScreenUtilInit(
    designSize: const Size(375, 667),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, _) => MaterialApp(
      localizationsDelegates: const [
        Strings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('en'),
      supportedLocales: L10n.all,
      theme: isDarkTheme
          ? themeDark(MockBuildContext())
          : themeLight(MockBuildContext()),
      home: Scaffold(body: Center(child: body)),
    ),
  );

  group('CheckboxAgreement', () {
    testWidgets('renders with unchecked state and correct labels', (
      tester,
    ) async {
      await tester.pumpWidget(
        rootWidget(CheckboxAgreement(value: false, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isFalse);
      // 'I agree to our ' is inside a TextSpan of Text.rich → find via RichText
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RichText && w.text.toPlainText().contains('I agree to our'),
        ),
        findsOneWidget,
      );
      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('renders with checked state', (tester) async {
      await tester.pumpWidget(
        rootWidget(CheckboxAgreement(value: true, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('tapping checkbox calls onChanged callback', (tester) async {
      bool? changedValue;
      await tester.pumpWidget(
        rootWidget(
          CheckboxAgreement(value: false, onChanged: (v) => changedValue = v),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(changedValue, isNotNull);
    });

    testWidgets('tapping Terms of Service calls onTapTerms callback', (
      tester,
    ) async {
      var termsTapped = false;
      await tester.pumpWidget(
        rootWidget(
          CheckboxAgreement(
            value: false,
            onChanged: (_) {},
            onTapTerms: () => termsTapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Terms of Service'));
      await tester.pump();

      expect(termsTapped, isTrue);
    });

    testWidgets('tapping Privacy Policy calls onTapPrivacy callback', (
      tester,
    ) async {
      var privacyTapped = false;
      await tester.pumpWidget(
        rootWidget(
          CheckboxAgreement(
            value: false,
            onChanged: (_) {},
            onTapPrivacy: () => privacyTapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Privacy Policy'));
      await tester.pump();

      expect(privacyTapped, isTrue);
    });
  });
}
