import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/core/utils/services/tx_change_notifier.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_file.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_preview.dart';
import 'package:jaga_saku/features/backup/domain/usecases/preview_backup.dart';
import 'package:jaga_saku/features/backup/pages/backup/cubit/backup_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockExportBackup exportBackup;
  late MockValidateBackup validateBackup;
  late MockRestoreBackup restoreBackup;
  late MockBackupFileService fileService;
  late MockSettingsService settings;
  late TxChangeNotifier txChanges;
  late int pingCount;
  late StreamSubscription<void> pingSub;
  const previewBackup = PreviewBackup();

  const file = BackupFile(
    schemaVersion: 7,
    exportedAt: 1700000000000,
    itemCount: 4,
    content: '{"x":1}',
  );

  const data = BackupData(
    accounts: [
      <String, Object?>{'id': 1, 'name': 'A', 'type': 'cash', 'created_at': 0},
    ],
    transactions: [
      <String, Object?>{
        'id': 1,
        'type': 'expense',
        'amount': 1,
        'account_id': 1,
        'date': 0,
        'created_at': 0,
      },
    ],
  );
  final preview = previewBackup(data);

  setUp(() {
    exportBackup = MockExportBackup();
    validateBackup = MockValidateBackup();
    restoreBackup = MockRestoreBackup();
    fileService = MockBackupFileService();
    settings = MockSettingsService();
    txChanges = TxChangeNotifier();
    pingCount = 0;
    pingSub = txChanges.changes.listen((_) => pingCount++);
    // Defaults so the happy paths (loadMeta, delivery) don't throw.
    when(() => settings.getString(any())).thenAnswer((_) async => null);
    when(() => settings.setString(any(), any())).thenAnswer((_) async {});
    when(
      () => fileService.write(any(), any()),
    ).thenAnswer((_) async => '/tmp/backup.json');
    when(() => fileService.share(any())).thenAnswer((_) async {});
  });

  tearDown(() async {
    await pingSub.cancel();
    txChanges.dispose();
  });

  BackupCubit build() => BackupCubit(
    exportBackup: exportBackup,
    validateBackup: validateBackup,
    previewBackup: previewBackup,
    restoreBackup: restoreBackup,
    backupFileService: fileService,
    settingsService: settings,
    txChangeNotifier: txChanges,
  );

  // ── export ────────────────────────────────────────────────────────────────
  blocTest<BackupCubit, BackupState>(
    'export success emits [exporting, exportSuccess, idle] and delivers the file',
    setUp: () => when(
      () => exportBackup(any()),
    ).thenAnswer((_) async => const Right<Failure, BackupFile>(file)),
    build: build,
    act: (cubit) => cubit.exportBackup(),
    expect: () => [
      const BackupState.exporting(),
      const BackupState.exportSuccess(),
      isA<BackupIdle>(),
    ],
    verify: (_) {
      verify(() => fileService.write(any(), any())).called(1);
      verify(() => fileService.share(any())).called(1);
      verify(
        () => settings.setString('backup.lastExportedAt', any()),
      ).called(1);
    },
  );

  blocTest<BackupCubit, BackupState>(
    'export failure emits [exporting, failure] and delivers nothing',
    setUp: () => when(
      () => exportBackup(any()),
    ).thenAnswer((_) async => const Left<Failure, BackupFile>(CacheFailure())),
    build: build,
    act: (cubit) => cubit.exportBackup(),
    expect: () => const [
      BackupState.exporting(),
      BackupState.failure(CacheFailure()),
    ],
    verify: (_) => verifyNever(() => fileService.write(any(), any())),
  );

  // ── pick + validate ─────────────────────────────────────────────────────────
  blocTest<BackupCubit, BackupState>(
    'a cancelled picker emits nothing and stays idle',
    setUp: () =>
        when(() => fileService.pickJson()).thenAnswer((_) async => null),
    build: build,
    act: (cubit) => cubit.pickAndValidate(),
    expect: () => const <BackupState>[],
  );

  blocTest<BackupCubit, BackupState>(
    'validate success emits [validating, previewReady] with counts',
    setUp: () {
      when(
        () => fileService.pickJson(),
      ).thenAnswer((_) async => '/tmp/pick.json');
      when(() => fileService.read(any())).thenAnswer((_) async => '{"x":1}');
      when(
        () => validateBackup(any()),
      ).thenAnswer((_) async => const Right<Failure, BackupData>(data));
    },
    build: build,
    act: (cubit) => cubit.pickAndValidate(),
    expect: () => [
      const BackupState.validating(),
      isA<BackupPreviewReady>()
          .having((s) => s.preview.accounts, 'accounts', 1)
          .having((s) => s.preview.transactions, 'transactions', 1),
    ],
  );

  blocTest<BackupCubit, BackupState>(
    'validate invalid emits [validating, failure(invalidFile)]',
    setUp: () {
      when(
        () => fileService.pickJson(),
      ).thenAnswer((_) async => '/tmp/pick.json');
      when(() => fileService.read(any())).thenAnswer((_) async => 'nope');
      when(() => validateBackup(any())).thenAnswer(
        (_) async => const Left<Failure, BackupData>(
          BackupFailure(BackupFailureReason.invalidFile),
        ),
      );
    },
    build: build,
    act: (cubit) => cubit.pickAndValidate(),
    expect: () => const [
      BackupState.validating(),
      BackupState.failure(BackupFailure(BackupFailureReason.invalidFile)),
    ],
  );

  // ── restore ─────────────────────────────────────────────────────────────────
  blocTest<BackupCubit, BackupState>(
    'restore success: safety backup runs before restore; pings; [restoring, restoreSuccess, idle]',
    setUp: () {
      when(
        () => exportBackup(any()),
      ).thenAnswer((_) async => const Right<Failure, BackupFile>(file));
      when(
        () => restoreBackup(any()),
      ).thenAnswer((_) async => Right<Failure, BackupPreview>(preview));
    },
    build: build,
    seed: () => BackupState.previewReady(preview: preview, data: data),
    act: (cubit) => cubit.restore(),
    expect: () => [
      const BackupState.restoring(),
      BackupState.restoreSuccess(preview),
      isA<BackupIdle>(),
    ],
    verify: (_) {
      verifyInOrder([() => exportBackup(any()), () => restoreBackup(any())]);
      verify(() => fileService.write(any(), any())).called(1); // safety file
      expect(pingCount, 1);
    },
  );

  blocTest<BackupCubit, BackupState>(
    'restore aborts when the safety write fails: [restoring, failure], no restore, no ping',
    setUp: () {
      when(
        () => exportBackup(any()),
      ).thenAnswer((_) async => const Right<Failure, BackupFile>(file));
      when(
        () => fileService.write(any(), any()),
      ).thenThrow(Exception('disk full'));
    },
    build: build,
    seed: () => BackupState.previewReady(preview: preview, data: data),
    act: (cubit) => cubit.restore(),
    expect: () => const [
      BackupState.restoring(),
      BackupState.failure(BackupFailure(BackupFailureReason.io)),
    ],
    verify: (_) {
      verifyNever(() => restoreBackup(any()));
      expect(pingCount, 0);
    },
  );

  blocTest<BackupCubit, BackupState>(
    'restore failure emits [restoring, failure] and does not ping',
    setUp: () {
      when(
        () => exportBackup(any()),
      ).thenAnswer((_) async => const Right<Failure, BackupFile>(file));
      when(() => restoreBackup(any())).thenAnswer(
        (_) async => const Left<Failure, BackupPreview>(CacheFailure()),
      );
    },
    build: build,
    seed: () => BackupState.previewReady(preview: preview, data: data),
    act: (cubit) => cubit.restore(),
    expect: () => const [
      BackupState.restoring(),
      BackupState.failure(CacheFailure()),
    ],
    verify: (_) => expect(pingCount, 0),
  );
}
