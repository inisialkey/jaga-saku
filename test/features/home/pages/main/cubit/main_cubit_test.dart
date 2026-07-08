import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/home/home.dart';

/// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../../../helpers/fake_path_provider_platform.dart';

void main() {
  late MainCubit mainCubit;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    await serviceLocator(isUnitTest: true, prefixBox: 'main_cubit_test_');
    mainCubit = MainCubit();
  });

  tearDown(() => mainCubit.close());

  test('Initial state should be tab(0)', () {
    expect(mainCubit.state, const MainState.tab(0));
    expect(mainCubit.currentIndex, 0);
  });

  blocTest<MainCubit, MainState>(
    'updateIndex emits new tab state',
    build: () => mainCubit,
    act: (cubit) => cubit.updateIndex(2),
    expect: () => [const MainState.tab(2)],
  );

  test('onBackPressed returns true when already at index 0', () {
    expect(mainCubit.onBackPressed(), true);
  });

  blocTest<MainCubit, MainState>(
    'onBackPressed returns false and navigates to 0 when not at index 0',
    build: () => mainCubit,
    seed: () => const MainState.tab(2),
    act: (cubit) {
      final result = cubit.onBackPressed();
      expect(result, false);
    },
    expect: () => [const MainState.tab(0)],
  );

  test('syncIndexFromPath updates index for known route', () {
    mainCubit.syncIndexFromPath('/settings');
    expect(mainCubit.currentIndex, 1);
  });

  test('syncIndexFromPath ignores unknown route', () {
    mainCubit.syncIndexFromPath('/unknown');
    expect(mainCubit.currentIndex, 0);
  });
}
