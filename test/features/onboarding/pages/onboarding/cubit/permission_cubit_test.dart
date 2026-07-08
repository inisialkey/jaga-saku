import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jaga_saku/features/onboarding/onboarding.dart';
import 'package:jaga_saku/core/utils/services/permission/app_permission.dart';
import 'package:jaga_saku/core/utils/services/permission/permission_result.dart';

import '../../../../../helpers/mocks.dart';

void main() {
  late MockPermissionService mockPermissionService;

  setUpAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    mockPermissionService = MockPermissionService();
  });

  test('initial state is PermissionState.initial', () {
    final cubit = PermissionCubit(mockPermissionService);
    expect(cubit.state, const PermissionState.initial());
    cubit.close();
  });

  blocTest<PermissionCubit, PermissionState>(
    'requestNotification emits granted when service returns granted',
    build: () {
      when(
        () =>
            mockPermissionService.requestPermission(AppPermission.notification),
      ).thenAnswer((_) async => PermissionResult.granted);
      return PermissionCubit(mockPermissionService);
    },
    act: (cubit) => cubit.requestNotification(),
    expect: () => const [PermissionState.granted()],
  );

  blocTest<PermissionCubit, PermissionState>(
    'requestNotification emits denied when service returns denied',
    build: () {
      when(
        () =>
            mockPermissionService.requestPermission(AppPermission.notification),
      ).thenAnswer((_) async => PermissionResult.denied);
      return PermissionCubit(mockPermissionService);
    },
    act: (cubit) => cubit.requestNotification(),
    expect: () => const [PermissionState.denied()],
  );

  blocTest<PermissionCubit, PermissionState>(
    'requestNotification emits permanentlyDenied when service returns permanentlyDenied',
    build: () {
      when(
        () =>
            mockPermissionService.requestPermission(AppPermission.notification),
      ).thenAnswer((_) async => PermissionResult.permanentlyDenied);
      return PermissionCubit(mockPermissionService);
    },
    act: (cubit) => cubit.requestNotification(),
    expect: () => const [PermissionState.permanentlyDenied()],
  );

  blocTest<PermissionCubit, PermissionState>(
    'requestNotification emits restricted when service returns restricted',
    build: () {
      when(
        () =>
            mockPermissionService.requestPermission(AppPermission.notification),
      ).thenAnswer((_) async => PermissionResult.restricted);
      return PermissionCubit(mockPermissionService);
    },
    act: (cubit) => cubit.requestNotification(),
    expect: () => const [PermissionState.restricted()],
  );

  blocTest<PermissionCubit, PermissionState>(
    'requestNotification emits granted when service returns limited',
    build: () {
      when(
        () =>
            mockPermissionService.requestPermission(AppPermission.notification),
      ).thenAnswer((_) async => PermissionResult.limited);
      return PermissionCubit(mockPermissionService);
    },
    act: (cubit) => cubit.requestNotification(),
    // limited notification is treated as usable — emits granted
    expect: () => const [PermissionState.granted()],
  );

  blocTest<PermissionCubit, PermissionState>(
    'requestNotification emits granted when service returns provisional',
    build: () {
      when(
        () =>
            mockPermissionService.requestPermission(AppPermission.notification),
      ).thenAnswer((_) async => PermissionResult.provisional);
      return PermissionCubit(mockPermissionService);
    },
    act: (cubit) => cubit.requestNotification(),
    // provisional notification is treated as usable — emits granted
    expect: () => const [PermissionState.granted()],
  );

  blocTest<PermissionCubit, PermissionState>(
    'checkNotification emits granted when service returns granted',
    build: () {
      when(
        () => mockPermissionService.checkPermission(AppPermission.notification),
      ).thenAnswer((_) async => PermissionResult.granted);
      return PermissionCubit(mockPermissionService);
    },
    act: (cubit) => cubit.checkNotification(),
    expect: () => const [PermissionState.granted()],
  );

  blocTest<PermissionCubit, PermissionState>(
    'checkNotification emits denied when service returns denied',
    build: () {
      when(
        () => mockPermissionService.checkPermission(AppPermission.notification),
      ).thenAnswer((_) async => PermissionResult.denied);
      return PermissionCubit(mockPermissionService);
    },
    act: (cubit) => cubit.checkNotification(),
    expect: () => const [PermissionState.denied()],
  );

  blocTest<PermissionCubit, PermissionState>(
    'checkNotification emits permanentlyDenied when service returns permanentlyDenied',
    build: () {
      when(
        () => mockPermissionService.checkPermission(AppPermission.notification),
      ).thenAnswer((_) async => PermissionResult.permanentlyDenied);
      return PermissionCubit(mockPermissionService);
    },
    act: (cubit) => cubit.checkNotification(),
    expect: () => const [PermissionState.permanentlyDenied()],
  );

  blocTest<PermissionCubit, PermissionState>(
    'checkNotification emits restricted when service returns restricted',
    build: () {
      when(
        () => mockPermissionService.checkPermission(AppPermission.notification),
      ).thenAnswer((_) async => PermissionResult.restricted);
      return PermissionCubit(mockPermissionService);
    },
    act: (cubit) => cubit.checkNotification(),
    expect: () => const [PermissionState.restricted()],
  );

  blocTest<PermissionCubit, PermissionState>(
    'checkNotification emits granted when service returns provisional',
    build: () {
      when(
        () => mockPermissionService.checkPermission(AppPermission.notification),
      ).thenAnswer((_) async => PermissionResult.provisional);
      return PermissionCubit(mockPermissionService);
    },
    act: (cubit) => cubit.checkNotification(),
    // provisional is treated as usable — emits granted
    expect: () => const [PermissionState.granted()],
  );
}
