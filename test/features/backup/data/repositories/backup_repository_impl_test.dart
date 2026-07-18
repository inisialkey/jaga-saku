import 'package:flutter_test/flutter_test.dart';
import 'package:jaga_saku/core/database/migrations.dart';
import 'package:jaga_saku/core/error/error.dart';
import 'package:jaga_saku/features/backup/data/models/backup_serializer.dart';
import 'package:jaga_saku/features/backup/data/repositories/backup_repository_impl.dart';
import 'package:jaga_saku/features/backup/domain/entities/backup_data.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbackValues);

  late MockBackupLocalDatasource datasource;
  late MockTxChangeNotifier notifier;
  late BackupRepositoryImpl repository;

  const serializer = BackupSerializer();

  setUp(() {
    datasource = MockBackupLocalDatasource();
    notifier = MockTxChangeNotifier();
    repository = BackupRepositoryImpl(datasource, notifier);
  });

  Map<String, List<Map<String, Object?>>> tablesFixture() => {
    'settings': [
      <String, Object?>{'key': 'theme', 'value': 'dark'},
    ],
    'accounts': [
      <String, Object?>{
        'id': 1,
        'name': 'Cash',
        'type': 'cash',
        'created_at': 0,
      },
    ],
    'categories': [
      <String, Object?>{
        'id': 1,
        'name': 'Makan',
        'type': 'expense',
        'created_at': 0,
      },
      <String, Object?>{
        'id': 2,
        'name': 'Gaji',
        'type': 'income',
        'created_at': 0,
      },
    ],
    'transactions': const [],
    'budgets': const [],
    'tx_templates': const [],
    'recurring': const [],
  };

  String envelope(int version) => serializer.encode(
    schemaVersion: version,
    exportedAt: 1,
    data: const BackupData(
      accounts: [
        <String, Object?>{
          'id': 1,
          'name': 'A',
          'type': 'cash',
          'created_at': 0,
        },
      ],
    ),
  );

  group('export', () {
    test(
      'success → Right(BackupFile) bound to Migrations.latestVersion',
      () async {
        when(
          () => datasource.readAllTables(),
        ).thenAnswer((_) async => tablesFixture());

        final file = (await repository.export()).getRight().toNullable();

        expect(file, isNotNull);
        expect(file!.schemaVersion, Migrations.latestVersion);
        // 1 settings + 1 account + 2 categories = 4 rows.
        expect(file.itemCount, 4);
        // content is a real envelope that round-trips back to the same rows.
        final decoded = serializer.decode(file.content);
        expect(decoded.schemaVersion, Migrations.latestVersion);
        expect(decoded.data.categories, hasLength(2));
        // export is a read (stays `_guard`) — never pings.
        verifyNever(() => notifier.ping());
      },
    );

    test('datasource throws → Left(CacheFailure), never throws', () async {
      when(() => datasource.readAllTables()).thenThrow(Exception('boom'));

      final result = await repository.export();

      expect(result.getLeft().toNullable(), isA<CacheFailure>());
    });
  });

  group('validate maps each reason to a BackupFailure', () {
    test('non-JSON → invalidFile', () async {
      expect(
        (await repository.validate('nope')).getLeft().toNullable(),
        const BackupFailure(BackupFailureReason.invalidFile),
      );
    });

    test('missing envelope → invalidFile', () async {
      expect(
        (await repository.validate('{}')).getLeft().toNullable(),
        const BackupFailure(BackupFailureReason.invalidFile),
      );
    });

    test('newer schemaVersion → unsupportedVersion', () async {
      expect(
        (await repository.validate(
          envelope(Migrations.latestVersion + 1),
        )).getLeft().toNullable(),
        const BackupFailure(BackupFailureReason.unsupportedVersion),
      );
    });

    test('corrupt data → corrupt', () async {
      final json = serializer.encode(
        schemaVersion: Migrations.latestVersion,
        exportedAt: 1,
        data: const BackupData(
          accounts: [
            <String, Object?>{
              'id': 1,
              'name': 'A',
              'type': 'cash',
              'created_at': 0,
            },
            <String, Object?>{
              'id': 1,
              'name': 'B',
              'type': 'cash',
              'created_at': 0,
            },
          ],
        ),
      );
      expect(
        (await repository.validate(json)).getLeft().toNullable(),
        const BackupFailure(BackupFailureReason.corrupt),
      );
    });

    test('valid → Right(BackupData)', () async {
      final result = await repository.validate(
        envelope(Migrations.latestVersion),
      );
      expect(result.isRight(), isTrue);
      expect(result.getRight().toNullable()!.accounts, hasLength(1));
    });
  });

  group('restore', () {
    test('success → Right(BackupPreview) with per-table counts', () async {
      when(() => datasource.restore(any())).thenAnswer((_) async {});

      const data = BackupData(
        accounts: [
          <String, Object?>{
            'id': 1,
            'name': 'A',
            'type': 'cash',
            'created_at': 0,
          },
          <String, Object?>{
            'id': 2,
            'name': 'B',
            'type': 'bank',
            'created_at': 0,
          },
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
      final preview = (await repository.restore(data)).getRight().toNullable();

      expect(preview, isNotNull);
      expect(preview!.accounts, 2);
      expect(preview.transactions, 1);
      expect(preview.categories, 0);
      // restore is the only backup write (`_guardWrite`) — a success pings.
      verify(() => notifier.ping()).called(1);
    });

    test('datasource throws → Left(CacheFailure)', () async {
      when(() => datasource.restore(any())).thenThrow(StateError('rollback'));

      final result = await repository.restore(const BackupData());

      expect(result.getLeft().toNullable(), isA<CacheFailure>());
      // A Left write never pings — `_guardWrite` gates on `isRight()`.
      verifyNever(() => notifier.ping());
    });
  });
}
