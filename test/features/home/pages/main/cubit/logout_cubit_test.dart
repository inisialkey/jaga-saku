import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/dependencies_injection.dart';
import 'package:jaga_saku/features/home/home.dart';

/// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../../../helpers/fake_path_provider_platform.dart';
import '../../../../../helpers/mocks.dart';

void main() {
  late LogoutCubit logoutCubit;
  late MockLogout mockLogout;

  const errorMessage = 'Error message';

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    FlutterSecureStorage.setMockInitialValues({});
    await serviceLocator(isUnitTest: true, prefixBox: 'logout_cubit_test_');
    mockLogout = MockLogout();
    logoutCubit = LogoutCubit(mockLogout, sl());
  });

  tearDown(() => logoutCubit.close());

  test('Initial state should be LogoutState.loading', () {
    expect(logoutCubit.state, const LogoutState.loading());
  });

  blocTest<LogoutCubit, LogoutState>(
    'logout success emits loading then success',
    build: () {
      when(
        () => mockLogout.call(any()),
      ).thenAnswer((_) async => const Right(null));
      return logoutCubit;
    },
    act: (cubit) => cubit.postLogout(),
    wait: const Duration(milliseconds: 100),
    expect: () => const [LogoutState.loading(), LogoutState.success()],
  );

  blocTest<LogoutCubit, LogoutState>(
    'logout failure emits loading then failure',
    build: () {
      when(
        () => mockLogout.call(any()),
      ).thenAnswer((_) async => const Left(ServerFailure(errorMessage)));
      return logoutCubit;
    },
    act: (cubit) => cubit.postLogout(),
    wait: const Duration(milliseconds: 100),
    expect: () => const [
      LogoutState.loading(),
      LogoutState.failure(ServerFailure(errorMessage)),
    ],
  );
}
