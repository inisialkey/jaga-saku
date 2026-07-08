import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';

import '../../../../helpers/mocks.dart';

class MockUsersCubit extends MockCubit<UsersState> implements UsersCubit {}

void main() {
  late UsersCubit usersCubit;

  const tUser = User(
    id: 'u1',
    name: 'Test User',
    email: 'user@mock.com',
    role: 'user',
    isActive: true,
    createdAt: 'c',
    updatedAt: 'u',
  );

  setUp(() {
    usersCubit = MockUsersCubit();
  });

  Widget buildApp() => ScreenUtilInit(
    designSize: const Size(375, 667),
    minTextAdapt: true,
    builder: (_, _) => MaterialApp(
      localizationsDelegates: const [
        Strings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('en'),
      supportedLocales: L10n.all,
      theme: themeLight(MockBuildContext()),
      home: BlocProvider<UsersCubit>.value(
        value: usersCubit,
        child: const DashboardPage(),
      ),
    ),
  );

  testWidgets('renders loaded list tiles', (tester) async {
    when(() => usersCubit.state).thenReturn(
      const UsersState.loaded(
        page: Page<User>(items: [tUser], meta: PaginationMeta()),
        items: [tUser],
      ),
    );

    await tester.pumpWidget(buildApp());
    await tester.pump();

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('user@mock.com'), findsOneWidget);
  });

  testWidgets('renders skeleton loader', (tester) async {
    when(() => usersCubit.state).thenReturn(const UsersState.loading());

    await tester.pumpWidget(buildApp());
    await tester.pump();

    expect(find.byType(ListSkeleton), findsOneWidget);
  });
}
