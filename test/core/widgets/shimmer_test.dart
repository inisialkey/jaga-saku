import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/core.dart';

void main() {
  Widget rootWidget(Widget body) => ScreenUtilInit(
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
      theme: AppTheme.light,
      home: body,
    ),
  );

  testWidgets('ListSkeleton renders a Shimmer with placeholder boxes', (
    tester,
  ) async {
    await tester.pumpWidget(rootWidget(const ListSkeleton(itemCount: 3)));
    // Never pumpAndSettle: the Shimmer controller repeats forever.
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(Shimmer), findsOneWidget);
    expect(find.byType(SkeletonBox), findsWidgets);
  });

  testWidgets('Shimmer disposes its controller when removed', (tester) async {
    await tester.pumpWidget(rootWidget(const ListSkeleton()));
    await tester.pump(const Duration(milliseconds: 300));

    // Replacing the tree tears down the Shimmer; a leaked ticker would throw
    // at teardown, so reaching the end of the test asserts clean disposal.
    await tester.pumpWidget(rootWidget(const SizedBox.shrink()));
    await tester.pump();

    expect(find.byType(Shimmer), findsNothing);
  });

  testWidgets('DashboardSkeleton renders a Shimmer with placeholder boxes', (
    tester,
  ) async {
    await tester.pumpWidget(rootWidget(const DashboardSkeleton()));
    // Never pumpAndSettle: the Shimmer controller repeats forever.
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(Shimmer), findsOneWidget);
    expect(find.byType(SkeletonBox), findsWidgets);
    // The animated branch masks the boxes with a single sweeping ShaderMask.
    expect(find.byType(ShaderMask), findsOneWidget);
  });

  testWidgets('DashboardSkeleton is static and settles under reduced motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      rootWidget(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: const DashboardSkeleton(),
          ),
        ),
      ),
    );
    // The reduced-motion branch paints a static wash (no infinite repeat), so
    // pumpAndSettle completes instead of timing out.
    await tester.pumpAndSettle();

    expect(find.byType(SkeletonBox), findsWidgets);
    // No sweep: the static branch replaces the ShaderMask with a ColorFiltered.
    expect(find.byType(ShaderMask), findsNothing);
  });

  testWidgets('SkeletonBox renders a circle when shape is circle', (
    tester,
  ) async {
    await tester.pumpWidget(
      rootWidget(
        const SkeletonBox(width: 40, height: 40, shape: BoxShape.circle),
      ),
    );

    final decoration =
        tester
                .widget<Container>(
                  find.descendant(
                    of: find.byType(SkeletonBox),
                    matching: find.byType(Container),
                  ),
                )
                .decoration!
            as BoxDecoration;
    expect(decoration.shape, BoxShape.circle);
    expect(decoration.borderRadius, isNull);
  });
}
